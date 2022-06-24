<?php

namespace app\admin\controller\customers;

use app\common\controller\Backend;
use app\push\controller\Events;
use think\Config;
use think\Db;

/**
 * 数据录入
 *
 * @icon fa fa-circle-o
 */
class Record extends Backend
{

    /**
     * Index模型对象
     * @var \app\admin\model\customers\Index
     */
    protected $model = null;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\customers\Index;
        $this->adminModel = new \app\admin\model\Admin;
        $this->view->assign("sourceList", $this->model->getSourceList());
        $this->view->assign("traceStatusList", $this->model->getTraceStatusList());
        $this->view->assign("allotStatusList", $this->model->getAllotStatusList());
        $this->view->assign("statusList", $this->model->getStatusList());
    }



    /**
     * 默认生成的控制器所继承的父类中有index/add/edit/del/multi五个基础方法、destroy/restore/recyclebin三个回收站方法
     * 因此在当前控制器中可不用编写增删改查的代码,除非需要自己控制这部分逻辑
     * 需要将application/admin/library/traits/Backend.php中对应的方法复制到当前控制器,然后进行修改
     */


    /**
     * 查看
     */
    public function index()
    {
        //当前是否为关联查询
        $this->relationSearch = true;
        //设置过滤方法
        $this->request->filter(['strip_tags', 'trim']);
        if ($this->request->isAjax()) {
            //如果发送的来源是Selectpage，则转发到Selectpage
            if ($this->request->request('keyField')) {
                return $this->selectpage();
            }
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();

            $list = $this->model
                    ->with(['created'])
                    ->where($where)
                    ->where(['created_id'=>$this->auth->id])
                    ->order($sort, $order)
                    ->paginate($limit);

            foreach ($list as $row) {
                
                $row->getRelation('created')->visible(['nickname']);
            }

            $result = array("total" => $list->total(), "rows" => $list->items());

            return json($result);
        }
        return $this->view->fetch();
    }

    /**
     * 添加
     */
    public function add()
    {
        if ($this->request->isPost()) {
            $params = $this->request->post("row/a");
            if ($params) {
                $params = $this->preExcludeFields($params);

                if ($this->dataLimit && $this->dataLimitFieldAutoFill) {
                    $params[$this->dataLimitField] = $this->auth->id;
                }
                $result = false;
                Db::startTrans();
                try {
                    //是否采用模型验证
                    if ($this->modelValidate) {
                        $name = str_replace("\\model\\", "\\validate\\", get_class($this->model));
                        $validate = is_bool($this->modelValidate) ? ($this->modelSceneValidate ? $name . '.add' : $name) : $this->modelValidate;
                        $this->model->validateFailException(true)->validate($validate);
                    }
                    if ($params['mobile'] != '') {
                        $check = $this->model->where(['mobile'=>$params['mobile']])->count();
                        if ($check) $this->error('该手机号码已经存在');
                    }
                    // 查询所有销售
                    $users = [];
                    $sales = Db::name('auth_group_access')
                        ->alias('a')
                        ->field(['b.id'])
                        ->join('__ADMIN__ b','a.uid=b.id')
                        ->where(['a.group_id'=>'4','b.status'=>[['=','normal'],['=','online'],'OR']])
                        ->select();

                    // 统计每个在线销售未成交线索数量
                    for ($i=0;$i<count($sales);$i++) {
                        $sales[$i]['count'] = $this->model->where(['admin_id'=>$sales[$i]['id'],'status'=>'0'])->count();
                        if ($sales[$i]['count'] < Config::get('site.max_customers')) {
                            array_push($users, $sales[$i]);
                        }
                    }
                    // 给满足条件的销售分配线索，优先分配给客户少的，如果没有则进入公海
                    if (count($users) > 0) {
                        $res = $this->multiArraySort($users,'count');
                        $params['admin_id'] = $res[0]['id'];
                        $params['allot_status'] = '1';
                        // 发送线索分配提醒
                        $data = [
                            'type' => 'clues',
                            'name' => $params['name'],
                            'admin_id' => $res[0]['id']
                        ];
                        Events::onMessage(null,json_encode($data));
                    }
                    $params['created_id'] = $this->auth->id;
                    $result = $this->model->allowField(true)->save($params);
                    Db::commit();
                } catch (ValidateException $e) {
                    Db::rollback();
                    $this->error($e->getMessage());
                } catch (PDOException $e) {
                    Db::rollback();
                    $this->error($e->getMessage());
                } catch (Exception $e) {
                    Db::rollback();
                    $this->error($e->getMessage());
                }
                if ($result !== false) {
                    $this->success();
                } else {
                    $this->error(__('No rows were inserted'));
                }
            }
            $this->error(__('Parameter %s can not be empty', ''));
        }
        return $this->view->fetch();
    }

    // 二维数组按指定字段排序
    protected function multiArraySort($arr, $field, $sort_order = SORT_ASC, $sort_flags = SORT_REGULAR)
    {
        // 异常判断
        if (!$arr || !is_array($arr) || !$field) {
            return $arr;
        }

        // 将指定字段的值存进数组
        $tmp = [];
        foreach ($arr as $k => $v) {
            $tmp[$k] = $v[$field];
        }
        if (!$tmp) {
            return $arr;
        }

        // 调用php内置array_multisort函数
        array_multisort($tmp, $sort_order, $sort_flags, $arr);
        return $arr;
    }


}

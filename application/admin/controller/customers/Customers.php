<?php

namespace app\admin\controller\customers;

use app\common\controller\Backend;
use think\Db;

/**
 * 客户列表
 *
 * @icon fa fa-circle-o
 */
class Customers extends Backend
{

    /**
     * Customers模型对象
     * @var \app\admin\model\customers\Customers
     */
    protected $model = null;
    protected $dataLimit = 'auth'; //默认基类中为false，表示不启用，可额外使用auth和personal两个值
    protected $dataLimitField = 'admin_id'; //数据关联字段,当前控制器对应的模型表中必须存在该字段
    protected $selectpageFields = "id,name,mobile";

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\customers\Customers;
        $this->logsModel = new \app\admin\model\customers\Logs;
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
                    ->with(['admin','created'])
                    ->where($where)
                    ->where(['allot_status'=>'1','customers.status'=>'0'])
                    ->order($sort, $order)
                    ->paginate($limit);

            foreach ($list as $row) {
                
                $row->getRelation('admin')->visible(['nickname']);
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
                    $params['admin_id'] = $this->auth->id;
                    $params['created_id'] = $this->auth->id;
                    $params['allot_status'] = '1';
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

    /**
     * 跟进记录
     */
    public function claim($ids=null)
    {
        if ($this->request->isPost()) {
            $params = $this->request->param('row/a');
            $params['trace_status_info'] = isset($params['trace_status_info']) ? $params['trace_status_info']: '0';
            $this->model->save(['trace_status'=>$params['trace_status'],'trace_status_info'=>$params['trace_status_info']],['id'=>$ids]);
            $params['admin_id'] = $this->auth->id;
            unset($params['status']);
            $this->logsModel->save($params);
            $this->success();
            exit;
        }
        $row['info'] = $this->model->field(['id','trace_status','trace_status_info','status'])->where(['id'=>$ids])->find();
        $row['list'] = $this->logsModel
            ->alias('a')
            ->field(['a.id','a.admin_id','a.trace_note','a.next_trace_note','a.next_trace_time','a.trace_status','a.trace_status_info','a.createtime','b.name'])
            ->join('__CUSTOMERS__ b','a.customers_id=b.id')
            ->where(['a.customers_id'=>$ids])
            ->order(['a.id'=>'DESC'])
            ->paginate(10);
        for ($i=0;$i<count($row['list']);$i++) {
            $row['list'][$i]['nickname'] = Db::name('admin')->where(['id'=>$row['list'][$i]['admin_id']])->value('nickname');
        }
        $row['empty'] = '<tr class="no-records-found"><td colspan="8">暂无跟进记录</td></tr>';
        $this->view->assign("row", $row);
        return $this->view->fetch();
    }

    /**
     * 放回公海
     */
    public function ocean($ids=null)
    {
        $data = [
            'admin_id' => null,
            'last_admin_name' => $this->auth->nickname,
            'last_admin_change' => time(),
            'entry_time' => time(),
            'allot_status' => '0'
        ];
        $this->model->save($data,['id'=>$ids]);
        $this->success();
    }

    /**
     * 线索成交
     */
    public function traded($ids=null)
    {
        if ($this->request->isPost()) {
            $params = $this->request->param('row/a');
            $params['status'] = 1;
            $this->model->save($params,['id'=>$ids]);
            $this->success();
            exit;
        }
        $row = $this->model->field(['id','name','contact','mobile'])->where(['id'=>$ids])->find();
        $this->view->assign('row',$row);
        return $this->view->fetch();
    }

}

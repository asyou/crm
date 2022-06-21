<?php

namespace app\admin\controller\customers;

use app\common\controller\Backend;
use think\Db;

/**
 * 公海客户
 *
 * @icon fa fa-circle-o
 */
class Index extends Backend
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
                    ->where(['allot_status'=>'0'])
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

    /**
     * 线索分配
     * @param array $ids 线索IDs
     * @return mix
     */
    public function batch($ids = null)
    {
        if ($this->request->isPost()) {
            $params = $this->request->param();
            // $nickname = \think\Db::name('admin')->where(['id'=>$params['admin_id']])->value('nickname');
            $this->model->save(['admin_id'=>$params['row']['admin_id'],'last_admin_change'=>time(),'allot_status'=>'1'],['id'=>['IN',$ids]]);
            $this->success('批量分配成功');
        }
        return $this->view->fetch();
    }

    /**
     * 线索认领
     * @param integer $ids 线索ID
     * @return mix
     */
    public function claim($ids = null)
    {
        $check = $this->adminModel->field(['status'])->where(['id'=>$this->auth->id])->find();
        if ($check['status'] == 'offline') {
            $this->error('离线状态不可认领线索，请先切换');
        } else {
            $info = $this->model->where(['id'=>$ids])->find();
            $data = [
                'admin_id'=>$this->auth->id,
                'last_admin_change'=>time(),
                'allot_status'=>'1'
            ];
            if ($info['admin_id']) {
                $data['last_admin_name'] = $this->adminModel->where(['id'=>$info['admin_id']])->value('nickname');
            }
            $this->model->save($data,['id'=>$ids]);
            $this->success('认领成功');
        }
    }

}

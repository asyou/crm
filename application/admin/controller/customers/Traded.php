<?php

namespace app\admin\controller\customers;

use app\common\controller\Backend;
use think\Db;

/**
 * 成交客户
 *
 * @icon fa fa-circle-o
 */
class Traded extends Backend
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
        $this->noticesModel = new \app\admin\model\customers\Notices;
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
                    ->with(['admin','created','school'])
                    ->where($where)
                    ->where(['cr_customers.status'=>['IN',[1,2]]])
                    ->order($sort, $order)
                    ->paginate($limit);

            foreach ($list as $row) {
                
                $row->getRelation('admin')->visible(['nickname']);
                $row->getRelation('created')->visible(['nickname']);
                $row->getRelation('school')->visible(['name']);
            }

            $result = array("total" => $list->total(), "rows" => $list->items());

            return json($result);
        }
        return $this->view->fetch();
    }

    /**
     * 编辑
     */
    public function edit($ids = null)
    {
        $row = $this->model->get($ids);
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        $adminIds = $this->getDataLimitAdminIds();
        if (is_array($adminIds)) {
            if (!in_array($row[$this->dataLimitField], $adminIds)) {
                $this->error(__('You have no permission'));
            }
        }
        if ($this->request->isPost()) {
            $params = $this->request->post("row/a");
            if ($params) {
                $params = $this->preExcludeFields($params);
                $result = false;
                Db::startTrans();
                try {
                    //是否采用模型验证
                    if ($this->modelValidate) {
                        $name = str_replace("\\model\\", "\\validate\\", get_class($this->model));
                        $validate = is_bool($this->modelValidate) ? ($this->modelSceneValidate ? $name . '.edit' : $name) : $this->modelValidate;
                        $row->validateFailException(true)->validate($validate);
                    }
                    $result = $row->allowField(true)->save($params);
                    // 添加通知
                    if ($row->status == '2') {
                        $check = $this->noticesModel->where(['customers_id'=>$row->id])->count();
                        if (!$check) {
                            $nickname = $this->adminModel->where(['id'=>$row->admin_id])->value('nickname');
                            $notices = [
                                'admin_id' => $row->admin_id,
                                'customers_id' => $row->id,
                                'msg' => "恭喜{$nickname}跟进的客户〖{$row->name}〗已经成交！"
                            ];
                            $this->noticesModel->save($notices);
                        }
                    }
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
                    $this->error(__('No rows were updated'));
                }
            }
            $this->error(__('Parameter %s can not be empty', ''));
        }
        $this->view->assign("row", $row);
        return $this->view->fetch();
    }

}

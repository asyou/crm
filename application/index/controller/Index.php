<?php

namespace app\index\controller;

use app\common\controller\Frontend;
use app\push\controller\Events;
use think\Config;
use think\Db;

class Index extends Frontend
{

    protected $noNeedLogin = ['*'];
    protected $noNeedRight = ['*'];
    protected $layout = '';

    public function index()
    {
        return $this->view->fetch();
    }

    public function douyin()
    {
        $params = $this->request->param();

        $contact = '';
        if (isset($params['weixin'])) $contact.= '微信'.$params['weixin'];
        if (isset($params['qq'])) $contact.= ',qq'.$params['qq'];
        $clues = [
            'created_id' => '0',
            'name' => isset($params['name']) ? $params['name'] : '未填写',
            'contact' => $contact,
            'mobile' => isset($params['telphone']) ? $params['telphone'] : '',
            'source' => '2', // 抖音
            'note' => $params['gender'].','.$params['location']
        ];
        // print_r($clues);exit;
        $adminModel = new \app\admin\model\Admin;
        $customersModel = new \app\admin\model\customers\Index;
        // 检查手机号码是否已存在
        $count = false;
        if ($clues['mobile']) {
            $count = $customersModel->where(['mobile'=>$clues['mobile']])->count();
        }
        if (!$count) {
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
                $sales[$i]['count'] = $customersModel->where(['admin_id'=>$sales[$i]['id'],'status'=>'0'])->count();
                if ($sales[$i]['count'] < Config::get('site.max_customers')) {
                    array_push($users, $sales[$i]);
                }
            }
            // 给满足条件的销售分配线索，优先分配给客户少的，如果没有则进入公海
            if (count($users) > 0) {
                $res = $this->multiArraySort($users,'count');
                $clues['admin_id'] = $res[0]['id'];
                $clues['allot_status'] = '1';
                // 发送线索分配提醒
                $data = [
                    'type' => 'clues',
                    'name' => $clues['name'],
                    'admin_id' => $res[0]['id']
                ];
                Events::onMessage(null,json_encode($data));
            }
            $result = $customersModel->allowField(true)->save($clues);
        }
        return json_encode(['code'=>'0','message'=>'success']);
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

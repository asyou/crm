<?php

namespace app\admin\controller;

use app\admin\model\Admin;
use app\admin\model\customers\Customers;
use app\common\controller\Backend;
use app\common\model\Attachment;
use fast\Date;
use think\Db;

/**
 * 控制台
 *
 * @icon   fa fa-dashboard
 * @remark 用于展示当前系统中的统计数据、统计报表及重要实时数据
 */
class Dashboard extends Backend
{

    /**
     * 查看
     */
    public function index()
    {
        try {
            \think\Db::execute("SET @@sql_mode='';");
        } catch (\Exception $e) {

        }
        $rules = $this->getAdminRules();
        $where = ['a.group_id'=>'4'];
        if ($rules != 1) {
            $where['a.uid'] = $this->auth->id;
        }
        $users = Db::name('auth_group_access')
            ->alias('a')
            ->field(['b.id','b.nickname'])
            ->join('__ADMIN__ b','a.uid=b.id')
            ->where($where)
            ->select();
        $dates = [];
        $datelist = [];
        $salesman = [];
        $userdata = [];
        $starttime = Date::unixtime('day', -6);
        $endtime = Date::unixtime('day', 0, 'end');
        for ($i=0;$i<count($users);$i++) {
            $joinlist = Db("customers")->where(['updatetime'=>['BETWEEN',[$starttime, $endtime]],'status'=>['GT',1],'admin_id'=>$users[$i]['id']])
                ->field('updatetime, status, COUNT(*) AS nums, DATE_FORMAT(FROM_UNIXTIME(updatetime), "%Y-%m-%d") AS join_date')
                ->group('join_date')
                ->select();
            for ($time = $starttime; $time <= $endtime;) {
                $dates[] = date("Y-m-d", $time);
                $time += 86400;
            }
            $userdata[$i]['name'] = $users[$i]['nickname'];
            $userdata[$i]['type'] = 'line';
            $userdata[$i]['smooth'] = true;
            $userdata[$i]['areaStyle'] = ['normal'=>[]];
            $userdata[$i]['lineStyle'] = ['normal'=>['width'=>1.5]];
            $userdata[$i]['data'] = array_fill_keys($dates, 0);
            foreach ($joinlist as $k => $v) {
                $userdata[$i]['data'][$v['join_date']] = $v['nums'];
            }
            $salesman[$i] = $userdata[$i]['name'];
            $datelist = array_keys($userdata[$i]['data']);
            $userdata[$i]['data'] = array_values($userdata[$i]['data']);
        }
        $where = [];
        if ($rules != 1) {
            $where = [
                'admin_id' => $this->auth->id,
                'deletetime' => null
            ];
        }
        $this->view->assign([
            'totaluser'         => Customers::where($where)->count(), // 总线索数
            'totaladdon'        => Customers::where(['allot_status'=>'0','deletetime'=>null])->count(), // 公海线索
            'totaladmin'        => Customers::where(['status'=>'1'])->where($where)->count(), // 待审核数
            'todayusersignup'   => Customers::whereTime('updatetime', 'today')->where(['status'=>['GT',1]])->where($where)->count(), // 今日成交
            'todayuserlogin'    => Customers::whereTime('updatetime', 'today')->where(['status'=>'0'])->where($where)->count(), // 今日审核
            'sevendau'          => Customers::whereTime('updatetime', '-7 days')->where(['status'=>['GT',1]])->where($where)->count(), // 七日成交
            'thirtydau'         => Customers::whereTime('updatetime', '-7 days')->where(['status'=>'2'])->where($where)->count(), // 七日审核
            'threednu'          => Customers::whereTime('updatetime', '-3 days')->where(['status'=>['GT',1]])->where($where)->count(), // 三日成交
            'sevendnu'          => Customers::whereTime('updatetime', '-3 days')->where(['status'=>'0'])->where($where)->count(), // 三日线索
            'attachmentnums'    => Customers::where(['status'=>['GT',1]])->where($where)->count(), // 总成交数
            'recordtoday'       => Customers::whereTime('createtime', 'today')->where(['created_id'=>$this->auth->id])->count(), // 今日录入
            'recordweekth'      => Customers::whereTime('createtime', '-7 days')->where(['created_id'=>$this->auth->id])->count(), // 本周录入
            'recordall'         => Customers::where(['created_id'=>$this->auth->id])->count(), // 总录入
            'notice'            => \think\Db::name('notices')->field(['msg','createtime'])->order(['id'=>'DESC'])->limit(1)->find(),
            'traces'            => \think\Db::name('customers_log')
                                    ->alias('a')
                                    ->field(['a.id','a.trace_status','a.trace_note','a.next_trace_note','a.next_trace_time','a.createtime','b.name'])
                                    ->join('__CUSTOMERS__ b','a.customers_id=b.id')
                                    ->where(['a.admin_id'=>$this->auth->id,'a.deletetime'=>null,'a.next_trace_time'=>['GT',time()],'b.status'=>'0'])
                                    ->order(['a.next_trace_time'=>'ASC'])
                                    ->group('b.id')
                                    ->paginate(10)
        ]);
        $this->view->assign('rules',$rules);
        $this->assignconfig('rules',$rules);
        $this->assignconfig('salesman', $salesman);
        $this->assignconfig('datelist', $datelist);
        $this->assignconfig('userdata', $userdata);

        return $this->view->fetch();
    }

    // 判断当前用户权限
    protected function getAdminRules()
    {
        $rules = $this->auth->getGroups();
        $groups = [];
        for ($i=0;$i<count($rules);$i++) {
            $groups[$i] = $rules[$i]['group_id'];
        }
        $rules = 0;
        if (array_intersect($groups,[1,2])) {
            $rules = 1;
        }
        if (array_intersect($groups,[3])) {
            $rules = 3;
        }
        if (array_intersect($groups,[4])) {
            $rules = 4;
        }
        return $rules;
    }

}

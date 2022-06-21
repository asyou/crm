<?php
namespace app\push\controller;
use \think\Controller;
use \think\Config;
use \think\Db;
use \GatewayWorker\Lib\Gateway;
use \app\admin\model\chat\Group;
use \app\admin\model\chat\Content;

class Events extends Controller
{
    /**
     * 当客户端发来消息时触发
     * @param int $client_id 会话id
     * @param mixed $data 具体消息
     */
    public static function onMessage($client_id, $data)
    {
        $adminModel   = new \app\admin\model\Admin;
        $custoemrsModel = new \app\admin\model\customers\Index;
        $logsModel = new \app\admin\model\customers\Logs;

        $arr = json_decode($data, true);
        switch($arr['type']) {
            case 'authorize':   // 首次连接，保存或更新用户client_id
                // $arr = ['type'=>'authorize', 'admin_id'=>'用户ID'];
                $adminModel->save(['client_id'=>$client_id],['id'=>$arr['admin_id']]);
                Gateway::bindUid($client_id,$arr['admin_id']);
                break;
            case 'heartbeat':    // 心跳检测
                // $arr = ['type'=>'heartbeat', 'msg'=>'ping'];
                $rsp = [
                    'type' => 'heartbeat',
                    'msg'  => 'pong'
                ];
                // 心跳检测，服务器可以不作响应
                // Gateway::sendToClient($client_id,json_encode($rsp));
                break;
            case 'clues': // 线索分配
                // $arr = ['type'=>'clues', 'name'=>'客户姓名', 'admin_id'=>'销售ID'];
                $to_client_id = $adminModel->where(['id'=>$arr['admin_id']])->value('client_id');
                if ($to_client_id && Gateway::isOnline($to_client_id)) {
                    $rsp = [
                        'type' => 'clues',
                        'msg' => '接收到新的线索',
                        'user' => [
                            'name' => $arr['name']
                        ]
                    ];
                    Gateway::sendToClient($to_client_id,json_encode($rsp));
                }
                break;
            case 'schedule':
                // $arr = ['type'=>'schedule', 'admin_id'=>'销售ID', 'msg'=>'check'];
                $customers = $logsModel
                    ->alias('a')
                    ->field(['a.id','a.trace_note','a.next_trace_note','a.next_trace_time','b.name'])
                    ->join('__CUSTOMERS__ b','a.customers_id=b.id')
                    ->where(['a.admin_id'=>$arr['admin_id'],'a.next_trace_time'=>['BETWEEN',[time(),time()+(Config::get('site.offset_time')/1000)]],'b.status'=>'0'])
                    ->order(['a.next_trace_time'=>'ASC'])
                    ->select();
                if (count($customers) > 0) {
                    $rsp = [
                        'type' => 'schedule',
                        'msg' => '新日程提醒',
                        'data' => $customers
                    ];
                    Gateway::sendToClient($client_id,json_encode($rsp));
                }
                break;
        }
    }

    /**
     * 当客户端连接时触发
     * 如果业务不需此回调可以删除onConnect
     *
     * @param int $client_id 连接id
     */
    public static function onConnect($client_id)
    {

    }

    /**
     * 当连接断开时触发的回调函数
     * @param $connection
     */
    public static function onClose($client_id)
    {
        
    }

    /**
     * 当客户端的连接上发生错误时触发
     * @param $connection
     * @param $code
     * @param $msg
     */
    public static function onError($client_id, $code, $msg)
    {
        echo "error $code $msg\n";
    }

    /**
     * 每个进程启动
     * @param $worker
     */
    public static function onWorkerStart($worker)
    {
        echo "worker started\n";
    }

    /**
     * 每个进程关闭
     * @param $worker
     */
    public static function onWorkerStop($worker)
    {
        echo "worker stoped\n";
    }
}
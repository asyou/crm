<?php
namespace app\push\controller;
use \think\Controller;
use \think\Config;
use \GatewayWorker\Lib\Gateway;

class Events extends Controller
{
    /**
     * 当客户端发来消息时触发
     * @param int $client_id 会话id
     * @param mixed $data 具体消息
     */
    public static function onMessage($client_id, $data)
    {
        $logsModel = new \app\admin\model\customers\Logs;
        $arr = json_decode($data, true);
        switch($arr['type']) {
            case 'authorize':   // 首次连接，uid绑定client_id $arr = ['type'=>'authorize', 'admin_id'=>'用户ID'];
                Gateway::bindUid($client_id,$arr['admin_id']);
                break;
            case 'heartbeat':    // 心跳检测 $arr = ['type'=>'heartbeat', 'msg'=>'ping'];
                $rsp = [
                    'type' => 'heartbeat',
                    'msg'  => 'pong'
                ];
                // 心跳检测，服务器可以不作响应
                // Gateway::sendToClient($client_id,json_encode($rsp));
                break;
            case 'clues': // 线索分配 $arr = ['type'=>'clues', 'name'=>'客户姓名', 'admin_id'=>'销售ID'];
                if (Gateway::isUidOnline($arr['admin_id'])) {
                    $rsp = [
                        'type' => 'clues',
                        'msg' => '接收到新的线索',
                        'user' => [
                            'name' => $arr['name']
                        ]
                    ];
                    Gateway::sendToUid($arr['admin_id'],json_encode($rsp));
                }
                break;
            case 'schedule':    // 日程提醒 $arr = ['type'=>'schedule', 'admin_id'=>'销售ID', 'msg'=>'check'];
                $customers = $logsModel
                    ->alias('a')
                    ->field(['a.id','a.trace_note','a.next_trace_note','a.next_trace_time','b.name'])
                    ->join('__CUSTOMERS__ b','a.customers_id=b.id')
                    ->where(['a.admin_id'=>$arr['admin_id'],'a.reminded'=>'0','a.next_trace_time'=>['BETWEEN',[time(),time()+(Config::get('site.offset_time')/1000)]],'b.status'=>'0','b.trace_status'=>['NEQ','5']])
                    ->order(['a.next_trace_time'=>'ASC'])
                    ->select();
                if (count($customers) > 0) {
                    $rsp = [
                        'type' => 'schedule',
                        'msg' => '新日程提醒',
                        'data' => $customers
                    ];
                    Gateway::sendToUid($arr['admin_id'],json_encode($rsp));
                    foreach($customers as $val) {
                        $logsModel->where(['id'=>$val['id']])->data(['reminded'=>'1'])->update();
                    }
                }
                break;
            case 'notice':  // 线索成交广播 $arr = ['type'=>'notice', 'msg'=>'广播内容'];
                $rsp = [
                    'type' => 'notice',
                    'name' => $arr['name'],
                    'nickname' => $arr['nickname'],
                    'time' => date('Y-m-d H:i',time())
                ];
                Gateway::sendToAll(json_encode($rsp));
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
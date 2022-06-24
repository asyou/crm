<?php
namespace app\push\controller;
use \GatewayWorker\Register;
use \GatewayWorker\Gateway;
use \GatewayWorker\BusinessWorker;
use \Workerman\Worker;

class Index extends Worker
{
    public function __construct()
    {
        // 初始化register进程
        $register = new Register('text://0.0.0.0:1236');

        // 初始化bussinessWorker进程，负责处理业务逻辑
        $worker = new BusinessWorker();
        $worker->name = 'BusinessWorker';
        $worker->count = 2;
        $worker->registerAddress = '127.0.0.1:1236';
        $worker->eventHandler = '\app\push\controller\Events';

        // 初始化Gateway进程，负责维护客户端连接/网络IO
        // $context = array(
        //     'ssl' => array(
        //         // 请使用绝对路径
        //         'local_cert'        => '磁盘路径/server.pem', // 也可以是crt文件
        //         'local_pk'          => '磁盘路径/server.key',
        //         'verify_peer'       => false,
        //         'allow_self_signed' => true, //如果是自签名证书需要开启此选项
        //     )
        // );
        // $gateway = new Gateway("websocket://0.0.0.0:443", $context);
        // $gateway->transport = 'ssl';
        $gateway = new Gateway("websocket://0.0.0.0:39200");
        $gateway->name = 'Gateway';
        $gateway->count = 2;
        $gateway->lanIp = '127.0.0.1';
        $gateway->startPort = 2900;
        $gateway->registerAddress = '127.0.0.1:1236';
        $gateway->pingInterval = 30;
        $gateway->pingNotResponseLimit = 1;
        $gateway->pingData = json_encode(['type'=>'heartbeat','msg'=>'ping']);

        // 运行所有Worker;
        Worker::runAll();
    }
}

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
        // $ip = '116.255.245.183';
        $ip = '127.0.0.1';
        // 初始化register
        new Register('text://'.$ip.':1238');
        // 初始化 bussinessWorker 进程
        $worker = new BusinessWorker();
        // 进程名称，方便status查看
        $worker->name = 'GatewayChat';
        // 进程数量
        $worker->count = 1;
        // 注册服务地址
        $worker->registerAddress = $ip.':1238';
        //设置处理业务的类,此处制定Events的命名空间
        $worker->eventHandler = '\app\push\controller\Events';
        // 初始化 gateway 进程
        $gateway = new Gateway("websocket://".$ip.":1236");
        // 进程名称，方便status查看
        $gateway->name = 'push';
        // 进程数量
        $gateway->count = 1;
        // 内网IP，默认127.0.0.1，分布式部署时必须填写真实内网IP
        $gateway->lanIp = $ip;
        // 监听本机端口的起始端口，与进程数量累加（如进程数量为2，则监听端口为2900、2901）
        $gateway->startPort = 2900;
        // 心跳检测的周期，最好小于60秒
        // 服务器实际关闭连接的时间为pingInterval*pingNotResponseLimit，误差为pingInterval
        // 以下配置的意思为客户端30秒无通讯则服务器主动下发1次检测，超过60秒无通讯则关闭连接
        // 需注意不同浏览器的稳定性可能不同（电脑长时间空闲关闭显示器后，firefox相当稳定，chrome则反复关闭、自动连接）
        $gateway->pingInterval = 30;
        // 客户端无任何数据通讯的最大次数
        $gateway->pingNotResponseLimit = 1;
        // 服务器下发检测的数据
        $gateway->pingData = json_encode(['type'=>'heartbeat','msg'=>'ping']);
        // 注册地址
        $gateway->registerAddress = $ip.':1238';
        // 运行所有Worker;
        Worker::runAll();
    }
}

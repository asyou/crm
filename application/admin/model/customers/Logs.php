<?php

namespace app\admin\model\customers;

use think\Model;
use traits\model\SoftDelete;

class Logs extends Model
{

    use SoftDelete;

    

    // 表名
    protected $name = 'customers_log';
    
    // 自动写入时间戳字段
    protected $autoWriteTimestamp = 'int';

    // 定义时间戳字段名
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';
    protected $deleteTime = 'deletetime';

    // 追加属性
    protected $append = [
        'trace_status_text',
        'next_trace_time_text'
    ];
    

    
    public function getTraceStatusList()
    {
        return ['0' => __('Trace_status 0'), '1' => __('Trace_status 1'), '2' => __('Trace_status 2'), '3' => __('Trace_status 3'), '4' => __('Trace_status 4')];
    }


    public function getTraceStatusTextAttr($value, $data)
    {
        $value = $value ? $value : (isset($data['trace_status']) ? $data['trace_status'] : '');
        $list = $this->getTraceStatusList();
        return isset($list[$value]) ? $list[$value] : '';
    }


    public function getNextTraceTimeTextAttr($value, $data)
    {
        $value = $value ? $value : (isset($data['next_trace_time']) ? $data['next_trace_time'] : '');
        return is_numeric($value) ? date("Y-m-d H:i:s", $value) : $value;
    }

    protected function setNextTraceTimeAttr($value)
    {
        return $value === '' ? null : ($value && !is_numeric($value) ? strtotime($value) : $value);
    }


    public function customers()
    {
        return $this->belongsTo('app\admin\model\customers\Customers', 'customers_id', 'id', [], 'LEFT')->setEagerlyType(0);
    }
    
    public function admin()
    {
        return $this->belongsTo('app\admin\model\Admin', 'admin_id', 'id', [], 'LEFT')->setEagerlyType(0);
    }
}

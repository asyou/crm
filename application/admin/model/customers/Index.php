<?php

namespace app\admin\model\customers;

use think\Model;
use traits\model\SoftDelete;

class Index extends Model
{

    use SoftDelete;

    

    // 表名
    protected $name = 'customers';
    
    // 自动写入时间戳字段
    protected $autoWriteTimestamp = 'int';

    // 定义时间戳字段名
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';
    protected $deleteTime = 'deletetime';

    // 追加属性
    protected $append = [
        'source_text',
        'trace_status_text',
        'allot_status_text',
        'entry_time_text',
        'status_text'
    ];
    

    
    public function getSourceList()
    {
        return ['0' => __('Source 0'), '1' => __('Source 1'), '2' => __('Source 2'), '3' => __('Source 3'), '4' => __('Source 4')];
    }

    public function getTraceStatusList()
    {
        return ['0' => __('Trace_status 0'), '1' => __('Trace_status 1'), '2' => __('Trace_status 2'), '3' => __('Trace_status 3'), '4' => __('Trace_status 4'), '5' => __('Trace_status 5')];
    }

    public function getAllotStatusList()
    {
        return ['0' => __('Allot_status 0'), '1' => __('Allot_status 1')];
    }

    public function getStatusList()
    {
        return ['0' => __('Status 0'), '1' => __('Status 1'), '2' => __('Status 2')];
    }

    // public function getNameAttr($value)
    // {
    //     return mb_substr_replace($value, '****', 1);
    // }

    // public function getContactAttr($value)
    // {
    //     return mb_substr_replace($value, '****', 2);
    // }

    // public function getMobileAttr($value)
    // {
    //     return mb_substr_replace($value, '*******', 3, 7);
    // }

    public function getSourceTextAttr($value, $data)
    {
        $value = $value ? $value : (isset($data['source']) ? $data['source'] : '');
        $list = $this->getSourceList();
        return isset($list[$value]) ? $list[$value] : '';
    }


    public function getTraceStatusTextAttr($value, $data)
    {
        $value = $value ? $value : (isset($data['trace_status']) ? $data['trace_status'] : '');
        $list = $this->getTraceStatusList();
        return isset($list[$value]) ? $list[$value] : '';
    }


    public function getAllotStatusTextAttr($value, $data)
    {
        $value = $value ? $value : (isset($data['allot_status']) ? $data['allot_status'] : '');
        $list = $this->getAllotStatusList();
        return isset($list[$value]) ? $list[$value] : '';
    }


    public function getEntryTimeTextAttr($value, $data)
    {
        $value = $value ? $value : (isset($data['entry_time']) ? $data['entry_time'] : '');
        return is_numeric($value) ? date("Y-m-d H:i:s", $value) : $value;
    }


    public function getStatusTextAttr($value, $data)
    {
        $value = $value ? $value : (isset($data['status']) ? $data['status'] : '');
        $list = $this->getStatusList();
        return isset($list[$value]) ? $list[$value] : '';
    }

    protected function setEntryTimeAttr($value)
    {
        return $value === '' ? null : ($value && !is_numeric($value) ? strtotime($value) : $value);
    }


    public function admin()
    {
        return $this->belongsTo('app\admin\model\Admin', 'admin_id', 'id', [], 'LEFT')->setEagerlyType(0);
    }

    public function created()
    {
        return $this->belongsTo('app\admin\model\Admin', 'created_id', 'id', [], 'LEFT')->setEagerlyType(0);
    }

    public function school()
    {
        return $this->belongsTo('app\admin\model\School', 'school_id', 'id', [], 'LEFT')->setEagerlyType(0);
    }
}

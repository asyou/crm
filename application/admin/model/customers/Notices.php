<?php

namespace app\admin\model\customers;

use think\Model;
use traits\model\SoftDelete;

class Notices extends Model
{

    use SoftDelete;

    

    // 表名
    protected $name = 'notices';
    
    // 自动写入时间戳字段
    protected $autoWriteTimestamp = 'int';

    // 定义时间戳字段名
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';
    protected $deleteTime = 'deletetime';

    // 追加属性
    protected $append = [

    ];
    

    







    public function customers()
    {
        return $this->belongsTo('app\admin\model\customers\Index', 'customers_id', 'id', [], 'LEFT')->setEagerlyType(0);
    }
}

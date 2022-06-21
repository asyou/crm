define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'customers/index/index' + location.search,
                    add_url: 'customers/index/add',
                    edit_url: 'customers/index/edit',
                    del_url: 'customers/index/del',
                    multi_url: 'customers/index/multi',
                    import_url: 'customers/index/import',
                    table: 'customers',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'id',
                fixedColumns: true,
                fixedRightNumber: 1,
                columns: [
                    [
                        {checkbox: true},
                        {field: 'id', title: __('Id')},
                        // {field: 'admin_id', title: __('Admin_id')},
                        // {field: 'created_id', title: __('Created_id')},
                        {field: 'name', title: __('Name'), operate: 'LIKE', formatter: function(value, row) {return value.replace(/(?<=.)./g,'*')}},
                        {field: 'contact', title: __('Contact'), operate: 'LIKE', formatter: function(value, row) {return value.replace(/(?<=.)./g,'*')}},
                        {field: 'mobile', title: __('Mobile'), operate: 'LIKE', formatter: function(value, row) {return value.replace(/(\d{3})\d*(\d{0})$/,'$1********$2')}},
                        {field: 'source', title: __('Source'), searchList: {"0":__('Source 0'),"1":__('Source 1'),"2":__('Source 2'),"3":__('Source 3'),"4":__('Source 4')}, formatter: Table.api.formatter.normal},
                        {field: 'created.nickname', title: __('Created.nickname'), searchList: function(column){return Template('kefustpl',{})}},
                        {field: 'last_admin_name', title: __('Last_admin_name'), operate: 'LIKE'},
                        // {field: 'admin.nickname', title: __('Admin.nickname'), operate: 'LIKE'},
                        // {field: 'last_admin_change', title: __('Last_admin_change'), formatter: Table.api.formatter.datetime},
                        {field: 'entry_time', title: __('Entry_time'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {field: 'trace_status', title: __('Trace_status'), searchList: {"0":__('Trace_status 0'),"1":__('Trace_status 1'),"2":__('Trace_status 2'),"3":__('Trace_status 3'),"4":__('Trace_status 4')}, formatter: Table.api.formatter.status},
                        {field: 'allot_status', title: __('Allot_status'), searchList: {"0":__('Allot_status 0'),"1":__('Allot_status 1')}, formatter: Table.api.formatter.status},
                        {field: 'status', title: __('Status'), searchList: {"0":__('Status 0'),"1":__('Status 1'),"2":__('Status 2')}, formatter: Table.api.formatter.status},
                        {field: 'createtime', title: __('Createtime'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        // {field: 'updatetime', title: __('Updatetime'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {field: 'operate', title: __('Operate'), table: table, events: Table.api.events.operate, formatter: Table.api.formatter.operate,
                            buttons: [{
                                name: 'claim',
                                text: __('认领'),
                                title: __('认领线索'),
                                classname: 'btn btn-xs btn-primary btn-ajax',
                                icon: 'fa fa-user',
                                url: 'customers/index/claim',
                                success: function (data, ret) {
                                    if (ret.code == 1) {
                                        table.bootstrapTable('refresh')
                                    }
                                    return false
                                },
                                error: function(data, ret) {
                                    Layer.alert(ret.msg)
                                    return false
                                },
                                visible: function (row) {
                                    if (row.allot_status=='0') {
                                        return true;
                                    }
                                }
                            }]
                        }
                    ]
                ]
            });

            $(document).on('click','.btn-allot',function(){
                var rows = table.bootstrapTable('getSelections');
                var ids = []
                $.each(rows,function(i,o){
                    ids.push(o.id)
                })
                Fast.api.open("customers/index/batch?ids="+ids.join(','),'线索分配')
            })
            // 为表格绑定事件
            Table.api.bindevent(table);
        },
        recyclebin: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    'dragsort_url': ''
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: 'customers/index/recyclebin' + location.search,
                pk: 'id',
                sortName: 'id',
                columns: [
                    [
                        {checkbox: true},
                        {field: 'id', title: __('Id')},
                        {field: 'name', title: __('Name'), align: 'left'},
                        {
                            field: 'deletetime',
                            title: __('Deletetime'),
                            operate: 'RANGE',
                            addclass: 'datetimerange',
                            formatter: Table.api.formatter.datetime
                        },
                        {
                            field: 'operate',
                            width: '130px',
                            title: __('Operate'),
                            table: table,
                            events: Table.api.events.operate,
                            buttons: [
                                {
                                    name: 'Restore',
                                    text: __('Restore'),
                                    classname: 'btn btn-xs btn-info btn-ajax btn-restoreit',
                                    icon: 'fa fa-rotate-left',
                                    url: 'customers/index/restore',
                                    refresh: true
                                },
                                {
                                    name: 'Destroy',
                                    text: __('Destroy'),
                                    classname: 'btn btn-xs btn-danger btn-ajax btn-destroyit',
                                    icon: 'fa fa-times',
                                    url: 'customers/index/destroy',
                                    refresh: true
                                }
                            ],
                            formatter: Table.api.formatter.operate
                        }
                    ]
                ]
            });

            // 为表格绑定事件
            Table.api.bindevent(table);
        },

        add: function () {
            Controller.api.bindevent();
        },
        edit: function () {
            Controller.api.bindevent();
        },
        batch: function () {
            Controller.api.bindevent();
        },
        api: {
            bindevent: function () {
                Form.api.bindevent($("form[role=form]"));
            }
        }
    };
    return Controller;
});

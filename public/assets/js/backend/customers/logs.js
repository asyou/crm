define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'customers/logs/index' + location.search,
                    add_url: 'customers/logs/add',
                    edit_url: 'customers/logs/edit',
                    del_url: 'customers/logs/del',
                    multi_url: 'customers/logs/multi',
                    import_url: 'customers/logs/import',
                    table: 'customers_log',
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
                        {field: 'customers_id', title: __('Customers_id'), operate: false},
                        {field: 'customers.name', title: __('Customers.name'), operate: 'LIKE'},
                        {field: 'admin.nickname', title: __('Admin.nickname'), searchList: function(column){return Template('salestpl',{})}},
                        {field: 'trace_note', title: __('Trace_note'), operate: false},
                        {field: 'next_trace_note', title: __('Next_trace_note'), operate: false},
                        {field: 'next_trace_time', title: __('Next_trace_time'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {field: 'trace_status', title: __('Trace_status'), searchList: {"0":__('Trace_status 0'),"1":__('Trace_status 1'),"2":__('Trace_status 2'),"3":__('Trace_status 3'),"4":__('Trace_status 4')}, formatter: Table.api.formatter.status},
                        {field: 'trace_status_info', title: __('Trace_status_info'), searchList: {
                            "0":__('Trace_status_info 0'),
                            "10":__('Trace_status_info 10'),
                            "11":__('Trace_status_info 11'),
                            "12":__('Trace_status_info 12'),
                            "20":__('Trace_status_info 20'),
                            "21":__('Trace_status_info 21'),
                            "22":__('Trace_status_info 22'),
                            "30":__('Trace_status_info 30'),
                            "31":__('Trace_status_info 31'),
                            "32":__('Trace_status_info 32')
                        }, formatter: Table.api.formatter.label},
                        {field: 'createtime', title: __('Createtime'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        // {field: 'updatetime', title: __('Updatetime'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {field: 'operate', title: __('Operate'), table: table, events: Table.api.events.operate, formatter: Table.api.formatter.operate}
                    ]
                ]
            });

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
                url: 'customers/logs/recyclebin' + location.search,
                pk: 'id',
                sortName: 'id',
                columns: [
                    [
                        {checkbox: true},
                        {field: 'id', title: __('Id')},
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
                                    url: 'customers/logs/restore',
                                    refresh: true
                                },
                                {
                                    name: 'Destroy',
                                    text: __('Destroy'),
                                    classname: 'btn btn-xs btn-danger btn-ajax btn-destroyit',
                                    icon: 'fa fa-times',
                                    url: 'customers/logs/destroy',
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
        api: {
            bindevent: function () {
                Form.api.bindevent($("form[role=form]"));
            }
        }
    };
    return Controller;
});

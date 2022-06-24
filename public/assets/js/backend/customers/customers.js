define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'customers/customers/index' + location.search,
                    add_url: 'customers/customers/add',
                    edit_url: 'customers/customers/edit',
                    del_url: 'customers/customers/del',
                    multi_url: 'customers/customers/multi',
                    import_url: 'customers/customers/import',
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
                        // {field: 'created_id', title: __('Created_id')},
                        {field: 'name', title: __('Name'), operate: 'LIKE'},
                        {field: 'contact', title: __('Contact'), operate: 'LIKE'},
                        {field: 'mobile', title: __('Mobile'), operate: 'LIKE'},
                        {field: 'source', title: __('Source'), searchList: {"0":__('Source 0'),"1":__('Source 1'),"2":__('Source 2'),"3":__('Source 3'),"4":__('Source 4')}, formatter: Table.api.formatter.normal},
                        {field: 'admin.nickname', title: __('Admin.nickname'), searchList: function(column){return Template('salestpl',{})}},
                        {field: 'created.nickname', title: __('Created.nickname'), searchList: function(column){return Template('kefustpl',{})}},
                        {field: 'trace_status', title: __('Trace_status'), searchList: {"0":__('Trace_status 0'),"1":__('Trace_status 1'),"2":__('Trace_status 2'),"3":__('Trace_status 3'),"4":__('Trace_status 4'),"5":__('Trace_status 5')}, formatter: Table.api.formatter.status},
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
                        // {field: 'allot_status', title: __('Allot_status'), searchList: {"0":__('Allot_status 0'),"1":__('Allot_status 1')}, formatter: Table.api.formatter.status},
                        // {field: 'last_admin_name', title: __('Last_admin_name'), operate: 'LIKE'},
                        // {field: 'last_admin_change', title: __('Last_admin_change')},
                        // {field: 'entry_time', title: __('Entry_time'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {field: 'status', title: __('Status'), searchList: {"0":__('Status 0'),"1":__('Status 1'),"2":__('Status 2')}, formatter: Table.api.formatter.status},
                        {field: 'createtime', title: __('Createtime'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        // {field: 'updatetime', title: __('Updatetime'), operate:false, addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {field: 'operate', title: __('Operate'), table: table, events: Table.api.events.operate, formatter: Table.api.formatter.operate,
                            buttons: [{
                                name: 'claim',
                                text: __('跟进'),
                                title: __('跟进记录'),
                                classname: 'btn btn-xs btn-warning btn-dialog',
                                icon: 'fa fa-list-ol',
                                url: 'customers/customers/claim',
                                callback: function (data) {
                                    Layer.alert("接收到回传数据：" + JSON.stringify(data), {title: "回传数据"});
                                },
                                visible: function (row) {
                                    return true;
                                }
                            }, {
                                name: 'claim',
                                text: __('成交'),
                                title: __('线索成交'),
                                classname: 'btn btn-xs btn-success btn-dialog',
                                icon: 'fa fa-star',
                                url: 'customers/customers/traded',
                                callback: function (data) {
                                    Layer.alert("接收到回传数据：" + JSON.stringify(data), {title: "回传数据"});
                                },
                                visible: function (row) {
                                    return row.status == '0' ? true : false
                                }
                            }, {
                                name: 'claim',
                                text: __('公海'),
                                title: __('放入公海'),
                                classname: 'btn btn-xs btn-primary btn-ajax',
                                icon: 'fa fa-shopping-basket',
                                url: 'customers/customers/ocean',
                                confirm: '确定把该线索放回公海？',
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
                                    return row.status == '0' ? true : false
                                }
                            }]
                        }
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
                url: 'customers/customers/recyclebin' + location.search,
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
                                    url: 'customers/customers/restore',
                                    refresh: true
                                },
                                {
                                    name: 'Destroy',
                                    text: __('Destroy'),
                                    classname: 'btn btn-xs btn-danger btn-ajax btn-destroyit',
                                    icon: 'fa fa-times',
                                    url: 'customers/customers/destroy',
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
        claim: function () {
            Controller.api.bindevent();
        },
        traded: function () {
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

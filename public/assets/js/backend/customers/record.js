define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'customers/record/index' + location.search,
                    add_url: 'customers/record/add',
                    edit_url: 'customers/record/edit',
                    del_url: 'customers/record/del',
                    multi_url: 'customers/record/multi',
                    import_url: 'customers/record/import',
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
                        {field: 'created.nickname', title: __('Created.nickname'), searchList: function(column){return Template('kefustpl',{})}},
                        {field: 'trace_status', title: __('Trace_status'), searchList: {"0":__('Trace_status 0'),"1":__('Trace_status 1'),"2":__('Trace_status 2'),"3":__('Trace_status 3'),"4":__('Trace_status 4'),"5":__('Trace_status 5')}, formatter: Table.api.formatter.status},
                        // {field: 'allot_status', title: __('Allot_status'), searchList: {"0":__('Allot_status 0'),"1":__('Allot_status 1')}, formatter: Table.api.formatter.status},
                        // {field: 'last_admin_name', title: __('Last_admin_name'), operate: 'LIKE'},
                        // {field: 'last_admin_change', title: __('Last_admin_change')},
                        // {field: 'entry_time', title: __('Entry_time'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {field: 'status', title: __('Status'), searchList: {"0":__('Status 0'),"1":__('Status 1'),"2":__('Status 2')}, formatter: Table.api.formatter.status},
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
                url: 'customers/record/recyclebin' + location.search,
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
                                    url: 'customers/record/restore',
                                    refresh: true
                                },
                                {
                                    name: 'Destroy',
                                    text: __('Destroy'),
                                    classname: 'btn btn-xs btn-danger btn-ajax btn-destroyit',
                                    icon: 'fa fa-times',
                                    url: 'customers/record/destroy',
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

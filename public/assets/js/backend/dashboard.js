define(['jquery', 'bootstrap', 'backend', 'addtabs', 'table', 'form', 'echarts', 'echarts-theme', 'template'], function ($, undefined, Backend, Datatable, Table, Form, Echarts, undefined, Template) {

    var Controller = {
        index: function () {
            if (Config.rules != 3) {
                // 基于准备好的dom，初始化echarts实例
                var myChart = Echarts.init(document.getElementById('echart'), 'walden');

                // 指定图表的配置项和数据
                var option = {
                    title: {
                        text: '',
                        subtext: ''
                    },
                    color: [
                        "#18d1b1",
                        "#3fb1e3",
                        "#626c91",
                        "#a0a7e6",
                        "#c4ebad",
                        "#96dee8"
                    ],
                    tooltip: {
                        trigger: 'axis'
                    },
                    legend: {
                        data: Config.salesman
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            magicType: {show: true, type: ['stack', 'tiled']},
                            saveAsImage: {show: true}
                        }
                    },
                    xAxis: {
                        type: 'category',
                        boundaryGap: false,
                        data: Config.datelist
                    },
                    yAxis: {},
                    grid: [{
                        left: 'left',
                        top: 'top',
                        right: '10',
                        bottom: 30
                    }],
                    series: Config.userdata
                };

                // 使用刚指定的配置项和数据显示图表。
                myChart.setOption(option);

                $(window).resize(function () {
                    myChart.resize();
                });

                $(document).on("click", ".btn-refresh", function () {
                    setTimeout(function () {
                        myChart.resize();
                    }, 0);
                });
            }

            // 给表单绑定事件
            Form.api.bindevent($("#add-form"), function () {
                setTimeout(function() {
                    window.location.reload();
                }, 2000)
            });
        }
    };

    return Controller;
});

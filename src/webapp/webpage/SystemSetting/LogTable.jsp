<%@ page contentType="text/html;charset=UTF-8" %>
<html>

<head>
    <meta charset="utf-8">
    <title>Hotel Management System</title>
    <link rel="stylesheet" href="../../js/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="../../MAIN/component/font-awesome-4.7.0/css/font-awesome.min.css">
    <script src="../../js/layui/layui.js"></script>
    <script src="../../js/jquery.js"></script>
    <script src="../../js/global.js"></script>
    <style>
        body {
            margin: 10px;
        }

        .layui-elem-field legend {
            font-size: 14px;
        }

        .layui-field-title {
            margin: 25px 0 15px;
        }
    </style>
</head>

<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>
        <div>
            <div class="layui-inline">
                <button class="layui-btn fa fa-save" id="toXls"> export data</button>
            </div>
        </div>
    </legend>
</fieldset>
<%--方法级渲染表格--%>
<table id="tableLogInfo"></table>
<script type="text/html" id="barAuth">
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">delete</a>
</script>
<script>
    layui.use(['util', 'layer', 'table'], function () {
        $(document).ready(function () {
            var table = layui.table,
                layer = layui.layer,
                util = layui.util;
            var countNum;

            //方法级渲染
            var tableIns = table.render({
                elem: '#tableLogInfo' //绑定元素-->对应页面table的ID
                ,
                id: 'tableLogInfo' //表格容器索引
                ,
                url: baseUrl + '/LogInfoServlet' //数据接口
                ,
                limit: 30,
                cols: [
                    [ //表头
                        //field字段名、title标题名、width列宽、sort排序、fixed固定列、toolbar绑定工具条
                        {
                            field: 'logId',
                            title: 'logId',
                            width: 100,
                            sort: true,
                            fixed: true
                        }, {
                        field: 'logName',
                        title: 'logName',
                        sort: true
                    }, {
                        field: 'loginId',
                        title: 'loginId',
                        sort: true
                    }, {
                        field: 'loginName',
                        title: 'loginName',
                        sort: true
                    }, {
                        field: 'logDate',
                        title: 'logDate',
                        sort: true
                    }, {
                        field: 'right',
                        title: 'right',
                        align: 'center',
                        toolbar: '#barAuth',
                        width: 100
                    }
                    ]
                ],
                page: true //是否开启分页
                ,
                where: {
                    make: 0
                } //接口的其它参数
                ,
                done: function (res, curr, count) {
                    countNum = count;
                }
            });

            //监听工具条
            table.on('tool', function (obj) { //tool是工具条事件名
                var data = obj.data,
                    layEvent = obj.event; //获得 lay-event 对应的值
                //从前当前行获取列数据
                var logId = data.logId;

                if (layEvent === 'del') { //删除功能
                    layer.confirm('confirm delete？', {
                        offset: '180px',
                        btn: ['YES', 'NO']
                    }, function () {
                        tableIns.reload({
                            where: {
                                make: 1,
                                logId: logId
                            }
                        });
                        layer.msg('delete result', {
                            offset: '250px',
                            icon: 1
                        });
                        // tableIns.reload({
                        //     where: {
                        //         make: 0,
                        //         page: 1
                        //     }
                        // });
                    }, function () {
                        layer.msg('delete cancel', {
                            offset: '250px'
                        });
                    });
                }
            });

            //刷新
            $('#refresh').click(function () {
                tableIns.reload({
                    where: {
                        make: 0,
                        page: 1
                    }
                });
            });

            //导出
            $('#toXls').click(function () {
                location.href = baseUrl + '/LogInfoExcelServlet';
                layer.alert('Excel file generation is complete！', {
                    title: 'success',
                    icon: 6,
                    anim: 1,
                    offset: '250px'
                });
            });

            //固定块  -- 就是那个回到顶部
            util.fixbar({
                showHeight: 2,
                click: function (type) {
                    console.log(type);
                }
            });
        });
    });
</script>
</body>

</html>
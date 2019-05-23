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
		<script src="../../js/Cookie.js"></script>
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
						<div class="layui-input-inline">
							<input class="layui-input" id="inputSearch1" placeholder="Scheduler">
						</div>
						<button class="layui-btn fa fa-search layui-btn-normal" id="searchButton1"> search</button>
					</div>

					<div class="layui-inline">
						<div class="layui-input-inline">
							<input class="layui-input" id="inputSearch2" placeholder="room type">
						</div>
						<button class="layui-btn fa fa-search layui-btn-normal" id="searchButton2"> search</button>
					</div>

					<div class="layui-inline">
						<button class="layui-btn fa fa-refresh layui-btn-normal" id="refreshButton"> refresh</button>
					</div>
					<div class="layui-inline">
						<button class="layui-btn fa fa-save layui-btn-normal" id="toXlsButton"> export</button>
					</div>
				</div>
			</legend>
		</fieldset>
		<div id="toxlsTable">
			<table id="tableID"></table>
		</div>
		<script type="text/html" id="barAuth">
			<a class="layui-btn layui-btn-xs" lay-event="edit">edit</a>
			<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">delete</a>
		</script>
		<script>
			layui.use(['util', 'layer', 'table'], function() {
				$(document).ready(function() {
					var table = layui.table,
						layer = layui.layer,
						util = layui.util;
					var countNum;
					var tableIns = table.render({
						elem: '#tableID',
						id: 'tableID',
						url: baseUrl + '/OrderInfoServlet',
						cols: [
							[{
								field: 'orderId',
								title: 'orderId',
								width: 180,
								sort: true,
								fixed: true
							}, {
								field: 'orderName',
								title: 'orderName',
								sort: true,
								width: 180
							}, {
								field: 'orderPhone',
								title: 'orderPhone',
								width: 180
							}, {
								field: 'orderIDcard',
								title: 'orderIDcard',
								width: 200
							}, {
								field: 'arrireDate',
								title: 'arrireDate',
								width: 180
							}, {
								field: 'leaveDate',
								title: 'leaveDate',
								width: 180
							}, {
								field: 'typeId',
								title: 'typeId',
								sort: true,
								width: 180
							}, {
								field: 'checkNum',
								title: 'checkNum',
								width: 100
							}, {
								field: 'price',
								title: 'price',
								width: 100
							}, {
								field: 'checkPrice',
								title: 'checkPrice',
								width: 100
							}, {
								field: 'discount',
								title: 'discount',
								width: 100
							}, {
								field: 'discountReason',
								title: 'discountReason',
								width: 180
							}, {
								field: 'addBed',
								title: 'addBed',
								sort: true,
								width: 100
							}, {
								field: 'addBedPrice',
								title: 'addBedPrice',
								width: 100
							}, {
								field: 'orderMoney',
								title: 'orderMoney',
								width: 100
							}, {
								field: 'orderState',
								title: 'orderState',
								sort: true,
								width: 100
							}, {
								field: 'remark',
								title: 'remark',
								width: 400
							}, {
								field: 'operatorId',
								title: 'operatorId',
								sort: true,
								width: 100
							}, {
								field: 'right',
								title: 'right',
								align: 'center',
								toolbar: '#barAuth',
								width: 150,
								fixed: 'right'
							}]
						],
						page: true,
						where: {
							make: 0
						},
						done: function(res, curr, count) {
							countNum = count;
						}
					});

					//监听工具条
					table.on('tool', function(obj) {
						var data = obj.data,
							layEvent = obj.event;
						var orderId = data.orderId;

						if(layEvent === 'del') {
							layer.confirm('Are you sure you want to delete this data?', {
								offset: '180px',
								btn: ['YES', 'NO']
							}, function() {
								table.reload('tableID', {
									where: {
										make: 4,
										orderId: orderId
									}
								});
								layer.msg('Delete the result as follows', {
									offset: '250px',
									icon: 1
								});
                                tableIns.reload({
                                    where: {
                                        make: 0,
                                        page: 1
                                    }
                                });
							}, function() {
								layer.msg('Delete operation canceled', {
									offset: '250px'
								});
							});
						} else if(layEvent === 'edit') {

							// emmm 父子传参只会写儿子传递给父亲的
							// 其实 用jsp那套session啥的传参或许更好
							setCookie("orderId", orderId);

							//编辑
							layer.open({
								title: "submit",
								btn: ['cancel'],
								yes: function(index) {
									tableIns.reload({
										where: {
											make: 0
										}
									});
									layer.close(index); //关闭弹窗
								},
								type: 2,
								area: ['1080px', '520px'],
								fixed: false,
								maxmin: true,
								content: '/hb/webpage/orderInfo/updateOrder.jsp',
								cancel: function() {
									tableIns.reload({
										where: {
											make: 0
										}
									});
								}
							});

						}
					});

					//搜索
					$('#searchButton1').click(function() {
						var select = $('#inputSearch1').val();
						tableIns.reload({
							where: {
								make: 1,
								page: 1,
								select: select
							}
						});
					});

					$('#searchButton2').click(function() {
						var select = $('#inputSearch2').val();
						tableIns.reload({
							where: {
								make: 2,
								page: 1,
								select: select
							}
						});
					});

					//刷新
					$('#refreshButton').click(function() {
						tableIns.reload({
							where: {
								make: 0,
								page: 1
							}
						});
					});

					//导出
					$('#toXlsButton').click(function() {
						location.href = baseUrl + '/OrderInfoExcelServlet';
						layer.alert('Excel file generation is complete！', {
							title: 'success',
							icon: 6,
							anim: 1,
							offset: '250px'
						});
					});

					//回到顶端
					util.fixbar({
						showHeight: 2,
						click: function(type) {
							console.log(type);
						}
					});
				});
			});
		</script>
	</body>

</html>
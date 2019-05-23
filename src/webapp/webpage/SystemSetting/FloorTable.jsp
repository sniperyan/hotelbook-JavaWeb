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
		<script src="../../js/toExcel/xlsx.full.min.js"></script>
		<script type="text/javascript" src="../../js/toExcel/FileSaver.js"></script>
		<script type="text/javascript" src="../../js/toExcel/Export2Excel.js"></script>
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
							<input class="layui-input" id="inputSearch" placeholder="楼层名称">
						</div>
						<button class="layui-btn fa fa-search" id="searchButton"> search</button>
					</div>
					<div class="layui-inline">
						<button class="layui-btn fa fa-refresh" id="refreshButton"> refresh</button>
					</div>
					<div class="layui-inline">
						<button class="layui-btn fa fa-pencil-square-o " id="insertButton"> add</button>
					</div>
					<div class="layui-inline">
						<button class="layui-btn fa fa-save" id="toXlsButton"> export</button>
					</div>
				</div>
			</legend>
		</fieldset>
		<div id="toxlsTable">
			<table id="tableID"></table>
		</div>
		<script type="text/html" id="barAuth">
			<a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">view</a>
			<a class="layui-btn layui-btn-xs" lay-event="edit">edit</a>
			<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">delete</a>
		</script>
		<script>
			/**
			 * 公共模板部分，自制模板修改
			 * 规定：make 0重载 1新增 2修改 3搜索 4删除
			 *
			 * 这个模板来自权限表的jsp与js,因为大体类似，前端可以参照同一结构
			 * 一些变量名换成了与具体项无关的名称，需要修改的部分通过注释注明
			 * 原注释可以参考最初的版本 : AuthTable.jsp
			 */

			layui.use(['util', 'layer', 'table'], function() {
				$(document).ready(function() {
					var table = layui.table,
						layer = layui.layer,
						util = layui.util;
					var countNum;
					var tableIns = table.render({
						elem: '#tableID',
						id: 'tableID',
						url: baseUrl + '/FloorInfoServlet',
						cols: [
							[{
								field: 'floorId',
								title: 'ID',
								width: 100,
								sort: true,
								fixed: true
							}, {
								field: 'floorName',
								title: 'floorName'
							}, {
								field: 'right',
								title: 'right',
								align: 'center',
								toolbar: '#barAuth',
								width: 200
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
						var floorId = data.floorId;
						var floorName = data.floorName;

						if(layEvent === 'detail') { //查看功能
							layer.alert('ID：' + floorId + '<br>floorName' + floorName, {
								skin: 'layui-layer-lan',
								closeBtn: 0,
								title: 'floorName',
								anim: 4,
								offset: '180px'
							});
						} else if(layEvent === 'del') {
							layer.confirm('confirm delete？', {
								offset: '180px',
								btn: ['YES', 'NO']
							}, function() {
								table.reload('tableID', {
									where: {
										make: 4,
										floorId: floorId
									}
								});
								layer.msg('delete result', {
									offset: '250px',
									icon: 1
								});
							}, function() {
								layer.msg('delete cancel', {
									offset: '250px'
								});
							});
						} else if(layEvent === 'edit') {
							layer.prompt({
								title: 'floorName',
								formType: 0,
								value: floorName,
								offset: '220px',
								maxlength: 10
							}, function(value, index) {
								var params = "new=" + value + "&old=" + floorName;
								$.post(baseUrl + '/QueryFloorNameServlet', params, function updateCheck(data) {
									if(data === "1" || data === "2") {
										layer.close(index);
										table.reload('tableID', {
											where: {
												make: 2,
												floorId: floorId,
												floorName: value
											}
										});
										layer.msg('change result', {
											offset: '250px'
										});
									} else {
										layer.alert('The floor name already exists！', {
											title: 'warning',
											icon: 4,
											anim: 6,
											offset: '220px'
										});
									}
								});
							});
						}
					});

					//搜索
					$('#searchButton').click(function() {
						var inputTxt = $('#inputSearch').val();
						if(inputTxt === "")
							layer.msg('must input', {
								offset: '250px'
							});
						else if(inputTxt.length > 10)
							layer.msg('illegal length', {
								offset: '250px'
							});
						else {
							tableIns.reload({
								where: {
									make: 3,
									floorName: inputTxt
								}
							});
							layer.msg('search result', {
								offset: '250px'
							});
						}
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

					//新增
					$('#insertButton').click(function() {
						layer.prompt({
							title: 'please input floor name',
							formType: 0,
							offset: '220px',
							maxlength: 10
						}, function(inputValue, index) {
							var params = "new=" + inputValue + "&old=" + inputValue;
							$.post(baseUrl + '/QueryFloorNameServlet', params, function(data) {
								if(data === "1") {
									layer.close(index);
									table.reload('tableID', {
										where: {
											make: 1,
											floorName: inputValue
										}
									});
									layer.msg('add floor success', {
										offset: '250px'
									});
									tableIns.reload({
										where: {
											make: 0
										}
									});
								} else {
									layer.alert('The floor name already exists！', {
										title: 'warning',
										icon: 4,
										anim: 6,
										offset: '220px'
									});
								}
							});
						});
					});

					//导出
					$('#toXlsButton').click(function() {
						location.href = baseUrl + '/FloorInfoExcelServlet';
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
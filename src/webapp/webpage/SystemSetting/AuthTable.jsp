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
						<div class="layui-input-inline">
							<input class="layui-input" id="AuthITEM" placeholder="Privilege name">
						</div>
						<button class="layui-btn fa fa-search" id="searchAuthITEM"> search</button>
					</div>
					<div class="layui-inline">
						<button class="layui-btn fa fa-refresh" id="refresh"> refresh</button>
					</div>
					<div class="layui-inline">
						<button class="layui-btn fa fa-pencil-square-o " id="insertAuth"> add</button>
					</div>
					<div class="layui-inline">
						<button class="layui-btn fa fa-save" id="toXls"> export</button>
					</div>
				</div>
			</legend>
		</fieldset>
		<div id="toxlsTable">
			<%--方法级渲染表格--%>
			<table id="tableAuth"></table>
		</div>
		<script type="text/html" id="barAuth">
			<a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">view</a>
			<a class="layui-btn layui-btn-xs" lay-event="edit">edit</a>
			<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">delete</a>
		</script>
		<script>
			/**
			 * 权限表 全部完成
			 * 2017.11.15 1:33
			 */
			layui.use(['util', 'layer', 'table'], function() {
				$(document).ready(function() {
					var table = layui.table,
						layer = layui.layer,
						util = layui.util;
					var countNum;
					//方法级渲染
					var tableIns = table.render({
						elem: '#tableAuth' //绑定元素-->对应页面table的ID
							,
						id: 'tableAuth' //表格容器索引
							,
						url: baseUrl + '/AuthInfoServlet' //数据接口
							,
						limit: 30,
						cols: [
							[ //表头
								//field字段名、title标题名、width列宽、sort排序、fixed固定列、toolbar绑定工具条
								{
									field: 'authId',
									title: 'ID',
									width: 100,
									sort: true,
									fixed: true
								}, {
									field: 'authItem',
									title: 'Privilege name'
								}, {
									field: 'isRead',
									title: 'readable'
								}, {
									field: 'isWrite',
									title: 'Writable'
								}, {
									field: 'isChange',
									title: 'editable'
								}, {
									field: 'isDelete',
									title: 'deletable'
								}, {
									field: 'right',
									title: 'admin',
									align: 'center',
									toolbar: '#barAuth',
									width: 200
								}
							]
						],
						page: true //是否开启分页
							,
						where: {
							make: 0
						} //接口的其它参数
						,
						done: function(res, curr, count) {
							countNum = count;
						}
					});

					//监听工具条
					table.on('tool', function(obj) { //tool是工具条事件名
						var data = obj.data,
							layEvent = obj.event; //获得 lay-event 对应的值
						//从前当前行获取列数据
						var authId = data.authId;
						var authItem = data.authItem;
						var isRead = data.isRead;
						var isWrite = data.isWrite;
						var isChange = data.isChange;
						var isDelete = data.isDelete;

						if(layEvent === 'detail') { //查看功能
							layer.alert('Permission item：' + data.authItem + '<br>Minimum readable authority level：' + data.isRead + '<br>Minimum writable permission level：' +
								data.isWrite + '<br>Minimum changeable permission level：' + data.isChange + '<br>Minimum deletable permission level：' + data.isDelete, {
									skin: 'layui-layer-lan',
									closeBtn: 0,
									title: 'The permission value information you currently select',
									anim: 4,
									offset: '180px'
								});

						} else if(layEvent === 'del') { //删除功能
							layer.alert('This entry is forbidden to delete！', {
								title: 'warning',
								icon: 4,
								anim: 6,
								offset: '250px'
							});

						} else if(layEvent === 'edit') { //编辑功能
							//layer.prompt(options, yes) - 输入层
							//formType:输入框类型，支持0（文本）默认1（密码）2（多行文本） maxlength: 140, //可输入文本的最大长度，默认500
							layer.prompt({
								title: 'Please enter the minimum readable privilege level',
								formType: 0,
								value: isRead,
								offset: '220px',
								maxlength: 1
							}, function(IsRead, index) {
								layer.close(index);
								layer.prompt({
									title: 'Please enter the minimum writable permission level',
									formType: 0,
									value: isWrite,
									offset: '220px',
									maxlength: 1
								}, function(IsWrite, index) {
									layer.close(index);
									layer.prompt({
										title: 'Please enter the minimum privilege level',
										formType: 0,
										value: isChange,
										offset: '220px',
										maxlength: 1
									}, function(IsChange, index) {
										layer.close(index);
										layer.prompt({
											title: 'Please enter the minimum privilege level',
											formType: 0,
											value: isDelete,
											offset: '220px',
											maxlength: 1
										}, function(IsDelete, index) {
											layer.close(index);
											//isNaN() 函数用于检查其参数是否是非数字值,如果是数字返回true
											if(isNaN(IsRead) || isNaN(IsWrite) || isNaN(IsChange) || isNaN(IsDelete)) {
												layer.msg('Value type is illegal', {
													offset: '250px'
												});
											} else { //传数据
												table.reload('tableAuth', {
													where: {
														make: 2,
														authId: authId,
														authItem: authItem,
														isRead: IsRead,
														isWrite: IsWrite,
														isChange: IsChange,
														isDelete: IsDelete
													}
												});
												layer.msg('success', {
													offset: '250px'
												});
											}
										});
									});
								});
							});
						}
					});

					//刷新
					$('#refresh').click(function() {
						tableIns.reload({
							where: {
								make: 0,
								page: 1
							}
						});
					});

					//新增
					$('#insertAuth').click(function() {
						layer.alert('This entry is forbidden to add！', {
							title: 'warning',
							icon: 4,
							anim: 6,
							offset: '250px'
						});
					});

					//搜索权限项目
					$('#searchAuthITEM').click(function() {
						var authItem = $('#AuthITEM').val();
						if(authItem === "")
							layer.msg('must input', {
								offset: '250px'
							});
						else if(authItem.length > 10)
							layer.msg('illegal length', {
								offset: '250px'
							});
						else {
							layer.msg('search result', {
								offset: '250px'
							});
							//与tableIns.reload方法类似，这种方法是取表格容器索引值
							table.reload('tableAuth', {
								where: {
									make: 3,
									authItem: authItem
								}
							});
						}

					});

					//导出
					$('#toXls').click(function() {
						location.href = baseUrl + '/AuthInfoExcelServlet';
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
						click: function(type) {
							console.log(type);
						}
					});
				});
			});
		</script>
	</body>

</html>
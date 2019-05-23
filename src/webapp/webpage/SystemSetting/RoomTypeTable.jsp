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
							<input class="layui-input" id="inputSearch" placeholder="room type">
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
			layui.use(['util', 'layer', 'table'], function() {
				$(document).ready(function() {
					var table = layui.table,
						layer = layui.layer,
						util = layui.util;
					var countNum;
					var tableIns = table.render({
						elem: '#tableID',
						id: 'tableID',
						url: baseUrl + '/RoomTypeServlet',
						cols: [
							[{
								field: 'typeId',
								title: 'ID',
								sort: true,
								fixed: true,
                                width: 150
							}, {
								field: 'typeName',
								title: 'typeName'
							}, {
								field: 'price',
								title: 'price'
							}, {
								field: 'splicPrice',
								title: 'splicPrice'
							}, {
								field: 'exceedance',
								title: 'exceedance'
							}, {
								field: 'isSplice',
								title: 'isSplice'
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
						var typeId = data.typeId;
						var typeName = data.typeName;
						var price = data.price;
						var splicPrice = data.splicPrice;
						var exceedance = data.exceedance;
						var isSplice = data.isSplice;

						if(layEvent === 'detail') {
							layer.alert(
								'ID：' + typeId + '<br>typeName：' + typeName + '<br>price：' + price +
								'<br>splicPrice：' + splicPrice + '<br>exceedance：' + exceedance + '<br>isSplice：' + isSplice, {
									skin: 'layui-layer-lan',
									closeBtn: 0,
									title: 'room type info',
									anim: 4,
									offset: '180px'
								});
						} else if(layEvent === 'del') {
							layer.confirm('comfirm delete？', {
								offset: '180px',
								btn: ['YES', 'NO']
							}, function() {
								table.reload('tableID', {
									where: {
										make: 4,
										typeId: typeId
									}
								});
								layer.msg('comfirm result', {
									offset: '250px',
									icon: 1
								});
							}, function() {
								layer.msg('delete cancel', {
									offset: '250px'
								});
							});
						} else if(layEvent === 'edit') {
							//编辑
							layer.prompt({
								title: 'please input type name',
								formType: 0,
								value: typeName,
								offset: '220px',
								maxlength: 10
							}, function(NewTypeName, index) {
								var params = "new=" + NewTypeName + "&old=" + typeName;
								$.post(baseUrl + '/QueryRoomTypeNameServlet', params, function(data) {
									if(data === "1" || data === "2") {
										if(NewTypeName.length < 3)
											layer.alert('illegal length！', {
												title: 'warning',
												icon: 4,
												anim: 6,
												offset: '220px'
											});
										else {
											layer.close(index);
											layer.prompt({
												title: 'please input price',
												formType: 0,
												value: price,
												offset: '220px',
												maxlength: 10
											}, function(NewPrice, index) {
												if(isNaN(NewPrice)) {
													layer.msg('illegal type input', {
														offset: '250px'
													});
												} else {
													layer.close(index);
													layer.prompt({
														title: 'please input splice price',
														formType: 0,
														value: splicPrice,
														offset: '220px',
														maxlength: 10
													}, function(NewSplicPrice, index) {
														if(isNaN(NewSplicPrice)) {
															layer.msg('illegal type input', {
																offset: '250px'
															});
														} else {
															layer.close(index);
															layer.prompt({
																title: 'please input exceedance',
																formType: 0,
																value: exceedance,
																offset: '220px',
																maxlength: 10
															}, function(NewExceedance, index) {
																if(isNaN(NewExceedance)) {
																	layer.msg('illegal type input', {
																		offset: '250px'
																	});
																} else {
																	layer.close(index);
																	layer.prompt({
																		title: 'support splice（Y/N）',
																		formType: 0,
																		value: isSplice,
																		offset: '220px',
																		maxlength: 10
																	}, function(NewIsSplice, index) {
																		if(NewIsSplice.valueOf() === "Y" || NewIsSplice.valueOf() === "N") {
																			tableIns.reload({
																				where: {
																					make: 2,
																					typeId: typeId,
																					typeName: NewTypeName,
																					price: NewPrice,
																					splicPrice: NewSplicPrice,
																					exceedance: NewExceedance,
																					isSplice: NewIsSplice
																				}
																			});
																			layer.close(index);
																		} else {
																			layer.msg('illegal type input', {
																				offset: '260px'
																			});
																		}
																	});
																}
															});
														}
													});
												}
											});
										}
									} else {
										layer.alert('An item with the same name already exists！', {
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
							layer.msg('must input value', {
								offset: '250px'
							});
						else if(inputTxt.length > 10)
							layer.msg('illegal length', {
								offset: '250px'
							});
						else {
							layer.msg('search result', {
								offset: '250px'
							});
							table.reload('tableID', {
								where: {
									make: 3,
									typeName: inputTxt
								}
							})
						}
					});

					//刷新
					$('#refreshButton').click(function() {
						// 简述此处存在的BUG 删除操作触发外键依赖后，出500异常
						// 通过msg回传参数，尔后执行刷新操作时，框架本身死掉
						// 即往后端传入的分页参数固定为1，表格的重载刷新失效
						// 暂时只发现删除引起的异常，先通过强制刷新解决此处异常
						// tableIns.reload({
						// 	where: {
						// 		make: 0,
						// 		page: 1
						// 	}
						// });
						location.reload();
					});

					//新增
					$('#insertButton').click(function() {
						layer.open({
							title: "add",
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
							area: ['780px', '450px'],
							fixed: false,
							maxmin: true,
							content: '/hb/webpage/SystemSetting/insertRomeType.jsp',
							cancel: function() {
								tableIns.reload({
									where: {
										make: 0
									}
								});
							}
						});
					});

					//导出
					$('#toXlsButton').click(function() {
						location.href = baseUrl + '/RoomInfoExcelServlet';
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
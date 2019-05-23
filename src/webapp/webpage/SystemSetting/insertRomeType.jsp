<%@ page contentType="text/html;charset=UTF-8" %>
<html>

	<head>
		<meta charset="utf-8">
		<title>Add room type</title>
		<link rel="stylesheet" href="../../js/layui/css/layui.css" media="all">
		<script src="../../js/layui/layui.js"></script>
		<script src="../../js/jquery.js"></script>
		<script src="../../js/global.js"></script>
	</head>

	<body>
		<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
			<legend>Add room type</legend>
		</fieldset>
		<form class="layui-form" action="">
			<div class="layui-form-item">
				<label class="layui-form-label">type name</label>
				<div class="layui-input-block">
					<input type="text" name="typeName" lay-verify="required|typeName" autocomplete="off" placeholder="please input type name" class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">price</label>
					<div class="layui-input-inline">
						<input type="text" name="price" lay-verify="required|number" autocomplete="off" placeholder="￥" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">Living together price</label>
					<div class="layui-input-inline">
						<input type="text" name="splicPrice" lay-verify="required|number" autocomplete="off" placeholder="￥" class="layui-input">
					</div>
				</div>
			</div>
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">Can exceed the predetermined number</label>
					<div class="layui-input-inline">
						<input type="text" name="exceedance" lay-verify="required|number" autocomplete="off" class="layui-input">
					</div>
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">Whether it is possible to build a house</label>
				<div class="layui-input-block">
					<input type="radio" name="isSplice" value="Y" title="YSE" checked="">
					<input type="radio" name="isSplice" value="N" title="NO">
				</div>
			</div>
			<div class="layui-form-item">
				<div class="layui-input-block">
					<button class="layui-btn" lay-submit lay-filter="insertRome">submit</button>
					<button type="reset" class="layui-btn layui-btn-primary">reset</button>
				</div>
			</div>
		</form>

		<script>
			layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form,
					layer = layui.layer;

				//自定义验证规则
				form.verify({
					typeName: function(value) {
						if(value.length < 3) {
							return 'room type must more than 3 characters';
						}

						if(value.length > 10) {
							return 'room type must less than 10 characters'
						}
					}
				});

				//监听提交
				form.on('submit(insertRome)', function(data) {
					$.post(baseUrl + '/InsertRoomTypeServlet', JSON.stringify(data.field), function(code) {
						if(code === 1) {
							layer.alert('insert success！', {
								title: 'success',
								icon: 6,
								anim: 5
							});
						} else if(code === 0) {
							layer.alert('An item with the same name already exists！', {
								title: 'repeat',
								icon: 4,
								anim: 6
							});
						} else {
							layer.alert('insert failed！', {
								title: 'failed',
								icon: 6,
								anim: 6
							});
						}
					});
					return false;
				});
			});
		</script>
	</body>

</html>
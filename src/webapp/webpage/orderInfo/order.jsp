<%@ page contentType="text/html;charset=UTF-8" %>
<html>

	<head>
		<meta charset="utf-8">
		<title>Booking form</title>
		<link rel="stylesheet" href="../../js/layui/css/layui.css" media="all">
		<script src="../../js/layui/layui.js"></script>
		<script src="../../js/jquery.js"></script>
		<script src="../../js/global.js"></script>
		<script src="../../js/getTime.js"></script>
		<script src="../../js/Cookie.js"></script>
	</head>

	<body>
		<fieldset class="layui-elem-field layui-field-title " style="margin-top: 20px;">
			<legend>Hotel management - Booking form</legend>
		</fieldset>

		<form class="layui-form">

			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">BookID</label>
					<div class="layui-input-block">
						<input type="text" id="orderId" class="layui-input" readonly>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">Book Person</label>
					<div class="layui-input-inline">
						<input type="text" id="orderName" lay-verify="required" autocomplete="off" placeholder="orderName" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">Book Tel</label>
					<div class="layui-input-inline">
						<input type="tel" id="orderPhone" lay-verify="phone" autocomplete="off" placeholder="orderPhone" class="layui-input">
					</div>
				</div>
			</div>

			<div class="layui-form-item">
				<label class="layui-form-label">ID</label>
				<div class="layui-input-block">
					<input type="text" id="orderIDcard" lay-verify="required|identity" placeholder="orderIDcard" autocomplete="off" class="layui-input">
				</div>
			</div>

			<div class="layui-form-item">

				<div class="layui-inline">
					<label class="layui-form-label">orderAllTime</label>
					<div class="layui-input-inline">
						<input type="text" class="layui-input" lay-verify="required" id="orderAllTime" placeholder="Arrival time - Leaving time" readonly>
					</div>
				</div>

				<div class="layui-inline">
					<label class="layui-form-label">Living population</label>
					<div class="layui-input-inline">
						<input type="text" id="checkNum" lay-verify="number" autocomplete="off" placeholder="Living population" class="layui-input">
					</div>
				</div>

				<div class="layui-inline">
					<label class="layui-form-label">Room type</label>
					<div class="layui-input-inline">
						<input type="text" id="typeId" lay-verify="required" autocomplete="off" placeholder="Room type" class="layui-input" readonly>
					</div>
					<button type="button" class="layui-btn layui-btn-primary" id="buttonTypeId"><i class="layui-icon">&#xe654;</i> select</button>
				</div>

			</div>

			<div class="layui-form-item">

				<div class="layui-inline">
					<label class="layui-form-label">Room price</label>
					<div class="layui-input-inline">
						<input type="text" id="price" lay-verify="number" autocomplete="off" placeholder="￥" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">Check-in price</label>
					<div class="layui-input-inline">
						<input type="text" id="checkPrice" lay-verify="number" autocomplete="off" placeholder="￥" class="layui-input">
					</div>
				</div>

			</div>

			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">discount</label>
					<div class="layui-input-inline">
						<input type="text" id="discount" lay-verify="number" autocomplete="off" placeholder="discount" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">Reason for discount</label>
					<div class="layui-input-inline">
						<input type="text" id="discountReason" autocomplete="off" placeholder="Reason for discount" class="layui-input">
					</div>
				</div>

			</div>

			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">Whether an extra bed</label>
					<div class="layui-input-inline">
						<input type="radio" name="addBed" value="Y" title="YES" lay-filter="addBedYes">
						<input type="radio" name="addBed" value="N" title="NO" lay-filter="addBedNo" checked="">
					</div>
				</div>
				<div class="layui-inline">
					<div id="addBed" class="layui-inline layui-hide">
						<label class="layui-form-label">Extra bed price</label>
						<div class="layui-input-inline">
							<input type="text" id="addBedPrice" lay-verify="number" autocomplete="off" placeholder="￥" class="layui-input">
						</div>
					</div>
				</div>
			</div>

			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">prepaid fee</label>
					<div class="layui-input-inline">
						<input type="text" id="orderMoney" lay-verify="required|number" autocomplete="off" placeholder="￥" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">Document status</label>
					<div class="layui-input-inline">
						<select name="city" class="layui-input-inline" id="orderState">
							<option value="Book">Book</option>
							<option value="Check in">Check in</option>
							<option value="Settlement">Settlement</option>
							<option value="extension">extension</option>
						</select>
					</div>
				</div>

			</div>

			<div class="layui-form-item layui-form-text">
				<label class="layui-form-label">Remarks</label>
				<div class="layui-input-block">
					<textarea id="remark" placeholder="please input" class="layui-textarea"></textarea>
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
			//layui的form表单默认的submit提交是真的不会用。
			//以JSON对象传递给后台的话，在传递前无法对数据二次修改。
			//所以就变成了整体传递过去，后端再解析JSON，但是解析时字段为空就又出错。
			//具体起来就是类似房间类型-新增房间那部分，全部字段强制要求全给，后端又set个别字段。
			//所以本文的提交就默认老老实实用ajax提交出去，不采用JSON对象了。

			layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form,
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;
				var isAddBed = false;

				//日期
				laydate.render({
					elem: '#arrireDate'
				});
				laydate.render({
					elem: '#leaveDate'
				});
				laydate.render({
					elem: '#orderAllTime',
					type: 'datetime',
					min: 0,
					range: '|',
					format: 'yyyy-MM-dd',
					calendar: true
				});

				//设置ID（读取的时间）
				var time = new Date().getTime();
				$(document).ready(function() {
					$("#orderId").val("OD" + time);
				});

				//一个属性的显隐，直接通过修改class实现，使用了layui的class属性
				form.on('radio(addBedYes)', function() {
					$('#addBed').removeClass("layui-hide");
					$('#addBed').addClass("layui-show");
					isAddBed = true;
				});
				form.on('radio(addBedNo)', function() {
					$('#addBed').removeClass("layui-show");
					$('#addBed').addClass("layui-hide");
					isAddBed = false;
				});

				//房间类型的选择
				$('#buttonTypeId').on('click', function() {
					layer.open({
						type: 2,
						title: 'Please select a room type',
						btn: ['confirm', 'cancel'],
						area: ['880px', '440px'],
						fixed: form,
						content: './selectRoomType.jsp',
						yes: function(index, layero) {
							typeId.value = $(layero).find('iframe')[0].contentWindow.tId.value; //将子窗口中的 tId 抓过来
							price.value = $(layero).find('iframe')[0].contentWindow.tPrice.value;
							layer.close(index); //关闭弹窗
						},
						btn2: function(index) {
							layer.close(index);
						},
						success: function(layero, index) {
							var obj = $(layero).find('iframe')[0].contentWindow;
						}
					});
				});

				//监听提交
				form.on('submit(insertRome)', function(data) {

					//先获取值
					var orderId = $('#orderId').val();
					var orderName = $('#orderName').val();
					var orderPhone = $('#orderPhone').val();
					var orderIDcard = $('#orderIDcard').val();
					var typeId = $('#typeId').val();

					//返回数据类型： yyyy-mm-dd hh:mm:ss
					var orderAllTime = ($('#orderAllTime').val()).split(" | ");
					var arrireDate = orderAllTime[0];
					var leaveDate = orderAllTime[1];

					var orderState = $('#orderState').val();
					var checkNum = $('#checkNum').val();

					// var roomId = $('#roomId').val(); 后台处理 -->直接放一个空类就行了

					var price = $('#price').val();
					var checkPrice = $('#checkPrice').val();
					var discount = $('#discount').val();
					var discountReason = $('#discountReason').val();

					//加床：true 不加：false
					var addBed = isAddBed;

					var addBedPrice = $('#addBedPrice').val();
					var orderMoney = $('#orderMoney').val();
					var operatorId = getCookie("loginName");
					var remark = $('#remark').val();

					var params = "orderId=" + orderId + "&orderName=" + orderName + "&orderPhone=" + orderPhone +
						"&orderIDcard=" + orderIDcard + "&typeId=" + typeId + "&arrireDate=" + arrireDate +
						"&leaveDate=" + leaveDate + "&orderState=" + orderState + "&checkNum=" + checkNum +
						"&price=" + price + "&checkPrice=" + checkPrice + "&discount=" + discount +
						"&discountReason=" + discountReason + "&addBed=" + addBed + "&addBedPrice=" + addBedPrice +
						"&orderMoney=" + orderMoney + "&operatorId=" + operatorId + "&remark=" + remark + "&make=1";

					$.post(baseUrl + '/InsertAndUpdateServlet', params, function(data) {
						if(data === '1') {
							layer.alert('The booking form was successfully registered!', {
								title: 'success',
								icon: 6,
								shade: 0.6,
								anim: 3,
								offset: '220px'
							});
						} else if(data === '0') {
							layer.alert('The same field exists!', {
								title: 'failed',
								icon: 5,
								shade: 0.6,
								anim: 6,
								offset: '220px'
							});
						} else {
							layer.alert('Booking order failed!', {
								title: 'failed',
								icon: 2,
								shade: 0.6,
								anim: 6,
								offset: '220px'
							});
						}
					});
					return false;
				});
			});
		</script>
	</body>

</html>
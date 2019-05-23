<%@ page contentType="text/html;charset=UTF-8" %>
<html>

<head>
    <meta charset="utf-8">
    <title>create account</title>
    <link rel="stylesheet" href="./js/layui/css/layui.css" media="all">
    <script src="./js/layui/layui.js"></script>
    <script src="./js/jquery.js"></script>
    <script src="./js/global.js"></script>
</head>

<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 10px;">
    <legend>create account</legend>
</fieldset>
<form class="layui-form" action="">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">username</label>
            <div class="layui-input-inline">
                <input type="text" name="loginName" lay-verify="required|inputName" autocomplete="off"
                       placeholder="username" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">password</label>
            <div class="layui-input-inline">
                <input type="password" name="loginPwd" id="pwd1" lay-verify="required|inputPwd" autocomplete="off"
                       placeholder="password" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">confirm password</label>
            <div class="layui-input-inline">
                <input type="password"  id="pwd2" lay-verify="required|inputPwd" autocomplete="off"
                       placeholder="confirm password" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">nickname</label>
            <div class="layui-input-inline">
                <input type="text" name="loginNickName" lay-verify="required|inputName" autocomplete="off"
                       placeholder="nickname" class="layui-input">
            </div>
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
    layui.use(['form', 'layedit', 'laydate'], function () {
        var form = layui.form,
            layer = layui.layer;

        //自定义验证规则
        form.verify({
            inputName: function (value) {
                if (value.length < 4) {
                    return 'must more than 4 characters';
                }

                if (value.length > 10) {
                    return 'must less than 4 characters'
                }
            },
            inputPwd: function (value) {
                if (value.length < 4) {
                    return 'must more than 4 characters';
                }

                if (value.length > 18) {
                    return 'must less than 18 characters'
                }
            }
        });

        //监听提交
        form.on('submit(insertRome)', function (data) {

            var pwd1 = $("#pwd1").val();
            var pwd2 = $("#pwd2").val();

            if (pwd1 != pwd2) {
                layer.msg("Inconsistent password");
            } else {

                $.post(baseUrl + '/InsertLoginServlet', JSON.stringify(data.field), function (code) {
                    if (code === 1) {
                        layer.alert('create success！', {
                            title: 'success！',
                            icon: 6,
                            anim: 5
                        });
                    } else {
                        layer.alert('create failed', {
                            title: 'error',
                            icon: 5,
                            anim: 6
                        });
                    }
                });
            }

            return false;
        });
    });
</script>
</body>

</html>
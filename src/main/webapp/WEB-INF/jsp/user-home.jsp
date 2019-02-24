<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>个人中心——座位表</title>
    <%@include file="inc/head.jsp" %>
</head>
<body>
<div class="wrapper">
    <%@include file="inc/header.jsp" %>
    <%@include file="inc/menu.jsp" %>
    <form id="user-modifyPsw-form" class="form" action="${pageContext.request.contextPath}/user/modifyPsw" method="post">
        <h3>修改密码</h3>
        <p>
            旧密码：
            <input type="password" name="oldPsw" class="txt">
        </p>
        <p>
            新密码：
            <input type="password" name="newPsw" class="txt">
        </p>
        <p>
            新密码：
            <input type="password" name="newPsw2" class="txt">
        </p>
        <p>
            <input type="submit" value="修改" class="btn">&nbsp;${ tipModifyPsw }
        </p>
    </form>
</div>
<script>
    $(function () {
        $("#user-modifyPsw-form").validate({
            onkeyup: false,
            rules: {
                oldPsw: {
                    required: true,
                    remote: {
                        type: "POST",
                        url: "${pageContext.request.contextPath}/user/checkOldPsw",
                        dataType: "json",
                        oldPsw: function () {
                            return $.trim($("[name='oldPsw']").val())
                        }
                    }
                },
                newPsw: {
                    required: true,
                    minlength: 6
                },
                newPsw2: {
                    required: true,
                    minlength: 6,
                    equalTo: "[name='newPsw']"
                }
            },
            messages: {
                oldPsw: {
                    required: "旧密码不能为空",
                    remote: "旧密码不正确"
                },
                newPsw: {
                    required: "新密码不能为空",
                    minlength: "密码长度不能低于6位"
                },
                newPsw2: {
                    required: "新密码不能为空",
                    minlength: "密码长度不能低于6位",
                    equalTo: "两次密码不一致"
                }
            }
        })
    })
</script>
</body>
</html>


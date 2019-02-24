<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>    
    <title>用户登录——座位表</title>
    <%@include file="inc/head.jsp" %>
</head>
<body>
<div class="wrapper">
    <%@include file="inc/header.jsp" %>
    <form id="user-login-form" class="form" action="${pageContext.request.contextPath}/user/loginCheck" method="post">
        <p>
            登录账号：<input type="text" name="loginId" class="txt">
        </p>
        <p>
            登录密码：<input type="password" name="loginPsw" class="txt">
        </p>
        <p>
            <input type="submit" value="登录" class="btn">
            <label class="error">${ tip }</label>
        </p>
    </form>
</div>

<script>
    $(function () {
        $("#user-login-form").validate({
            rules : {
                loginId : "required",
                loginPsw : "required"
            },
            messages: {
                loginId : "账号不能为空",
                loginPsw : "密码不能为空"
            }
        })
    })
</script>
</body>
</html>

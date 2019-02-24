<%@ page pageEncoding="UTF-8" %>
    <p class="welcome">
        ${currUser.name}[${currUser.type}]，
            <a href="/user/logout">登出</a>
    </p>
    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/user/home">个人中心</a></li>
        <li><a href="${pageContext.request.contextPath}/klass/mgr">班级座位表</a></li>
    </ul>


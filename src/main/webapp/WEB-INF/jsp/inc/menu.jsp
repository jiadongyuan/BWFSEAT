<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <p class="welcome">
        ${currUser.name}[${currUser.type}]，
            <a href="/user/logout">登出</a>
    </p>
    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/user/home">个人中心</a></li>
        <c:if test="${currUser.type eq '管理员'}">
            <li><a href="${pageContext.request.contextPath}/user/mgr">用户管理</a></li>
        </c:if>
        <c:if test="${currUser.type eq '班主任' || currUser.type eq '咨询师'}">
            <li><a href="${pageContext.request.contextPath}/klass/mgr">班级座位表</a></li>
        </c:if>
    </ul>


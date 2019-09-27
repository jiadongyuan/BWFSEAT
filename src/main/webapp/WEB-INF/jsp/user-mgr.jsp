<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户管理——座位表</title>
    <%@include file="inc/head.jsp" %>
</head>
<body>
<div class="wrapper">
    <%@include file="inc/header.jsp" %>
    <%@include file="inc/menu.jsp" %>
    <c:if test="${currUser.type eq '管理员'}">
    <div>
        <div class="fl" style="width: 600px;">
            <h3>用户列表</h3>
            <table class="table">
                <tr class="row-header">
                    <td width="80">
                        用户姓名
                    </td>
                    <td width="80">
                        用户类型
                    </td>
                    <td width="80">
                        用户状态
                    </td>
                    <td width="180">
                        操作
                    </td>
                </tr>
                <c:forEach items="${allUsers}" var="u">
                    <tr>
                        <td id="uname-${u.id}">
                            ${u.name}
                        </td>
                        <td id="utype-${u.id}">
                            ${u.type}
                        </td>
                        <td id="ustatus-${u.id}">
                            ${u.status}
                        </td>
                        <td>
                            <a href="javascript:editUser(${u.id})">编辑</a>
                            <c:if test="${u.status eq '已启用'}">
                                <a href="javascript:changeStatus(${u.id}, '已停用')">停用</a>
                            </c:if>
                            <c:if test="${u.status eq '已停用'}">
                                <a href="javascript:changeStatus(${u.id}, '已启用')">启用</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
        <div class="fl" style="width:400px;">
            <h3>录入新用户</h3>
            <form id="create-user-form" class="form" action="${pageContext.request.contextPath}/user/create" method="post">
                <input type="hidden" name="status" value="已启用">
                <p>
                    用户账号：
                    <input type="text" name="loginId" class="txt" value="" placeholder="建议用员工的姓名全拼">
                </p>
                <p>
                    用户密码：
                    <input type="text" name="loginPsw" readonly class="txt" value="000000">
                </p>
                <p>
                    用户姓名：
                    <input type="text" name="name" class="txt" value="">
                </p>
                <p>
                    用户类型：
                    <select name="type">
                        <option value="咨询师">咨询师</option>
                        <option value="班主任">班主任</option>
                        <option value="讲师">讲师</option>
                    </select>
                </p>
                <p>
                    <input type="submit" value="创建" class="btn">
                    ${ tipCreateUser }
                </p>
            </form>
        </div>
        <div class="fc">
        </div>
    </div>
    </c:if>
</div>

<c:if test="${currUser.type eq '管理员'}">

<div id="edit-user-dialog" title="修改用户信息" style="display: none;">
    <form id="edit-user-form">
        <p>
            用户姓名：
            <input type="text" name="editName" class="txt" value="">
        </p>
        <p>
            用户类型：
            <select name="editType">
                <option value="咨询师">咨询师</option>
                <option value="班主任">班主任</option>
            </select>
        </p>
        <p>
            <input type="submit" class="btn" value="修改">
            <input type="button" id="btnCancelEdit" class="btn" value="取消">
        </p>
        <p id="tipModifyUser"></p>
    </form>
</div>
<script>

    var editUserId;

    function editUser(uid) {
        editUserId = uid;
        $("#edit-user-dialog").dialog("open");
    }

    function changeStatus(uid, ustatus) {
        window.location = "${pageContext.request.contextPath}/user/changeStatus?id=" + uid + "&status=" + ustatus;
    }

    function modifyUser() {
        var editName = $.trim($("[name='editName']").val());
        var editType = $.trim($("[name='editType']").val());
        $.post("${pageContext.request.contextPath}/user/modify",
            {"id": editUserId, "name" : editName, "type": editType},
            function () {
                $("#uname-" + editUserId).html(editName);
                $("#utype-" + editUserId).html(editType);
                $("#tipModifyUser").html("修改成功！");
            });
    }

    $(function () {
        /**
         *  设置“编辑用户信息”的对话框和open事件
         */
        $("#edit-user-dialog").dialog({
            autoOpen: false,
            width: 400,
            modal: true,
            open: function() {
                $("#tipModifyUser").html("").css("color", "black");
                $("[name='editName']").val($.trim($("#uname-" + editUserId).html()));
                $("[name='editType']").val($.trim($("#utype-" + editUserId).html()));
            }
        });

        /**
         *  单击编辑用户对话框的“取消按钮”时，关闭对话框
         */
        $("#btnCancelEdit").on("click", function(){
            $("#edit-user-dialog").dialog("close");
        });

        /**
         * “编辑用户信息”的表单验证
         */
        $("#edit-user-form").validate({
            onkeyup: false,
            submitHandler: function () {
                modifyUser();
            },
            errorPlacement: function (error, element) {
                element.parent().after(error)
            },
            rules: {
                editName: "required"
            },
            messages: {
                editName: "用户姓名不能为空！"
            }
        });

        /**
         * “创建新用户信息”的表单验证
         */
        $("#create-user-form").validate({
            onkeyup: false,
            errorPlacement: function (error, element) {
                element.parent().after(error)
            },
            rules: {
                loginId: "required",
                name: "required"
            },
            messages: {
                loginId: "账号不能为空！",
                name: "班级名不能为空！"
            }
        })
    })
</script>
</c:if>
</body>
</html>
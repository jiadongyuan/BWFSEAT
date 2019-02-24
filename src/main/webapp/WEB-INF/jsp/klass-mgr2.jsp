<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>班级——座位表</title>
    <%@include file="inc/head.jsp" %>
</head>
<body>
<div class="wrapper">
    <%@include file="inc/header.jsp" %>
    <%@include file="inc/menu.jsp" %>
    <div>
        <div class="fl" style="width: 600px;">
            <h3>班级座位表</h3>
            <table class="table">
                <tr class="row-header">
                    <td width="80">
                        班级期数
                    </td>
                    <td width="80">
                        班主任
                    </td>
                    <td width="80">
                        座位数量
                    </td>
                    <td width="180">
                        操作
                    </td>
                </tr>
                <c:forEach items="${allKlasses}" var="k">
                    <tr>
                        <td id="kname-${k.id}">
                            ${k.name}
                        </td>
                        <td id="kmaster-${k.id}">
                            ${k.master.name}
                        </td>
                        <td id="kseatCount-${k.id}">
                            ${k.seatCount}
                        </td>
                        <td>
                            <a href="seat-details.html">进入座位表</a>
                            <a href="javascript:editKlass(${k.id})">编辑</a>
                            <a href="javascript:deleteKlass(${k.id})">删除</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
        <div class="fl" style="width:400px;">
            <h3>录入新班级座位表</h3>
            <form id="create-klass-form" class="form" action="${pageContext.request.contextPath}/klass/create" method="post">
                <p>
                    班级期数：
                    <input type="text" name="name" class="txt" value="${recommendedNewKlass.name}">
                </p>
                <p>
                    带班主任：
                    <select name="master.id">
                        <c:forEach items="${masters}" var="m">
                            <option value="${m.id}" ${m.id eq currUser.id ? "selected" : ""}>${m.name}</option>
                        </c:forEach>
                    </select>
                </p>
                <p>
                    座位数量：
                    <input type="text" name="seatCount" class="txt" value="${recommendedNewKlass.seatCount}">
                </p>
                <p>
                    备注信息：
                    <textarea name="remark" class="txt-multi-line"></textarea>
                </p>
                <p>
                    <input type="submit" value="创建" class="btn">
                    ${ tipCreateKlass }
                </p>
            </form>
        </div>
        <div class="fc">
        </div>
    </div>
</div>
<div id="edit-klass-dialog" title="修改班级信息" style="display: none;">
    <p>
        班级期数：
        <input type="text" id="editName" class="txt" value="">
    </p>
    <p>
        带班主任：
        <select id="editMaster">
            <c:forEach items="${masters}" var="m">
                <option value="${m.id}">${m.name}</option>
            </c:forEach>
        </select>
    </p>
    <p>
        座位数量：
        <input type="text" id="editSeatCount" class="txt" value="">
    </p>
    <p>
        备注信息：
        <textarea id="editRemark" class="txt-multi-line"></textarea>
    </p>
</div>
<script>
    $(function () {
        /*
            编辑班级信息的对话框设置
        */
        $("#edit-klass-dialog").dialog({
            autoOpen: false,
            width: 400,
            modal: true,
            open: function() {
                $.getJSON("${pageContext.request.contextPath}/klass/edit", {"kid": editKlassId}, function (editKlass) {
                    $("#editName").val(editKlass.name)
                    $("#editMaster").val(editKlass.master.id)
                    $("#editSeatCount").val(editKlass.seatCount)
                    $("#editRemark").val(editKlass.remark)
                })
            },
            buttons: {
                "修改": function() {
                    var editName = $.trim($("#editName").val())
                    var editSeatCount = $.trim($("#editSeatCount").val())
                    var editMasterId = $("#editMaster").val()
                    var editRemark = $.trim($("#editRemark").val())
                    if(editName == "") {
                        alert("班级名不能为空")
                    } else if(editSeatCount == "") {
                        alert("班级座位数量不能为空")
                    } else if(window.isNaN(editSeatCount)){
                        alert("班级座位数必须是一个数字")
                    } else if(window.parseInt(editSeatCount) < 1 || window.parseInt(editSeatCount) > 60) {
                        alert("班级座位表数量必须在1到60之间！")
                    } else {
                        $.post("${pageContext.request.contextPath}/klass/modify",
                            {"id": editKlassId, "name" : editName, "master.id": editMasterId, "seatCount": editSeatCount, "remark": editRemark},
                            function (result) {
                                if(result){
                                    $("#kname-" + editKlassId).html(editName)
                                    $("#kmaster-" + editKlassId).html($("#editMaster option:selected").html())
                                    $("#kseatCount-" + editKlassId).html(editSeatCount)
                                    alert("修改成功！");
                                } else {
                                    alert("修改失败：您不能将班级名改成已经存在的其他班级名")
                                }
                            },
                            "json")
                    }
                },
                "取消": function() {
                    $(this).dialog("close");
                }
            }
        })


        /*
            创建新班级的表单验证
        */
        $("#create-klass-form").validate({
            onkeyup: false,
            rules: {
                name: "required",
                seatCount: {
                    required: true,
                    range: [1, 60]
                }
            },
            messages: {
                name: "班级名不能为空！",
                seatCount: {
                    required: "班级座位表作为数量不能为空！",
                    min: "班级座位表数量必须在1到60之间！"
                }
            }
        })

    })

    function deleteKlass(kid) {
        if(confirm("是否真的要删除该班级座位表？")) {
            location.href = "${pageContext.request.contextPath}/klass/delete?kid=" + kid
        }
    }

    var editKlassId;

    function editKlass(kid) {
        editKlassId = kid;
        $("#edit-klass-dialog").dialog("open");
    }
</script>
</body>
</html>
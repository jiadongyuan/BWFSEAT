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
    <form id="edit-klass-form">
        <p>
            班级期数：
            <input type="text" name="editName" class="txt" value="">
        </p>
        <p>
            带班主任：
            <select name="editMaster">
                <c:forEach items="${masters}" var="m">
                    <option value="${m.id}">${m.name}</option>
                </c:forEach>
            </select>
        </p>
        <p>
            座位数量：
            <input type="text" name="editSeatCount" class="txt" value="">
        </p>
        <p>
            备注信息：
            <textarea name="editRemark" class="txt-multi-line"></textarea>
        </p>
        <p>
            <input type="submit" class="btn" value="修改">
            <input type="button" id="btnCancelEdit" class="btn" value="取消">
        </p>
        <p id="tipModifyKlass"></p>
    </form>
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
                $("#tipModifyKlass").html("")
                $.getJSON("${pageContext.request.contextPath}/klass/edit", {"kid": editKlassId}, function (editKlass) {
                    $("[name='editName']").val(editKlass.name)
                    $("[name='editMaster']").val(editKlass.master.id)
                    $("[name='editSeatCount']").val(editKlass.seatCount)
                    $("[name='editRemark']").val(editKlass.remark)
                })
            }
        })


        /*
            创建新班级的表单验证
        */
        $("#create-klass-form").validate({
            onkeyup: false,
            errorPlacement: function (error, element) {
                element.parent().after(error)
            },
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
                    required: "座位数量不能为空！",
                    min: "座位数量必须在1到60之间！"
                }
            }
        })

        /*
            编辑班级的表单验证
         */
        $("#edit-klass-form").validate({
            onkeyup: false,
            submitHandler: function () {
                modifyKlass()
            },
            errorPlacement: function (error, element) {
                element.parent().after(error)
            },
            rules: {
                editName: "required",
                editSeatCount: {
                    required: true,
                    range: [1, 60]
                }
            },
            messages: {
                editName: "班级名不能为空！",
                editSeatCount: {
                    required: "座位数量不能为空！",
                    min: "座位数量必须在1到60之间！"
                }
            }
        })

        $("#btnCancelEdit").on("click", function(){
            $("#edit-klass-dialog").dialog("close")
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

    function modifyKlass() {
        var editName = $.trim($("[name='editName']").val())
        var editSeatCount = $.trim($("[name='editSeatCount']").val())
        var editMasterId = $("[name='editMaster']").val()
        var editRemark = $.trim($("[name='editRemark']").val())
        $.post("${pageContext.request.contextPath}/klass/modify",
            {"id": editKlassId, "name" : editName, "master.id": editMasterId, "seatCount": editSeatCount, "remark": editRemark},
            function (result) {
                var tip
                if(result){
                    $("#kname-" + editKlassId).html(editName)
                    $("#kmaster-" + editKlassId).html($("[name='editMaster'] option:selected").html())
                    $("#kseatCount-" + editKlassId).html(editSeatCount)
                    tip = "修改成功！";
                } else {
                    tip = "修改失败：不能将班级名改成已存在的其他班级名"
                    $("#tipModifyKlass").css("color", "red")
                }
                $("#tipModifyKlass").html(tip)
            },
            "json")
        }
</script>
</body>
</html>
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
        <div class="fl" style="width: 700px;">
            <h3>109期班级座位表详情</h3>
            <div class="seat-sheet">
                <c:forEach items="${seats}" var="seatColumns">
                <div class="fl" style="width: 100px;">
                    <c:forEach items="${seatColumns}" var="seat">
                    <div class="seat"><input type='text' id='${seat.id}' owner='${empty seat.owner ? "null" : seat.owner.id}' value="${seat.content}"></div>
                    </c:forEach>
                </div>
                </c:forEach>
            </div>
        </div>

        <div class="fl" style="margin-left: 20px; width:270px;">
            <h3>座位信息</h3>
            <div id='seat-info'>
                <p>当前选中的座位ID是：<span id='selected-id'></span></p>
                <p>当前选中的座位中的信息：<span id='selected-content'></span></p>
                <p>当前选中的座位的拥有者：<span id='selected-owner'></span></p>
            </div>
            <h3>调试信息</h3>
            <div id="debug">
                <p>当前正在编辑的座位ID为[<span id='editing'></span>]</p>
            </div>
        </div>
        <div class="fc">
        </div>
    </div>

</div>
<script>

    var currUser = { id: "${currUser.id}", name: "${currUser.name}", type: "${currUser.type}" }
    var  editingId = null

    $(function(){

        $(".seat input[owner = '" + currUser.id + "']").css("color", "green").css("font-weight", "bold")

        $(".seat input")
            .attr("readonly", true)
            .css("cursor", "pointer")
            .on("focus", function() {
                $(".seat").css("border-color", "#000000")
                $(this).attr("readonly", true).css("cursor", "pointer")
                $(this).parent().css("border-color", "orange")
                $("#selected-id").html(this.id);
                $("#selected-content").html(this.value);
                $("#selected-owner").html($(this).attr("owner") != "null"? $(this).attr("owner") : "");

            }).on("keydown", function(event){
            if(event.keyCode == 13) {
                $(this).blur();
                return;
            }

            if($(this).attr("owner") != 'null' && $(this).attr("owner") != currUser.id) {
                alert("该座位上学员不是自己的学员，不能编辑")
                return;
            }

            if(this.readOnly) {
                $(this).attr("readonly", false).css("cursor", "auto")
            }

        }).on("input", function(){
            editingId=this.id
            $("#editing").html(editingId)
            $("#selected-content").html(this.value)
        }).on("dblclick",function(){
            if($(this).attr("owner") != 'null' && $(this).attr("owner") != currUser.id) {
                alert("该座位上学员不是自己的学员，不能编辑")
                return;
            }

            $(this).attr("readonly", false).css("cursor", "auto").select()

            editingId=this.id
            $("#editing").html(editingId)
            $("#selected-content").html(this.value)
        })
            .on("blur", function(){
                $(this).attr("readonly", true).css("cursor", "pointer")
                if(editingId != null && editingId == this.id) {
                    if($.trim(this.value) == "") {
                        $(this).attr("owner", "null")
                        $(this).css("color", "black").css("font-weight", "lighter")
                        $("#selected-owner").html("")
                    }else {
                        $(this).attr("owner", currUser.id)
                        $(this).css("color", "green").css("font-weight", "bold")
                        $("#selected-owner").html(currUser.id)
                    }
                    editingId=null;
                    $("#editing").html(editingId)
                }
            })

    })

</script>
</body>
</html>

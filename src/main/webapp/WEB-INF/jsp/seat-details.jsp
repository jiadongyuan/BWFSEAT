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
                <div class="fl" style="width: 100x;">
                    <div class="seat"><input id='1001' type='text'></div>
                    <div class="seat"><input id='1002' owner='张三' type='text' value='学员A'></div>
                    <div class="seat"><input id='1003' owner='李四' type='text' value='学员B'></div>
                    <div class="seat"><input id='1004' type='text'></div>
                    <div class="seat"><input id='1005' type='text'></div>
                    <div class="seat"><input id='1006' type='text'></div>
                    <div class="seat"><input id='1007' type='text'></div>
                    <div class="seat"><input id='1008' type='text'></div>
                </div>
                <div class="fl" style="width: 100x;">
                    <div class="seat"><input id='1009' type='text'></div>
                    <div class="seat"><input id='1010' type='text'></div>
                    <div class="seat"><input id='1011' type='text'></div>
                    <div class="seat"><input id='1012' type='text'></div>
                    <div class="seat"><input id='1013' type='text'></div>
                    <div class="seat"><input id='1014' type='text'></div>
                    <div class="seat"><input id='1015' type='text'></div>
                    <div class="seat"><input id='1016' type='text'></div>
                </div>
                <div class="fl" style="width: 100x;">
                    <div class="seat"><input id='1017' type='text'></div>
                    <div class="seat"><input id='1018' type='text'></div>
                    <div class="seat"><input id='1019' type='text'></div>
                    <div class="seat"><input id='1020' type='text'></div>
                    <div class="seat"><input id='1021' type='text'></div>
                    <div class="seat"><input id='1022' type='text'></div>
                    <div class="seat"><input id='1023' type='text'></div>
                    <div class="seat"><input id='1024' type='text'></div>
                </div>
                <div class="fl" style="width: 100x;">
                    <div class="seat"><input id='1025' type='text'></div>
                    <div class="seat"><input id='1026' type='text'></div>
                    <div class="seat"><input id='1027' type='text'></div>
                    <div class="seat"><input id='1028' type='text'></div>
                    <div class="seat"><input id='1029' type='text'></div>
                    <div class="seat"><input id='1030' type='text'></div>
                    <div class="seat"><input id='1031' type='text'></div>
                    <div class="seat"><input id='1032' type='text'></div>
                </div>
                <div class="fl" style="width: 100x;">
                    <div class="seat"><input id='1033' type='text'></div>
                    <div class="seat"><input id='1034' type='text'></div>
                    <div class="seat"><input id='1035' type='text'></div>
                    <div class="seat"><input id='1036' type='text'></div>
                    <div class="seat"><input id='1037' type='text'></div>
                    <div class="seat"><input id='1038' type='text'></div>
                    <div class="seat"><input id='1039' type='text'></div>
                    <div class="seat"><input id='1040' type='text'></div>
                </div>
                <div class="fl" style="width: 100x;">
                    <div class="seat"><input id='1041' type='text'></div>
                    <div class="seat"><input id='1042' type='text'></div>
                    <div class="seat"><input id='1043' type='text'></div>
                    <div class="seat"><input id='1044' type='text'></div>
                    <div class="seat"><input id='1045' type='text'></div>
                    <div class="seat"><input id='1046' type='text'></div>
                    <div class="seat"><input id='1047' type='text'></div>
                    <div class="seat"><input id='1048' type='text'></div>
                </div>
                <div class="fl" style="width: 100x;">
                    <div class="seat"><input id='1049' type='text'></div>
                    <div class="seat"><input id='1050' type='text'></div>
                </div>
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
<script src="js/jquery-3.3.1.min.js"></script>
<script>

    var currUser = '张三'
    var  editingId = null

    $(function(){

        $(".seat input[owner = '" + currUser + "']").css("color", "green").css("font-weight", "bold")

        $(".seat input")
            .attr("readonly", true)
            .css("cursor", "pointer")
            .on("focus", function() {
                $(".seat").css("border-color", "#000000")
                $(this).attr("readonly", true).css("cursor", "pointer")
                $(this).parent().css("border-color", "orange")
                $("#selected-id").html(this.id);
                $("#selected-content").html(this.value);
                $("#selected-owner").html($(this).attr("owner")? $(this).attr("owner") : "");

            }).on("keydown", function(event){
            if(event.keyCode == 13) {
                $(this).blur();
                return;
            }

            if($(this).attr("owner") != null && $(this).attr("owner") != currUser) {
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
            if($(this).attr("owner") != null && $(this).attr("owner") != currUser) {
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
                        $(this).removeAttr("owner")
                        $(this).css("color", "black").css("font-weight", "lighter")
                        $("#selected-owner").html("")
                    }else {
                        $(this).attr("owner", currUser)
                        $(this).css("color", "green").css("font-weight", "bold")
                        $("#selected-owner").html(currUser)
                    }
                    editingId=null;
                    $("#editing").html(editingId)
                }
            })

    })

</script>
</body>
</html>

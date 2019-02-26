<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${klass.name}——座位表</title>
    <%@include file="inc/head.jsp" %>
</head>
<body>
<div class="wrapper">
    <%@include file="inc/header.jsp" %>
    <%@include file="inc/menu.jsp" %>
    <div>
        <div class="fl" style="width: 720px;">
            <h3>${klass.name}座位表详情（座位数量：${klass.seatCount}）</h3>
            <div class="seat-sheet">
                <c:forEach items="${seats}" var="seatColumns">
                    <div class="fl" style="width: 100px;">
                        <c:forEach items="${seatColumns}" var="seat">
                            <div class="seat"><input type='text' id='${seat.id}'
                                                     owner='${empty seat.owner ? "null" : seat.owner.id}'
                                                     value="${seat.content}"></div>
                        </c:forEach>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="fl" style="margin-left: 20px; width:250px;">
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

    var currUser = {id: "${currUser.id}", name: "${currUser.name}", type: "${currUser.type}"}
    var editingId = null

    $(function () {

        var ws = new WebSocket("ws://localhost/websocket");

        window.onunload = function () {
            ws.close()
        }

        $(".seat input[owner = '" + currUser.id + "']").css("color", "green").css("font-weight", "bold")

        $(".seat input")
            .attr("readonly", true)
            .css("cursor", "pointer")
            .on("focus", function () {
                $(".seat").css("border-color", "#000000")
                $(this).attr("readonly", true).css("cursor", "pointer")
                $(this).parent().css("border-color", "orange")
                $("#selected-id").html(this.id);
                $("#selected-content").html(this.value);
                $("#selected-owner").html($(this).attr("owner") != "null" ? $(this).attr("owner") : "");

            }).on("keydown", function (event) {
            if (event.keyCode == 13) {
                $(this).blur();
                return;
            }

            if ($(this).attr("owner") != 'null' && $(this).attr("owner") != currUser.id) {
                alert("该座位上学员不是自己的学员，不能编辑")
                return;
            }

            if (this.readOnly) {
                $(this).attr("readonly", false).css("cursor", "auto")
            }

        }).on("input", function () {
            if(editingId == null) {
                startEditing(this.id)
            }
        }).on("dblclick", function () {
            if ($(this).attr("owner") != 'null' && $(this).attr("owner") != currUser.id) {
                alert("该座位上学员不是自己的学员，不能编辑")
                return;
            }

            $(this).attr("readonly", false).css("cursor", "auto").select()

            startEditing(this.id)
        }).on("blur", function () {
            $(this).attr("readonly", true).css("cursor", "pointer")
            if (editingId != null && editingId == this.id) {
                var $txtSeat = $(this);
                if ($.trim(this.value) == "") {
                    $.post("${pageContext.request.contextPath}/seat/update",
                        {"id": editingId, "status": "空座位"},
                        function () {
                            ws.send('{"cmd" : "seatupdated", "seatid": ' + $txtSeat.attr("id") +', "ownerid": "null", "content": null}')
                            console.log("\n座位信息更新成功")
                            console.log("\tseat id: ", $txtSeat.attr("id"))
                            console.log("\tseat owner id: null")
                            console.log("\tseat content: null")
                            console.log("\tseat status: 未提交资料")
                            $txtSeat.attr("owner", "null")
                            $txtSeat.css("color", "black").css("font-weight", "lighter")
                            $("#selected-owner").html("")
                        })
                } else {
                    $.post("${pageContext.request.contextPath}/seat/update",
                        {"id": editingId, "owner.id": currUser.id, "content": $.trim(this.value), "status": "未提交资料"},
                        function () {
                            ws.send('{"cmd" : "seatupdated", "seatid": ' + $txtSeat.attr("id") +', "ownerid": ' + currUser.id + ', "content": "' + $.trim($txtSeat.val()) + '", "status": "未提交资料"}')
                            console.log("\n座位信息更新成功")
                            console.log("\tseat id: ", $txtSeat.attr("id"))
                            console.log("\tseat owner id: ", currUser.id)
                            console.log("\tseat content: ", $.trim($txtSeat.val()))
                            console.log("\tseat status: 未提交资料")
                            $txtSeat.attr("owner", currUser.id)
                            $txtSeat.css("color", "green").css("font-weight", "bold")
                            $("#selected-owner").html(currUser.id + "[" + currUser.name + "]")
                        })
                }
                editingId = null;
                $("#editing").html(editingId)
            }
        })

        ws.onmessage = function(event){
            var message = JSON.parse(event.data);
            console.log("\nmessage: ", message)
            if(message.cmd == "seatupdated") {
                $("#" + message.seatid)
                    .val(message.content)
                    .attr("owner", message.ownerid)
                    .css("color", "black")
            } else if(message.cmd == "seatediting") {
                $("#" + message.seatid)
                    .val("['" + message.owner.name + "'编辑中]")
                    .attr("owner", message.owner.id)
                    .css("color", "black")
            }
        }

        function startEditing(sid) {
            editingId = sid
            var message = {
                "cmd" : "seatediting",
                "seatid": editingId,
                "owner" : {
                    "id" : currUser.id,
                    "name" : currUser.name,
                    "type": currUser.type
                }
            }
            ws.send(JSON.stringify(message))
            $("#editing").html(editingId)
            $("#selected-content").html(this.value)
        }

    })


</script>
</body>
</html>

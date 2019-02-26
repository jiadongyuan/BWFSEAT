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
                            <div class="seat">
                                <input type='text' id='${seat.id}' value="${seat.content}">
                                <span id="ownerinfo-${seat.id}" style="display: none;">
                                    <c:if test="${ empty seat.owner}">null</c:if>
                                    <c:if test="${ not empty seat.owner}">{"id": ${seat.owner.id}, "name": "${seat.owner.name}", "type": "${seat.owner.type}" }</c:if>
                                </span>
                            </div>
                        </c:forEach>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="fl" style="margin-left: 20px; width:250px;">
            <h3>座位信息</h3>
            <div id='seat-info' style="font-size: 12px;">
                <p>当前选中的座位中的信息：<span id='selected-content'></span></p>
                <p>当前选中的座位的拥有者：<span id='selected-owner'></span></p>
            </div>
        </div>
        <div class="fc">
        </div>
    </div>

</div>
<script>
    /**
     *  当前正在编辑中的座位ID，初始值为null
     */
    var editingId = null

    /**
     *  当前登录的用户对象
     */
    var currUser = {id: "${currUser.id}", name: "${currUser.name}", type: "${currUser.type}"}


    $(function () {

        var ws = new WebSocket("ws://localhost/websocket")

        window.onbeforeunload = function () {
            ws.close()
        }

        ws.onmessage = function (event) {
            var message = JSON.parse(event.data);
            console.log("\nmessage: ", message)
            if (message.cmd == "seatupdated") {
                $("#" + message.seat.id).val(message.seat.content).css("color", "black").css("font-weight", "lighter")
                $("#ownerinfo-" + message.seat.id).html(JSON.stringify(message.seat.owner))
            } else if (message.cmd == "seatediting") {
                $("#" + message.seat.id).val("['" + message.seat.owner.name + "'编辑中]").css("color", "black")
                $("#ownerinfo-" + message.seat.id).html(JSON.stringify(message.seat.owner))
            }
        }

        /**
         *  将每一个“拥有者为当前用户”的座位的样式设置成：粗体、绿色
         */
        $(".seat span[id^='ownerinfo-']").each(function () {
            var owner = JSON.parse($.trim($(this).html()))
            if (owner != null && owner.id == currUser.id) {
                $(this).prev("input").css("color", "green").css("font-weight", "bold")
            }
        })

        /**
         *  将所有座位文本框的初始状态设置为只读，手型光标
         */
        $(".seat input").attr("readonly", true).css("cursor", "pointer")

        /**
         *  “座位文本框”获取焦点时变为“选中座位”：
         *  （1）设置选中状态样式属性：只读、橙色边框、手型光标
         *  （2）页面右侧“座位信息栏”上更新“选中座位”信息：content、owner
         */
        $(".seat input").on("focus", function () {
            // 恢复所有的座位的非选中样式
            $(".seat").css("border-color", "#000000")
            // 设置选中座位样式
            $(this).parent().css("border-color", "orange")
            // 更新选中座位信息
            $("#selected-content").html(this.value)
            var owner = JSON.parse($.trim($("#ownerinfo-" + $(this).attr("id")).html()))
            $("#selected-owner").html(owner ? owner.name : "[无]")
        })

        $(".seat input").on("keydown", function (event) {
            if (event.keyCode == 13) {
                $(this).blur();
                return;
            }

            var owner = JSON.parse($.trim($("#ownerinfo-" + $(this).attr("id")).html()))
            if (owner == null || owner.id == currUser.id) {
                $(this).attr("readonly", false).css("cursor", "auto")
            } else if(currUser.type == "班主任") {
                if(confirm("该座位上学员不是自己的学员，不能修改！\n但您可以删除该座位学员信息，是否要删除？")) {
                    $(this).val("")
                    editingId = $(this).attr("id")
                    $(this).blur();
                }
            } else {
                alert("该座位上学员不是自己的学员，不能修改！")
            }
        })

        $(".seat input").on("input", function () {
            if (editingId == null) {
                editingId = this.id
                startEditing()
            }
            $("#selected-content").html(this.value)
        })

        $(".seat input").on("dblclick", function () {
            var owner = JSON.parse($.trim($("#ownerinfo-" + $(this).attr("id")).html()))
            if (owner == null || owner.id == currUser.id) {
                $(this).attr("readonly", false).css("cursor", "auto")
                $(this).select()
                $("#selected-content").html(this.value)
                if (editingId == null) {
                    editingId = this.id
                    startEditing()
                }
            } else if(currUser.type == "班主任") {
                if(confirm("该座位上学员不是自己的学员，不能修改！\n但您可以删除该座位学员信息，是否要删除？")) {
                    $(this).val("")
                    editingId = $(this).attr("id")
                    $(this).blur();
                }
            } else {
                alert("该座位上学员不是自己的学员，不能修改！")
            }

        })

        $(".seat input").on("blur", function () {
            //  “座位”文本框失去焦点时，设置成“非选中”样式：只读、手型指针
            $(this).attr("readonly", true).css("cursor", "pointer")
            //  如果当前失去焦点的座位不是正在编辑的座位，则什么都不做
            if (editingId != this.id) {
                return
            }
            //  如果当前失去焦点的座位刚好是正在编辑的座位，则代表编辑完成，需要更新服务器上的座位信息
            var $txtSeat = $(this)
            if ($.trim($txtSeat.val()) == "") {
                $.post("${pageContext.request.contextPath}/seat/update",
                    {"id": $txtSeat.attr("id"), "status": "空座位"},
                    function () {
                        //  服务器座位信息更新为“空座位”后，设置该座位的拥有这信息为null
                        $("#ownerinfo-" + $txtSeat.attr("id")).html("null");
                        $("#selected-owner").html("[无]")
                        $("#selected-content").html($.trim($txtSeat.val()))
                        $txtSeat.css("color", "black").css("font-weight", "lighter")

                        //  服务器座位信息更新为“空座位”后，通过websocket，通知所有的其它客户端
                        var message = {
                            "cmd": "seatupdated",
                            "seat": {
                                "id": $txtSeat.attr("id"),
                                "content": null,
                                "owner": null
                            }
                        }
                        ws.send(JSON.stringify(message))

                        console.log("\n座位信息更新成功")
                        console.log("\tseat id: ", $txtSeat.attr("id"))
                        console.log("\tseat owner id: null")
                        console.log("\tseat content: null")
                    })
            } else {
                $.post("${pageContext.request.contextPath}/seat/update",
                    {"id": $txtSeat.attr("id"), "owner.id": currUser.id, "content": $.trim(this.value)},
                    function () {
                        $("#ownerinfo-" + $txtSeat.attr("id")).html(JSON.stringify(currUser));
                        $("#selected-owner").html(currUser.name)
                        $("#selected-content").html($.trim($txtSeat.val()))
                        $txtSeat.css("color", "green").css("font-weight", "bold")

                        var message = {
                            "cmd": "seatupdated",
                            "seat": {
                                "id": $txtSeat.attr("id"),
                                "content": $.trim($txtSeat.val()),
                                "owner": currUser
                            }
                        }
                        ws.send(JSON.stringify(message))

                        console.log("\n座位信息更新成功")
                        console.log("\tseat id: ", $txtSeat.attr("id"))
                        console.log("\tseat owner id: ", currUser.id)
                        console.log("\tseat content: ", $.trim($txtSeat.val()))
                    })
            }

            editingId = null
        })


        function startEditing() {
            var message = {
                "cmd": "seatediting",
                "seat": {
                    "id": editingId,
                    "owner": {
                        "id": currUser.id,
                        "name": currUser.name,
                        "type": currUser.type
                    }
                }
            }
            ws.send(JSON.stringify(message))
        }

    })


</script>
</body>
</html>

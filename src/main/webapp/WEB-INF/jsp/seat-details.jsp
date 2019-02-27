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
                                <input type='text' id='${seat.id}' value="${seat.content}" title="${seat.content}">
                                <span id="ownerinfo-${seat.id}" style="display: none;">
                                    <c:if test="${ empty seat.owner}">null</c:if>
                                    <c:if test="${ not empty seat.owner}">{"id": ${seat.owner.id}, "name": "${seat.owner.name}", "type": "${seat.owner.type}" }</c:if>
                                </span>
                                <span id="status-${seat.id}" style="display: none">${ seat.status }</span>
                            </div>
                        </c:forEach>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="fl" style="margin-left: 20px; width:250px;">
            <h3>座位信息</h3>
            <div id='seat-info' style="font-size: 12px;">
                <p>当前选中的座位上的信息：<span id='selected-content'></span></p>
                <p>当前选中的座位的拥有者：<span id='selected-owner'></span></p>
            </div>
            <form id="seat-status-setting-form" onsubmit="return false;" style="display: none;">
                <p><label for="chkboxStatus">学员资料已提交</label>：<input id="chkboxStatus" type="checkbox"></p>
            </form>
        </div>
        <div class="fc">
        </div>
    </div>

</div>
<script>

    //  "座位状态设置表单"的CSS选择器
    const SEAT_STATUS_SETTING_FORM_CCS_SELECTOR = "#seat-status-setting-form";

    //  "座位状态设置复选框"的CSS选择器
    const SEAT_STATUS_SETTING_CHECKBOX_CCS_SELECTOR = "#seat-status-setting-form :checkbox";

    //  "所有的座位文本框"的CSS选择器
    const SEAT_INPUT_CSS_SELECTOR = ".seat input";

    //  "选中座位上内容"的CSS选择器
    const SELECTED_CONTENT = "#selected-content";

    //  "选中座位的拥有者姓名"的CSS选择器
    const SELECTED_OWNER = "#selected-owner";

    //  当前登录的用户
    var currUser = {id: ${ currUser.id }, name: "${ currUser.name }", type: "${ currUser.type }"};

    //  当前座位表的班级ID
    var currKlassId = ${ klass.id };

    //  当前正在编辑中的座位ID，初始值为null
    var editingId = null;

    //  当前选中的座位ID，初始值为null
    var selectedId = null;

    var alerting = false;

    $(function () {

        var ws = new WebSocket("ws://localhost/websocket");
        window.onbeforeunload = function () {
            ws.close();
        };

        ws.onmessage = function (event) {
            var message = JSON.parse(event.data);
            var  s, $seat;
            if(message.seat) { // 判断是否是和“座位”有关（更新、编辑中、修改状态）的通知
                s = message.seat;
                $seat = $("#" + s.id);
                if($seat.length === 0) { // 如果服务器通知中的“座位”不在当前页面，则忽略此次通知。
                    return;
                }
            }
            if (message.cmd === "klassmodified" && currKlassId === message.id && !alerting) {
                alerting = true;
                alert("班主任刚刚修改了座位表班级信息，关闭对话框后会更新班级座位表");
                window.location = "${pageContext.request.contextPath}/seat/details?kid=" + currKlassId;
            } else if (message.cmd === "klassdeleted" && currKlassId === message.id && !alerting) {
                alerting = true;
                alert("班主任刚刚删除了座位表班级信息，关闭对话框后会返回班级列表");
                window.location = "${pageContext.request.contextPath}/klass/mgr";
            } else if (message.cmd === "seatmodified") { // 当收到服务器推送的其他用户发送的“某个座位已修改”通知时
                /**
                 *  更新该“座位”上的内容、取消“拥有者”样式（粗体、绿字）、设置“座位状态”样式。
                 *  更新该“座位”上隐藏的“拥有者”信息、“状态”信息
                 */
                $seat.val(s.content)
                    .css("color", "black")
                    .css("font-weight", "lighter")
                    .css("background-color", s.status === "已提交资料" ? "yellow" : "white");
                $("#ownerinfo-" + s.id).html(JSON.stringify(s.owner));
                $("#status-" + s.id).html(s.status);
                /**
                 *  如果该“座位”刚好是当前页面“选中”的座位，则需要更新右侧的“选中座位信息栏”，
                 *  注意：如果当前的登录用户是班主任，还要根据“更新后”的“选中座位”的“状态”是否为“空座位”来判定是否要显示或隐藏“状态设置表单”
                 */
                if(s.id === selectedId) {
                    $(SELECTED_CONTENT).html(s.content);
                    $(SELECTED_OWNER).html(s.owner ? s.owner.name : "[无]");
                    if (currUser.type === "班主任") {
                        if (s.status !== "空座位") {
                            $(SEAT_STATUS_SETTING_FORM_CCS_SELECTOR).show();
                        } else {
                            $(SEAT_STATUS_SETTING_FORM_CCS_SELECTOR).hide();
                            $(SEAT_STATUS_SETTING_CHECKBOX_CCS_SELECTOR).prop("checked", false);
                        }
                    }
                }
            } else if (message.cmd === "seatediting") {
                $seat.val("['" + s.owner.name + "'编辑中]");
                $("#ownerinfo-" + s.id).html(JSON.stringify(s.owner))
            }
        };

        /**
         *  当“座位状态设置复选框”被单击时，更新“当前选中座位”的状态、样式，并通知服务器（发送websocket消息）
         */
        $(SEAT_STATUS_SETTING_CHECKBOX_CCS_SELECTOR).on("click", function () {
            var status = this.checked ? "已提交资料" : "未提交资料";
            var content = $.trim($("#" + selectedId).val());
            var owner = JSON.parse($.trim($("#ownerinfo-" + selectedId).html()));
            var url = "${pageContext.request.contextPath}/seat/modify";
            var param = {"id": selectedId, "content": content, "owner.id": owner.id, "status": status };
            $.post(url, param, function () {
                    $("#status-" + selectedId).html(status);
                    if(status === "已提交资料") {
                        $("#" + selectedId).css("background-color", "yellow");
                    } else{
                        $("#" + selectedId).css("background-color", "white");
                    }
                    var message = {
                        "cmd": "seatmodified",
                        "seat": {
                            "id": selectedId,
                            "content": content,
                            "owner": currUser,
                            "status": status
                        }
                    };
                    ws.send(JSON.stringify(message));
                });
        });

        /**
         *  将每一“已提交资料”状态的座位的背景颜色设置为：yellow
         */
        $(".seat span[id^='status-']").each(function () {
            var bgcolor = "white";
            if ($(this).html() === "已提交资料") {
                bgcolor = "yellow";
            }
            $(this).prevAll("input").css("background-color", bgcolor);
        });

        /**
         *  将每一个“拥有者为当前用户”的座位的样式设置成：粗体、绿色
         */
        $(".seat span[id^='ownerinfo-']").each(function () {
            var owner = JSON.parse($.trim($(this).html()));
            if (owner && owner.id === currUser.id) {
                $(this).prevAll("input").css("color", "green").css("font-weight", "bold");
            }
        });


        /**
         *  将所有座位文本框的初始状态设置为只读，手型光标
         */
        $(SEAT_INPUT_CSS_SELECTOR).attr("readonly", true).css("cursor", "pointer");

        /**
         *  “座位文本框”获取焦点时变为“选中座位”：
         *  （1）设置选中状态样式属性：只读、橙色边框、手型光标
         *  （2）页面右侧“座位信息栏”上更新“选中座位”信息：content、owner
         */
        $(SEAT_INPUT_CSS_SELECTOR).on("focus", function () {

            selectedId = window.parseInt($(this).attr("id"));

            // 恢复所有的座位的非选中样式
            $('.seat').css("border-color", "#000000");
            // 设置选中座位样式
            $(this).parent().css("border-color", "orange");
            // 更新选中座位信息：content、owner
            var owner = JSON.parse($.trim($("#ownerinfo-" + selectedId).html()));
            $(SELECTED_OWNER).html(owner ? owner.name : "[无]");
            $(SELECTED_CONTENT).html(this.value);

            if (currUser.type === "班主任") {
                if ($.trim($("#" + selectedId).val()) !== "") {
                    if ($("#status-" + selectedId).html() === "已提交资料") {
                        $(this).css("background-color", "yellow");
                        $(SEAT_STATUS_SETTING_CHECKBOX_CCS_SELECTOR).prop("checked", true);
                    } else {
                        $(this).css("background-color", "white");
                        $(SEAT_STATUS_SETTING_CHECKBOX_CCS_SELECTOR).prop("checked", false);
                    }
                    $(SEAT_STATUS_SETTING_FORM_CCS_SELECTOR).show()
                } else {
                    $(SEAT_STATUS_SETTING_FORM_CCS_SELECTOR).hide();
                    $(SEAT_STATUS_SETTING_CHECKBOX_CCS_SELECTOR).prop("checked", false);
                }
            }
        });

        $(SEAT_INPUT_CSS_SELECTOR).on("keydown", function (event) {
            if (event.keyCode === 116) { // F5键
                return;
            }
            if (event.keyCode === 13) { // 回车键
                $(this).blur();
                return;
            }
            var owner = JSON.parse($.trim($("#ownerinfo-" + $(this).attr("id")).html()));
            if (!owner || owner.id === currUser.id) {
                $(this).attr("readonly", false).css("cursor", "auto");
            } else if (currUser.type === "班主任") {
                if (confirm("该座位上学员不是自己的学员，不能修改！\n但您可以删除该座位学员信息，是否要删除？")) {
                    $(this).val("");
                    editingId = window.parseInt($(this).attr("id"));
                    $(this).blur();
                }
            } else {
                alert("该座位上学员不是自己的学员，不能修改！");
            }
        });

        $(SEAT_INPUT_CSS_SELECTOR).on("input", function () {
            if (!editingId) {
                editingId = window.parseInt(this.id);
                startEditing();
            }
            $(SELECTED_CONTENT).html(this.value);
        });

        $(SEAT_INPUT_CSS_SELECTOR).on("dblclick", function () {
            var owner = JSON.parse($.trim($("#ownerinfo-" + $(this).attr("id")).html()));
            if (!owner || owner.id === currUser.id) {
                $(this).attr("readonly", false).css("cursor", "auto");
                $(this).select();
                if (editingId == null) {
                    editingId = window.parseInt(this.id);
                    startEditing();
                }
            } else if (currUser.type === "班主任") {
                if (confirm("该座位上学员不是自己的学员，不能修改！\n但您可以删除该座位学员信息，是否要删除？")) {
                    editingId = window.parseInt(this.id);
                    $(this).val("");
                    $(this).blur();
                }
            } else {
                alert("该座位上学员不是自己的学员，不能修改！")
            }

        });

        $(SEAT_INPUT_CSS_SELECTOR).on("blur", function () {
            //  “座位”文本框失去焦点时，设置成“非选中”样式：只读、手型指针
            $(this).attr("readonly", true).css("cursor", "pointer");
            //  如果当前失去焦点的座位不是正在编辑的座位，则什么都不做
            //  如果当前失去焦点的座位刚好是正在编辑的座位，则代表编辑完成，需要更新服务器上的座位信息
            if (editingId !== window.parseInt(this.id)) {
                return;
            }
            var $txtSeat = $(this);
            var url = "${pageContext.request.contextPath}/seat/modify";
            var id = window.parseInt($txtSeat.attr("id"));
            var content;
            var status;
            var param;
            if ($.trim($txtSeat.val()) === "") { // 删除座位上的内容时
                content = null;
                status = "空座位";
                param = {"id": id, "status": status};
                $.post(url, param, function () {

                        //  服务器座位信息更新为“空座位”后，设置该座位的拥有者信息为null
                        $txtSeat.css("color", "black").css("font-weight", "lighter").css("background-color", "white");
                        $("#ownerinfo-" + id).html("null");
                        $("#status-" + id).html("空座位");
                        if(selectedId == id) {
                            $(SELECTED_OWNER).html("[无]");
                            $(SELECTED_CONTENT).html(content);
                            $(SEAT_STATUS_SETTING_FORM_CCS_SELECTOR).hide();
                            $(SEAT_STATUS_SETTING_CHECKBOX_CCS_SELECTOR).prop("checked", false);
                        }
                        //  服务器座位信息更新为“空座位”后，通过websocket，通知所有的其它客户端
                        var message = {
                            "cmd": "seatmodified",
                            "seat": {
                                "id": id,
                                "content": null,
                                "owner": null,
                                "status": status
                            }
                        };
                        ws.send(JSON.stringify(message));
                    })
            } else {
                content = $.trim($txtSeat.val());
                status = $("#status-" + id).html();
                if(status === "空座位") {
                    status = "未提交资料";
                }
                param = {"id": id, "owner.id": currUser.id, "content": content, "status": status };
                $.post(url, param, function () {
                    $txtSeat.css("color", "green").css("font-weight", "bold");
                    $("#ownerinfo-" + id).html(JSON.stringify(currUser));
                    $("#status-" + id).html(status);
                    if(selectedId == id) {
                        $(SELECTED_OWNER).html(currUser.name);
                        $(SELECTED_CONTENT).html(content);
                        if(currUser.type === "班主任") {
                            $(SEAT_STATUS_SETTING_FORM_CCS_SELECTOR).show();
                        }
                    }
                    var message = {
                        "cmd": "seatmodified",
                        "seat": {
                            "id": id,
                            "content": content,
                            "owner": currUser,
                            "status": status
                        }
                    };
                    ws.send(JSON.stringify(message));
                })
            }

            editingId = null;
        });


        function startEditing() {
            var message = {
                "cmd": "seatediting",
                "seat": {"id": editingId, "owner": currUser}
            };
            ws.send(JSON.stringify(message));
        }

    })
</script>
</body>
</html>

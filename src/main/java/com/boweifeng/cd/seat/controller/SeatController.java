package com.boweifeng.cd.seat.controller;

import com.boweifeng.cd.seat.entity.Seat;
import com.boweifeng.cd.seat.entity.User;
import com.boweifeng.cd.seat.service.KlassService;
import com.boweifeng.cd.seat.service.SeatService;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@SuppressWarnings("unchecked")
@Controller
@RequestMapping("/seat")
public class SeatController {

    private static final Logger logger = LogManager.getLogger();

    @Autowired
    private SeatService seatService;
    @Autowired
    private KlassService klassService;

    @RequestMapping("/details")
    public String details(Map<String, Object> model, int kid) {
        model.put("klass", klassService.getKlassById(kid));
        model.put("seats", seatService.getSeatsByKlass(kid));
        return "seat-details";
    }

    @ResponseBody
    @RequestMapping("/modify")
    public void modify(Seat seat, HttpServletRequest request) {
        Seat oldSeat = seatService.getSeatById(seat.getId());
        seatService.modify(seat);
        Seat newSeat = seatService.getSeatById(seat.getId());
        User currUser = (User)request.getSession().getAttribute("currUser");
        String log = "\r\n\t用户[" + currUser.getLoginId() +  "-" + currUser.getName() + "-" + currUser.getType() + "]编辑了座位信息";
        log += "\r\n\t编辑前的座位信息：[录入者:" + (oldSeat.getOwner() != null ? oldSeat.getOwner().getName() : "null") + "][班级：" + oldSeat.getKlass().getName() + "][第" + oldSeat.getRow() + "排第" + oldSeat.getColumn() + "列][座位信息：" + oldSeat.getContent() + "][座位状态：" + oldSeat.getStatus() + "]";
        log += "\r\n\t编辑后的座位信息：[录入者:" + (newSeat.getOwner() != null ? newSeat.getOwner().getName() : "null") + "][班级：" + newSeat.getKlass().getName() + "][第" + newSeat.getRow() + "排第" + newSeat.getColumn() + "列][座位信息：" + newSeat.getContent() + "][座位状态：" + newSeat.getStatus() + "]";
        logger.info(log + "\n");
    }

    /*
    @ResponseBody
    @RequestMapping("/editingStart")
    public void editingStart(HttpServletRequest request, Seat editingSeat) {
        Map<Integer, Seat> editingSeatMap = (Map<Integer, Seat>) request.getServletContext().getAttribute("editingSeatMap");
        editingSeatMap.put(editingSeat.getId(), editingSeat);
    }

    @ResponseBody
    @RequestMapping("/editingEnd")
    public void editingEnd(HttpServletRequest request, Seat editingSeat) {
        Map<Integer, Seat> editingSeatMap = (Map<Integer, Seat>) request.getServletContext().getAttribute("editingSeatMap");
        editingSeatMap.remove(editingSeat.getId());
    }


    @ResponseBody
    @RequestMapping("/getEditingSeatList")
    public List<Seat> getEditingSeatList(HttpServletRequest request, int kid) {
        Map<Integer, Seat> editingSeatMap = (Map<Integer, Seat>) request.getServletContext().getAttribute("editingSeatMap");
        List<List<Seat>> seats = seatService.getSeatsByKlass(kid);
        List<Seat> editingSeatList = new ArrayList<>();
        for(List<Seat> seatsOfColumn : seats) {
           for (Seat seat : seatsOfColumn) {
               if(editingSeatMap.containsKey(seat.getId())) {
                   editingSeatList.add(editingSeatMap.get(seat.getId()));
               }
           }
        }
        return editingSeatList;
    }
    */
}

package com.boweifeng.cd.seat.controller;

import com.boweifeng.cd.seat.entity.Seat;
import com.boweifeng.cd.seat.service.SeatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/seat")
public class SeatController {

    @Autowired
    private SeatService seatService;

    @RequestMapping("/details")
    public String details(Map<String, Object> model, int kid) {
        model.put("seats", seatService.getSeatsByKlass(kid));
        return "seat-details";
    }

}

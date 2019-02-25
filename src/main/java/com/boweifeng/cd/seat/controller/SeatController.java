package com.boweifeng.cd.seat.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/seat")
public class SeatController {

    @RequestMapping("/details")
    public String details(int kid) {
        System.out.println("kid = " + kid);
        return "seat-details";
    }

}

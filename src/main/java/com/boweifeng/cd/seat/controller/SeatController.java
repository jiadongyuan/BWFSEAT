package com.boweifeng.cd.seat.controller;

import com.boweifeng.cd.seat.entity.Seat;
import com.boweifeng.cd.seat.service.KlassService;
import com.boweifeng.cd.seat.service.SeatService;
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
    public void modify(Seat seat) {
        seatService.modify(seat);
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

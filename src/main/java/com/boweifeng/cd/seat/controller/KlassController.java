package com.boweifeng.cd.seat.controller;

import com.boweifeng.cd.seat.entity.Klass;
import com.boweifeng.cd.seat.service.KlassService;
import com.boweifeng.cd.seat.service.UserService;
import com.boweifeng.cd.seat.websocket.SeatHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/klass")
public class KlassController {

    @Autowired
    private KlassService klassService;
    @Autowired
    private UserService userService;

    @RequestMapping("/mgr")
    public String mgr(Map<String, Object> model) {
        List<Klass> allKlasses = klassService.getAllKlasses();
        model.put("masters", userService.getMasters());
        model.put("allKlasses", allKlasses);
        model.put("recommendedNewKlass", klassService.getRecommendedKlass(allKlasses));
        return "klass-mgr";
    }

    @RequestMapping("/create")
    public String create(Map<String, Object> model, Klass klass) {
        String msg = "班级座位表创建失败：班级已经存在！";
        if(klassService.create(klass)) {
            msg = "班级座位表创建成功！";
        }
        model.put("tipCreateKlass", msg);
        return "forward:/klass/mgr";
    }

    @RequestMapping("/delete")
    public String delete(int kid) throws IOException {
        klassService.delete(kid);
        SeatHandler.sendMessagesToAllClient("{\"cmd\": \"klassdeleted\", \"id\": " + kid + "}");
        return "redirect:/klass/mgr";
    }

    @RequestMapping("/edit")
    @ResponseBody
    public Klass edit(int kid) {
        return klassService.getKlassById(kid);
    }

    @RequestMapping("/modify")
    @ResponseBody
    public boolean modify(Klass klass, int oldSeatCount) throws IOException {
        boolean modifyResult = klassService.modify(klass, oldSeatCount);
        if(modifyResult) {
            SeatHandler.sendMessagesToAllClient("{\"cmd\": \"klassmodified\", \"id\": " + klass.getId() + "}");
        }
        return modifyResult;
    }
}

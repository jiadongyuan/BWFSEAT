package com.boweifeng.cd.seat.controller;

import com.boweifeng.cd.seat.entity.User;
import com.boweifeng.cd.seat.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
@RequestMapping({"/user", "/"})
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/")
    public String loginForm() {
        return "user-login";
    }

    @RequestMapping("/loginCheck")
    public String loginCheck(Map<String, Object> model, String loginId, String loginPsw, HttpSession session) {
        User user = userService.loginCheck(loginId, loginPsw);
        if(user != null && user.getStatus().equals("已停用") ) {
            model.put("tip", "登录失败：该账号已经停用！");
            return "forward:/";
        } else if(user == null) {
            model.put("tip", "登录失败：账号或者密码错误！");
            return "forward:/";
        } else {
            session.setAttribute("currUser", user);
            if(user.getType().equals("管理员")) {
                return "redirect:/user/mgr";
            } else {
                return "redirect:/klass/mgr";
            }
        }
    }

    @RequestMapping("/user/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    @RequestMapping("/home")
    public String home() {
        return "user-home";
    }

    @ResponseBody
    @RequestMapping("/checkOldPsw")
    public boolean checkOldPsw(HttpSession session, String oldPsw) {
        return ((User)session.getAttribute("currUser")).getLoginPsw().equals(oldPsw);
    }

    @RequestMapping("/modifyPsw")
    public String modifyPsw(Map<String, Object> model, String oldPsw, String newPsw, String newPsw2, HttpSession session) {
        User currUser = (User) session.getAttribute("currUser");
        if(!currUser.getLoginPsw().equals(oldPsw)) {
            model.put("tipModifyPsw", "旧密码不正确");
        } else if(!newPsw.equals(newPsw2)) {
            model.put("tipModifyPsw", "两次密码不一致");
        } else {
            userService.modifyPsw(currUser.getId(), newPsw);
            currUser.setLoginPsw(newPsw);
            model.put("tipModifyPsw", "密码修改成功");
        }
        return "forward:/user/home";
    }

    @RequestMapping("/mgr")
    public String mgr(Map<String, Object> model) {
        model.put("allUsers", userService.getAllUsers());
        return "user-mgr";
    }

    @RequestMapping("/create")
    public String create(Map<String, Object> model, User user) {
        String tipCreateUser = "创建新用户失败：账号已经存在，请重新输入账号";
        if(userService.create(user)) {
            tipCreateUser = "创建新用户成功！";
        }
        model.put("tipCreateUser", tipCreateUser);
        return "forward:/user/mgr";
    }

    @RequestMapping("/changeStatus")
    public String changeStatus(User user) {
        userService.modify(user);
        return "redirect:/user/mgr";
    }

    @RequestMapping("/modify")
    @ResponseBody
    public void modify(User user) {
        userService.modify(user);
    }
}

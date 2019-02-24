package com.boweifeng.cd.seat.interceptor;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AuthorityInterceptor extends HandlerInterceptorAdapter {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if(request.getSession().getAttribute("currUser") != null) {
            return true;
        } else {
            request.setAttribute("tip", "请先登录再进行其他操作");
            request.getRequestDispatcher("/").forward(request, response);
            return false;
        }
    }
}

package com.boweifeng.cd.seat.service;

import com.boweifeng.cd.seat.entity.User;

import java.util.List;

public interface UserService {
    User loginCheck(String loginId, String loginPsw);

    void modifyPsw(int id, String newPsw);

    List<User> getMasters();

    List<User> getAllUsers();

    void modify(User user);

    boolean create(User user);
}

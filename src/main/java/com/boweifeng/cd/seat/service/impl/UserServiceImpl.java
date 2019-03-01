package com.boweifeng.cd.seat.service.impl;

import com.boweifeng.cd.seat.entity.User;
import com.boweifeng.cd.seat.mapper.UserMapper;
import com.boweifeng.cd.seat.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService{

    @SuppressWarnings("SpringJavaAutowiringInspection")
    @Autowired
    private UserMapper userMapper;

    @Override
    public User loginCheck(String loginId, String loginPsw) {
        User user = userMapper.getUserByLoginId(loginId);
        if(user != null && user.getLoginPsw().equals(loginPsw)) {
            return user;
        }
        return null;
    }

    @Override
    public void modifyPsw(int id, String newPsw) {
        User user = new User();
        user.setId(id);
        user.setLoginPsw(newPsw);
        userMapper.update(user);
    }

    @Override
    public List<User> getMasters() {
        return userMapper.getUsersByType("班主任");
    }

    @Override
    public List<User> getAllUsers() {
        return userMapper.getAllUsers();
    }

    @Override
    public void modify(User user) {
        userMapper.update(user);
    }

    @Override
    public boolean create(User user) {
        if(userMapper.getUserByLoginId(user.getLoginId()) != null) {
            return false;
        }
        userMapper.add(user);
        return true;
    }
}

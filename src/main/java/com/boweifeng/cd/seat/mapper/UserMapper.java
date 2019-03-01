package com.boweifeng.cd.seat.mapper;

import com.boweifeng.cd.seat.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {

    User getUserByLoginId(@Param("loginId") String loginId);

    void update(@Param("user") User user);

    List<User> getUsersByType(@Param("type") String type);

    List<User> getAllUsers();

    void add(@Param("user") User user);
}

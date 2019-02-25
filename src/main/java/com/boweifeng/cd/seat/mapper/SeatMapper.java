package com.boweifeng.cd.seat.mapper;

import com.boweifeng.cd.seat.entity.Seat;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SeatMapper {
    int add(@Param("seats") List<Seat> seats);

    List<Seat> getSeatsByKlass(@Param("kid") int kid);
}

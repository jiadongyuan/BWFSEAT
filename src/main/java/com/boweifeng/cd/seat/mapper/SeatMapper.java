package com.boweifeng.cd.seat.mapper;

import com.boweifeng.cd.seat.entity.Seat;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SeatMapper {
    int add(@Param("seats") List<Seat> seats);

    List<Seat> getSeatsByKlass(@Param("kid") int kid);

    void deleteByKlass(@Param("kid") int kid);

    void deleteSeatsByKlassGreatThan(@Param("kid") int kid, @Param("seatCount") int seatCount);

    void update(@Param("seat") Seat seat);

    Seat getSeatById(int id);
}

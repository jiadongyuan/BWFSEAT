package com.boweifeng.cd.seat.service;

import com.boweifeng.cd.seat.entity.Seat;

import java.util.List;

public interface SeatService {
    List<List<Seat>> getSeatsByKlass(int kid);

    void modify(Seat seat);

    Seat getSeatById(int id);
}

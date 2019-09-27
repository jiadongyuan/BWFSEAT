package com.boweifeng.cd.seat.service.impl;

import com.boweifeng.cd.seat.entity.Seat;
import com.boweifeng.cd.seat.mapper.SeatMapper;
import com.boweifeng.cd.seat.service.SeatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class SeatServiceImpl implements SeatService {

    @SuppressWarnings("SpringJavaAutowiringInspection")
    @Autowired
    private SeatMapper seatMapper;

    @Override
    public Seat getSeatById(int id) {
        return seatMapper.getSeatById(id);
    }

    @Override
    public List<List<Seat>> getSeatsByKlass(int kid) {
        List<Seat> seatsAll = seatMapper.getSeatsByKlass(kid);
        List<List<Seat>> seats = new ArrayList<>();
        for(Seat seat : seatsAll) {
            List<Seat> seatsColumn = existsColumn(seats, seat.getColumn());
            if(seatsColumn == null) {
                seatsColumn = new ArrayList<>();
                seats.add(seatsColumn);
            }
            seatsColumn.add(seat);
        }
        return seats;
    }

    @Override
    public void modify(Seat seat) {
        seatMapper.update(seat);
    }

    private List<Seat> existsColumn(List<List<Seat>> seats, int column) {
        for(List<Seat> seatsColumn : seats) {
            if(seatsColumn.size() > 0 && seatsColumn.get(0).getColumn() == column) {
                return seatsColumn;
            }
        }
        return null;
    }
}

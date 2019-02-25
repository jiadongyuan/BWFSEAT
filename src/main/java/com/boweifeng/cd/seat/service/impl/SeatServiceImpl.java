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

    @Autowired
    private SeatMapper seatMapper;

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
            System.out.println("seat: id=" + seat.getId() + ", content=" + seat.getContent() + ", row=" +seat.getRow() + ", column=" + seat.getColumn() + ", status=" + seat.getStatus()
                + ", owner[" + (seat.getOwner() == null ? "null" : ("id=" + seat.getOwner().getId() + ", name=" + seat.getOwner().getName() + ", type=" + seat.getOwner().getType()))  +  "]"
                + ", klass[" + (seat.getKlass() == null ? "null" : ("id=" + seat.getKlass().getId() + ", name=" + seat.getKlass().getName())) + "]");
        }
        for(List<Seat> seatsColumn : seats) {
            for(Seat seat : seatsColumn) {
                System.out.println("第" + seat.getColumn() + "列第" + seat.getRow() + "排：" + "seat: id=" + seat.getId() + ", content=" + seat.getContent() + ", row=" +seat.getRow() + ", column=" + seat.getColumn() + ", status=" + seat.getStatus()
                        + ", owner[" + (seat.getOwner() == null ? "null" : ("id=" + seat.getOwner().getId() + ", name=" + seat.getOwner().getName() + ", type=" + seat.getOwner().getType()))  +  "]"
                        + ", klass[" + (seat.getKlass() == null ? "null" : ("id=" + seat.getKlass().getId() + ", name=" + seat.getKlass().getName())) + "]") ;
            }
        }
        return seats;
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

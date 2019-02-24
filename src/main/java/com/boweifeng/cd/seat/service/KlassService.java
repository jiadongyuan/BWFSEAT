package com.boweifeng.cd.seat.service;

import com.boweifeng.cd.seat.entity.Klass;

import java.util.List;

public interface KlassService {
    List<Klass> getAllKlasses();

    boolean create(Klass klass);

    Klass getRecommendedKlass(List<Klass> allKlasses);

    void delete(int kid);

    Klass getKlassById(int kid);

    boolean modify(Klass klass);
}

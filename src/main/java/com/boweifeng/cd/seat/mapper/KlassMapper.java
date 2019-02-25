package com.boweifeng.cd.seat.mapper;

import com.boweifeng.cd.seat.entity.Klass;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface KlassMapper {
    List<Klass> getKlasses();

    void add(@Param("klass") Klass klass);

    Klass getKlassByName(@Param("name") String name);

    void delete(@Param("id") int id);

    Klass getKlassById(@Param("id") int id);

    boolean update(@Param("klass") Klass klass);

    int getMaxId();
}

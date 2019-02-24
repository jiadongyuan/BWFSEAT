package com.boweifeng.cd.seat.service.impl;

import com.boweifeng.cd.seat.entity.Klass;
import com.boweifeng.cd.seat.mapper.KlassMapper;
import com.boweifeng.cd.seat.service.KlassService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class KlassServiceImpl implements KlassService {

    @SuppressWarnings("SpringJavaAutowiringInspection")
    @Autowired
    private KlassMapper klassMapper;

    @Override
    public List<Klass> getAllKlasses() {
        return klassMapper.getKlasses();
    }

    @Override
    public boolean create(Klass klass) {
        if(klassMapper.getKlassByName(klass.getName()) != null) {
            return false;
        }
        klassMapper.add(klass);
        return true;
    }

    @Override
    public Klass getRecommendedKlass(List<Klass> allKlasses) {
        Klass recommendedKlass = new Klass();
        recommendedKlass.setSeatCount(42);
        if(allKlasses != null && allKlasses.size() > 0) {
            String lastedKlassName = allKlasses.get(0).getName();
            try {
                int lastedKlassNumber = Integer.parseInt(lastedKlassName.substring(0, lastedKlassName.length() - 1));
                recommendedKlass.setName((lastedKlassNumber + 1) + "期");
            } catch(Exception ex) {
                recommendedKlass.setName("");
            }
        }
        return recommendedKlass;
    }

    @Override
    public void delete(int kid) {
        klassMapper.delete(kid);
    }

    @Override
    public Klass getKlassById(int kid) {
        return klassMapper.getKlassById(kid);
    }

    @Override
    public boolean modify(Klass klass) {
        if(!klassMapper.getKlassById(klass.getId()).getName().equals(klass.getName())
                && klassMapper.getKlassByName(klass.getName()) != null) {
            return false;
        }
        klassMapper.update(klass);
        return true;
    }
}

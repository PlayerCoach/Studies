package org.example;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Optional;

public class MageController {
    private final MageRepository mageRepository;
    private final MageDTOMapper mageDTOMapper;

    public MageController(MageRepository mageRepository, MageDTOMapper mageDTOMapper) {
        this.mageRepository = mageRepository;
        this.mageDTOMapper = mageDTOMapper;
    }

    public String findMageByName(String name) {

        Optional<Mage> mageOptional = mageRepository.findMageByName(name);
        if(mageOptional.isEmpty()) {
               return "not found";
        }
        Mage mage = mageOptional.orElseThrow(() -> new IllegalStateException("Mage not found"));

        MageDTO mageDTO = mageDTOMapper.apply(mage);
        return mageDTO.toString();

    }

    public String deleteMageByName(String name) {
        try {
            mageRepository.deleteMageByName(name);
            return "done";
        } catch (IllegalArgumentException e) {
            return "not found";
        }
    }

    public String addNewMage(MageDTO mageDTO) {
        try {
            Mage mage = new Mage(mageDTO.name(), mageDTO.level());
            mageRepository.addNewMage(mage);
            return "done";
        } catch (IllegalArgumentException e) {
            return "bad request";
        }
    }

    public String getMages() {
        Collection<MageDTO> mageDTOs = new ArrayList<>();
        for (Mage mage : mageRepository.getMages()) {
            mageDTOs.add(mageDTOMapper.apply(mage));
        }
        return mageDTOs.toString();
    }
}

package org.example;

import java.util.function.Function;


public class MageDTOMapper implements Function<Mage, MageDTO> {
    @Override
    public MageDTO apply(Mage mage) {
        return new MageDTO(mage.getName(), mage.getLevel());
    }
}

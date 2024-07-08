package org.example;

import java.util.*;

public class MageRepository {


    private final Collection<Mage> mages = new ArrayList<>();



    public Optional<Mage> findMageByName(String name) {
        return mages.stream()
            .filter(mage -> mage.getName().equals(name))
            .findFirst();

    }

    public void deleteMageByName(String name) {
        if (!mages.removeIf(mage -> mage.getName().equals(name))) {
            throw new IllegalArgumentException("Mage not found");
        }
    }

    public void addNewMage(Mage mage) {
        mages.stream()
            .filter(m -> m.getName().equals(mage.getName()))
            .findAny()
            .ifPresent(m -> {
                throw new IllegalArgumentException("Mage already exists");
            });
        mages.add(mage);
    }

    public Collection<Mage> getMages() {
        return mages;
    }

}

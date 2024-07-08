package org.example;
import java.util.HashSet;
import java.util.Set;
import java.util.TreeSet;

public class MageFactory {
    public static Set<Mage> StartFactory(String mode, Set<Mage> mageSet)
    {
        switch (mode) {
            case Const.NATURAL -> mageSet = new TreeSet<>();
            case Const.ALT -> mageSet = new TreeSet<>(new Mage.AltMageComparator());
            case Const.NONE -> mageSet = new HashSet<>();
        }
        Mage merlin = new Mage("Merlin", 5, 80.5, mode);
        mageSet.add(merlin);
        Mage gandalf = new Mage("Gandalf", 7, 95.2, mode);
        mageSet.add(gandalf);
        Mage dumbledore = new Mage("Dumbledore", 6, 90.0, mode);
        mageSet.add(dumbledore);
        Mage saruman = new Mage("Saruman", 4, 85.0, mode);
        mageSet.add(saruman);
        Mage radagast = new Mage("Radagast", 3, 75.0, mode);
        mageSet.add(radagast);
        Mage morgana = new Mage("Morgana", 8, 92.0, mode);
        mageSet.add(morgana);
        Mage albus = new Mage("Albus", 5, 88.0, mode);
        mageSet.add(albus);
        Mage medivh = new Mage("Medivh", 6, 87.5, mode);
        mageSet.add(medivh);
        Mage sylvanus = new Mage("Sylvanus", 4, 78.0, mode);
        mageSet.add(sylvanus);
        Mage rhonin = new Mage("Rhonin", 7, 93.0, mode);
        mageSet.add(rhonin);


        merlin.setApprentices(saruman);
        merlin.setApprentices(gandalf);
        merlin.setApprentices(rhonin);
        gandalf.setApprentices(dumbledore);
        dumbledore.setApprentices(morgana);
        gandalf.setApprentices(medivh);
        albus.setApprentices(merlin);
        albus.setApprentices(sylvanus);




        return mageSet;
    }



}

package org.example;
import java.util.Map;
import java.util.Set;


public class Main {

    public static void main(String[] args)
    {
        Set<Mage> mageSet = null;
        Map<Mage, Integer> descendantStatistics;

        switch (args[0]) {
            case Const.ALT -> mageSet = MageFactory.StartFactory(Const.ALT, mageSet);
            case Const.NATURAL -> mageSet =  MageFactory.StartFactory(Const.NATURAL, mageSet);
            case Const.NONE -> mageSet =  MageFactory.StartFactory(Const.NONE, mageSet);
        }

        descendantStatistics = Mage.create_statistic_map(mageSet, args[0]);
        assert mageSet != null;
        for (Mage mage : mageSet)
        {
            mage.print();

        }
        System.out.println("Descendant Statistics:");
        for (Mage mage : descendantStatistics.keySet())
        {
            System.out.println(mage + " has " + descendantStatistics.get(mage) + " descendants");

        }

    }
}

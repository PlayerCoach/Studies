package org.example;

import java.util.*;



public class Mage  implements Comparable<Mage>
{

    private final String  name;
    private final  int  level;
    private final double power;
    private Set<Mage> apprentices = null ;

    public Mage(String name, int level, double power, String mode)
    {
        this.name = name;
        this.level = level;
        this.power = power;
        switch (mode) {
            case Const.NATURAL -> apprentices = new TreeSet<>();
            case Const.ALT -> apprentices = new TreeSet<>(new AltMageComparator());
            case Const.NONE -> apprentices = new HashSet<>();
        }

    }
    void setApprentices(Mage apprentices)
    {
        if (!this.equals(apprentices))
        {
            this.apprentices.add(apprentices);
        }
    }


    @Override
    public boolean equals(Object object)
    {
        if (this == object) return true;
        if (object == null || getClass() != object.getClass()) return false;
        else
        {
            Mage mage = (Mage) object;
            return this.name.equals(mage.name) && this.level == mage.level && this.power == mage.power;
        }

    }
    @Override
    public int hashCode()
    {
        return Objects.hash(name, level, power);
    }

    @Override
    public int compareTo(Mage otherMage) {
        int result = Objects.compare(this.name, otherMage.name, Comparator.naturalOrder());
        if (result == 0) {
            result = Integer.compare(this.level, otherMage.level);
            if (result == 0) {
                result = Double.compare(this.power, otherMage.power);
            }
        }
        return result;
    }
    @Override
    public String toString()
    {
        return "Mage{name= " + this.name +", level= " + this.level + ", power= " + this.power + "}";
    }
    public void print() {
        printRecursive(this, 0);
    }

    private void printRecursive(Mage mage, int indentLevel) {
        StringBuilder indent = new StringBuilder();
        for (int i = 0; i < indentLevel; i++) {
            indent.append("-");
        }
        System.out.println(indent + " " + mage);

        if (mage.apprentices != null) {
            for (Mage apprentice : mage.apprentices) {
                printRecursive(apprentice, indentLevel + 1);
            }
        }
    }
    public static Map<Mage, Integer> create_statistic_map(Set<Mage> mageSet, String mode) {
        Map<Mage, Integer> descendantStatistics = switch (mode) {
            case Const.NONE -> new HashMap<>();
            case Const.NATURAL -> new TreeMap<>();
            case Const.ALT -> new TreeMap<>(new AltMageComparator());
            default -> throw new IllegalArgumentException("Invalid mode: " + mode);
        };
        for (Mage mage : mageSet)
        {
            descendantStatistics.put(mage, mage.countDescendants());
        }

        return descendantStatistics;
    }
    public int countDescendants() {
        int count = 0;
        if (apprentices != null) {
            for (Mage apprentice : apprentices) {
                count += apprentice.countDescendants() + 1;
            }
        }
        return count;
    }




    public static class AltMageComparator implements Comparator<Mage>
    {
        @Override
        public int compare(Mage mage1, Mage mage2)
        {
            int  result = Integer.compare(mage1.level, mage2.level);
            if (result == 0)
            {
                result = Objects.compare(mage1.name, mage2.name, Comparator.naturalOrder());
                if (result == 0)
                {
                    result = Double.compare(mage1.power, mage2.power);
                }
            }
            return result;
        }
    }

}

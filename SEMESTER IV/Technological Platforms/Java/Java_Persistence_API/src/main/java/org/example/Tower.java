package org.example;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Entity
public class Tower
{
    @Id
    private String name;
    private int height;
    @OneToMany(cascade = {CascadeType.ALL, CascadeType.REMOVE}, mappedBy = "tower")
    private final List<Mage> mages = new ArrayList<>();

    public Collection<Mage> getMages() {
        return mages;
    }

    public Tower(String name, int height)
    {
        this.name = name;
        this.height = height;
    }

    public Tower() {}

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public int getHeight()
    {
        return height;
    }

    public void setHeight(int height)
    {
        this.height = height;
    }

    public void insertMage(Mage mage)
    {
        mages.add(mage);
    }

    public void removeMage(Mage mage)
    {
        mages.remove(mage);
    }

    public List<Mage> getMagesList()
    {
        return mages;
    }

    @Override
    public String toString()
    {
        return "Tower -> { " +
                "name = '" + name + '\'' +
                ", height = " + height +
                " mages = " + mages +
                " }";
    }

}

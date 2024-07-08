package org.example;

import org.jetbrains.annotations.NotNull;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity
public class Mage
{
    @Id
    private String name;
    private int level;
    @ManyToOne
    private Tower tower;

    public Mage() {}

    public Mage(String name, int level, @NotNull Tower tower)
    {
        this.name = name;
        this.level = level;
        this.tower = tower;
        tower.getMagesList().add(this);
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public int getLevel()
    {
        return level;
    }

    public void setLevel(int level)
    {
        this.level = level;
    }

    public Tower getTower()
    {
        return tower;
    }

    public void setTower(Tower newTower)
    {
        if (tower != null)
        {
            tower.getMagesList().remove(this);
        }
        tower = newTower;
        tower.getMagesList().add(this);
    }

    @Override
    public String toString()
    {
        return "Mage -> { " +
                "name = '" + name + '\'' +
                ", level = " + level +
                ", tower = " + tower.getName() +
                " }";
    }
}

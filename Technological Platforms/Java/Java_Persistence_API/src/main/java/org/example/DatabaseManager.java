package org.example;
import javax.persistence.Persistence;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;

public class DatabaseManager
{
    private static EntityManagerFactory entityManagerFactory;
    private static EntityManager entityManager;



  public DatabaseManager()
   {
       entityManagerFactory = Persistence.createEntityManagerFactory("my-persistence-unit");
       entityManager = entityManagerFactory.createEntityManager();
   }

    public EntityManager getEntityManager()
    {
         return entityManager;
    }

    public void addMage(Mage mage)
    {

        entityManager.getTransaction().begin();
        entityManager.persist(mage);
        entityManager.getTransaction().commit();
        System.out.println("Mage added" + mage);
        System.out.println("Connected to the tower: " + mage.getTower());
    }

    public void addTower(Tower tower)
    {
        entityManager.getTransaction().begin();
        entityManager.persist(tower);
        entityManager.getTransaction().commit();
        System.out.println("Tower added" + tower);
    }

    public void removeMage(Mage mage)
    {
        mage.getTower().removeMage(mage);
        entityManager.getTransaction().begin();
        entityManager.remove(mage);
        entityManager.getTransaction().commit();
        System.out.println("Mage removed => " + mage);
        System.out.println("State of database after removal: ");
        printAll();
    }

    public void removeTower(Tower tower)
    {
        entityManager.getTransaction().begin();
        entityManager.remove(tower);
        entityManager.getTransaction().commit();
        System.out.println("Tower removed" + tower);
        System.out.println("State of database after removal: ");
        printAll();
    }

    public Tower getTower(String name)
    {
        return entityManager.find(Tower.class, name);
    }

    public void printAll()
    {
        if(entityManager.createQuery("SELECT t FROM Tower t", Tower.class).getResultList().isEmpty() && entityManager.createQuery("SELECT m FROM Mage m", Mage.class).getResultList().isEmpty())
        {
            System.out.println("Database is empty");
            return;
        }
        entityManager.createQuery("SELECT t FROM Tower t", Tower.class).getResultList().forEach(System.out::println);
        entityManager.createQuery("SELECT m FROM Mage m", Mage.class).getResultList().forEach(System.out::println);
    }

    public void getMagesWithLevelAbove(int level)
    {
        if(entityManager.createQuery("SELECT m FROM Mage m WHERE m.level > :level", Mage.class).setParameter("level", level).getResultList().isEmpty())
        {
            System.out.println("No mages with level above " + level);
            return;
        }
        entityManager.createQuery("SELECT m FROM Mage m WHERE m.level > :level", Mage.class).setParameter("level", level).getResultList().forEach(System.out::println);
    }

    public void getTowersWithHeightBelow(int height)
    {
        if(entityManager.createQuery("SELECT t FROM Tower t WHERE t.height < :height", Tower.class).setParameter("height", height).getResultList().isEmpty())
        {
            System.out.println("No towers with height below " + height);
            return;
        }
        entityManager.createQuery("SELECT t FROM Tower t WHERE t.height < :height", Tower.class).setParameter("height", height).getResultList().forEach(System.out::println);
    }

    public void getMagesFromTower(String name, int level)
    {
        if(entityManager.createQuery("SELECT m FROM Mage m WHERE m.tower.name = :name AND m.level > :level", Mage.class).setParameter("name", name).setParameter("level", level).getResultList().isEmpty())
        {
            System.out.println("No mages from tower " + name + " with level above  " + level);
            return;
        }
        entityManager.createQuery("SELECT m FROM Mage m WHERE m.tower.name = :name AND m.level > :level", Mage.class).setParameter("name", name).setParameter("level", level).getResultList().forEach(System.out::println);
    }

    public void close()
    {
        entityManager.close();
        entityManagerFactory.close();
    }

}

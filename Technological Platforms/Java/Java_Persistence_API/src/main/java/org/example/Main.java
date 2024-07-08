package org.example;

import javax.persistence.EntityManager;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {

        DatabaseManager databaseManager = new DatabaseManager();
        //  EntityManager entityManager = databaseManager.getEntityManager();  ====> For debugging purposes

        // Placeholder data
        addPlaceholderData(databaseManager);
        // Clear console T_T
        for (int i = 0; i < 4; i++)
        {
            System.out.println();
        }
        System.out.println("State of database at the start:");
        databaseManager.printAll();
        System.out.println("Commands: addMage, addTower, removeMage, removeTower, printAll, exit");
        System.out.println("Additional commands:");
        System.out.println("GMWLA - Get Mages With Level Above \nGTWHB - Get Towers With Height Below \nGMFT - Get Mages From Tower");
        Scanner scanner = new Scanner(System.in);
        label:
        while(scanner.hasNext())
        {
            String command = scanner.next();
            switch (command) {
                case "addMage": {
                    addMage(scanner, databaseManager);
                    break;
                }
                case "addTower": {
                    addTower(scanner, databaseManager);
                    break;
                }
                case "removeMage": {
                    removeMage(scanner, databaseManager);
                    break;
                }
                case "removeTower": {
                    removeTower(scanner, databaseManager);
                    break;
                }
                case "printAll":
                    databaseManager.printAll();
                    break;
                case "exit":
                    break label;
                case "GMWLA":
                    getMagesWithLevelAbove(scanner, databaseManager);
                    break;
                case "GTWHB":
                    getTowersWithHeightBelow(scanner, databaseManager);
                    break;
                case "GMFT":
                    getMagesFromTower(scanner, databaseManager);
                    break;
                default:
                    System.out.println("Invalid command => TRY AGAIN");
                    break;
            }
        }

        scanner.close();
        databaseManager.close();
    }
    public static void addMage(Scanner scanner, DatabaseManager databaseManager) {
        String name = scanner.next();
        int level;
        try
        {
            level = scanner.nextInt();
        }
        catch (Exception e)
        {
            System.out.println("Invalid input => TRY AGAIN");
            return;
        }

        String towerName = scanner.next();
        Tower tower = databaseManager.getTower(towerName);
        if(tower == null)
        {
            System.out.println("No such tower in database => TRY AGAIN");
            return;
        }

        Mage mage = new Mage(name, level, tower);
        databaseManager.addMage(mage);
    }
    public static void addTower(Scanner scanner, DatabaseManager databaseManager) {
        String name = scanner.next();
        if(databaseManager.getTower(name) != null)
        {
            System.out.println("Tower with such name already exists => TRY AGAIN");
            return;
        }
        int level;
        try
        {
            level = scanner.nextInt();
        }
        catch (Exception e)
        {
            System.out.println("Invalid input => TRY AGAIN");
            return;
        }
        Tower tower = new Tower(name, level);
        databaseManager.addTower(tower);
    }
    public static void removeMage(Scanner scanner, DatabaseManager databaseManager) {
        String name = scanner.next();
        Mage mage = databaseManager.getEntityManager().find(Mage.class, name);
        if(mage == null)
        {
            System.out.println("No such mage in database => TRY AGAIN");
            return;
        }
        databaseManager.removeMage(mage);
    }
    public static void removeTower(Scanner scanner, DatabaseManager databaseManager) {
        String name = scanner.next();
        Tower tower = databaseManager.getEntityManager().find(Tower.class, name);
        if(tower == null)
        {
            System.out.println("No such tower in database => TRY AGAIN");
            return;
        }
        databaseManager.removeTower(tower);
    }
    public static void addPlaceholderData(DatabaseManager databaseManager) {
        Tower tower = new Tower("Tower1", 100);
        databaseManager.addTower(tower);
        Mage mage = new Mage("Mage1", 1, tower);
        databaseManager.addMage(mage);
        mage = new Mage("Mage2", 2, tower);
        databaseManager.addMage(mage);
        tower = new Tower("Tower2", 200);
        databaseManager.addTower(tower);
        mage = new Mage("Mage3", 3, tower);
        databaseManager.addMage(mage);
        mage = new Mage("Mage4", 4, tower);
        databaseManager.addMage(mage);

    }

    public static void getMagesWithLevelAbove(Scanner scanner, DatabaseManager databaseManager) {
        int level;
        try
        {
            level = scanner.nextInt();
        }
        catch (Exception e)
        {
            System.out.println("Invalid input => TRY AGAIN");
            return;
        }

        databaseManager.getMagesWithLevelAbove(level);

    }

    public static void getTowersWithHeightBelow(Scanner scanner, DatabaseManager databaseManager) {
        int height;
        try
        {
            height = scanner.nextInt();
        }
        catch (Exception e)
        {
            System.out.println("Invalid input => TRY AGAIN");
            return;
        }

        databaseManager.getTowersWithHeightBelow(height);

    }
    public static void getMagesFromTower(Scanner scanner, DatabaseManager databaseManager) {
        String towerName = scanner.next();
        Tower tower = databaseManager.getTower(towerName);
        if(tower == null)
        {
            System.out.println("No such tower in database => TRY AGAIN");
            return;
        }
        int level;
        try
        {
            level = scanner.nextInt();
        }
        catch (Exception e)
        {
            System.out.println("Invalid input => TRY AGAIN");
            return;
        }
        databaseManager.getMagesFromTower(tower.getName(), level);
    }
}
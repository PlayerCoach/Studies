package org.example;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) {

        MageController mageController = new MageController(new MageRepository(), new MageDTOMapper());
        MageDTO mageDTO = new MageDTO("Merlin", 100);
        System.out.println(mageController.addNewMage(mageDTO));
        System.out.println(mageController.addNewMage(mageDTO));
        System.out.println(mageController.findMageByName("Merlin"));
        System.out.println(mageController.deleteMageByName("Merlin"));
        System.out.println(mageController.findMageByName("Merlin"));


    }
}
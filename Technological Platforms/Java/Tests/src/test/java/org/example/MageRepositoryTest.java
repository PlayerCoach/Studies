package org.example;


import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Collection;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;
import static org.assertj.core.api.AssertionsForClassTypes.assertThatExceptionOfType;

class MageRepositoryTest
{
    private MageRepository mageRepository;

    @BeforeEach
    void setUp()
    {
        mageRepository = new MageRepository();
    }

    @Test
    void testAddNewMage()
    {
        Mage mage = new Mage("Gandalf", 10);
        mageRepository.addNewMage(mage);
        Collection<Mage> mages = mageRepository.getMages();
        assertThat(mages).asList().contains(mage);
    }

    @Test
    void testAddExistingMage()
    {
        Mage mage = new Mage("Gandalf", 10);
        mageRepository.addNewMage(mage);
        assertThatExceptionOfType(IllegalArgumentException.class)
                .isThrownBy(() -> mageRepository.addNewMage(mage))
                .withMessage("Mage already exists");
    }

    @Test
    void testDeleteMageByName()
    {
        Mage mage = new Mage("Gandalf", 10);
        mageRepository.addNewMage(mage);
        mageRepository.deleteMageByName("Gandalf");
        Collection<Mage> mages = mageRepository.getMages();
        assertThat(mages).asList().doesNotContain(mage);
    }

    @Test
    void testDeleteNonExistingMage()
    {
      assertThatExceptionOfType(IllegalArgumentException.class)
              .isThrownBy(() -> mageRepository.deleteMageByName("Gandalf"))
              .withMessage("Mage not found");
    }

    @Test
    void testFindMageByName()
    {
        Mage mage = new Mage("Gandalf", 10);
        Mage mage2 = new Mage("Saruman", 20);
        mageRepository.addNewMage(mage2);
        mageRepository.addNewMage(mage);
        assertThat(mageRepository.findMageByName("Gandalf"))
                .isPresent()
                .get()
                .isEqualTo(mage);
        assertThat(mageRepository.findMageByName("Saruman"))
                .isPresent()
                .get()
                .isEqualTo(mage2);

    }

    @Test
    void testFindNonExistingMageByName()
    {
        Mage mage = new Mage("Saruman", 10);
        mageRepository.addNewMage(mage);
        assertThat(mageRepository.findMageByName("Gandalf")).isEmpty();
    }


}
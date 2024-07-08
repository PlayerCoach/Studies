package org.example;


import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;

import static org.mockito.Mockito.*;

class MageControllerTest {
    private MageRepository mockedMageRepository;
    private MageDTOMapper mockedMageDTOMapper;
    private MageController mageController;

    @BeforeEach
    void setUp() {
        mockedMageRepository = mock(MageRepository.class);
        mockedMageDTOMapper = mock(MageDTOMapper.class);
        mageController = new MageController(mockedMageRepository, mockedMageDTOMapper);
    }

    @Test
    void testFindMageByName() {

        Mage mage = new Mage("Gandalf", 10);
        when(mockedMageRepository.findMageByName("Gandalf")).thenReturn(java.util.Optional.of(mage));
        when(mockedMageDTOMapper.apply(mage)).thenReturn(new MageDTO("Gandalf", 10));
        assertThat(mageController.findMageByName("Gandalf")).isEqualTo("{name='Gandalf', level=10}");
    }

    @Test
    void testFindNonExistingMage() {

        when(mockedMageRepository.findMageByName("Gandalf")).thenReturn(java.util.Optional.empty());
        assertThat(mageController.findMageByName("Gandalf")).isEqualTo("not found");
    }

    @Test
    void testDeleteMageByName() {

        when(mockedMageRepository.findMageByName("Gandalf")).thenReturn(java.util.Optional.of(new Mage("Gandalf", 10)));
        assertThat(mageController.deleteMageByName("Gandalf")).isEqualTo("done");
    }

    @Test
    void testDeleteNonExistingMage() {

        doThrow(new IllegalArgumentException()).when(mockedMageRepository).deleteMageByName("Gandalf");
        assertThat(mageController.deleteMageByName("Gandalf")).isEqualTo("not found");

    }

    @Test
    void testAddNewMage() {

        MageDTO mageDTO = new MageDTO("Gandalf", 10);
        when(mockedMageDTOMapper.apply(any(Mage.class))).thenReturn(mageDTO);
        assertThat(mageController.addNewMage(mageDTO)).isEqualTo("done");
    }

    @Test
    void testAddExistingMage() {
        Mage mage = new Mage("Gandalf", 10);
        doThrow(new IllegalArgumentException()).when(mockedMageRepository).addNewMage(mage);
        assertThat(mageController.addNewMage(new MageDTO("Gandalf", 10))).isEqualTo("bad request");
    }


}
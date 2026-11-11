package com.enit.service;

import com.enit.entities.Terrain;
import java.util.List;
import jakarta.ejb.Local;

@Local
public interface ILocalTerrain {

    void ajouterTerrain(Terrain terrain);

    void modifierTerrain(Terrain terrain);

    void supprimerTerrain(Long idTerrain);

    Terrain trouverTerrainParId(Long idTerrain);
    
    int countReservationsByTerrain(Long idTerrain);

    List<Terrain> trouverTousLesTerrains();

    List<Terrain> trouverTerrainsNonReserves();

    List<Object[]> compterReservationsParTerrain();
}

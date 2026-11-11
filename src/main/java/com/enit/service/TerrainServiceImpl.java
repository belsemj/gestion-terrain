package com.enit.service;

import com.enit.entities.Terrain;
import com.enit.entities.Reservation;
import com.enit.entities.Paiement;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import java.util.List;

@Stateless
public class TerrainServiceImpl implements ILocalTerrain {

    @PersistenceContext(unitName = "UP")
    private EntityManager em;

    @Override
    public void ajouterTerrain(Terrain terrain) {
        em.persist(terrain);
    }

    @Override
    public void modifierTerrain(Terrain terrain) {
        em.merge(terrain);
    }

    @Override
    public void supprimerTerrain(Long idTerrain) {
        Terrain t = em.find(Terrain.class, idTerrain);
        if (t != null) {
            em.remove(t);
        }
    }
    
    
    @Override
    public int countReservationsByTerrain(Long idTerrain) {
        Long count = em.createQuery(
            "SELECT COUNT(r) FROM Reservation r WHERE r.terrain.idTerrain = :id",
            Long.class
        )
        .setParameter("id", idTerrain)
        .getSingleResult();

        return count.intValue();
    }



    @Override
    public Terrain trouverTerrainParId(Long idTerrain) {
        return em.find(Terrain.class, idTerrain);
    }

    @Override
    public List<Terrain> trouverTousLesTerrains() {
        return em.createQuery("SELECT t FROM Terrain t", Terrain.class)
                 .getResultList();
    }
    

    @Override
    public List<Terrain> trouverTerrainsNonReserves() {
        return em.createQuery(
                "SELECT t FROM Terrain t WHERE t.idTerrain NOT IN " +
                "(SELECT r.terrain.idTerrain FROM Reservation r)",
                Terrain.class
        ).getResultList();
    }

    @Override
    public List<Object[]> compterReservationsParTerrain() {
        return em.createQuery(
                "SELECT t.nom, COUNT(r) FROM Terrain t LEFT JOIN t.listReserv r GROUP BY t.nom",
                Object[].class
        ).getResultList();
    }
}
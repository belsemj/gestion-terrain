package com.enit.service;

import com.enit.entities.Client;
import com.enit.entities.Reservation;
import com.enit.entities.Paiement;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import java.util.List;

@Stateless
public class ClientServiceImpl implements ILocalClient {

    @PersistenceContext(unitName = "UP")
    private EntityManager em;

    @Override
    public void ajouterClient(Client client) {
        em.persist(client);
    }

    @Override
    public void modifierClient(Client client) {
        em.merge(client);
    }

    @Override
    public void supprimerClient(Long idClient) {
        try {

            Client client = em.find(Client.class, idClient);
            if (client == null) {
                return; 
            }
            

            List<Reservation> reservations = em.createQuery(
                "SELECT r FROM Reservation r LEFT JOIN FETCH r.paiement WHERE r.client.idClient = :clientId", 
                Reservation.class
            ).setParameter("clientId", idClient)
             .getResultList();
            

            for (Reservation reservation : reservations) {
                if (reservation.getPaiement() != null) {
                   
                    Paiement paiement = reservation.getPaiement();
                    reservation.setPaiement(null); 
                    em.remove(paiement);
                }
            }
            

            for (Reservation reservation : reservations) {

                if (reservation.getTerrain() != null) {
                    reservation.getTerrain().getListReserv().remove(reservation);
                }
                em.remove(reservation);
            }
            

            client.getListReserv().clear();
            

            em.flush();
            em.remove(client);
            
        } catch (Exception e) {
   
            throw new RuntimeException("Erreur lors de la suppression du client: " + e.getMessage(), e);
        }
    }

    @Override
    public Client trouverClientParId(Long idClient) {
        return em.find(Client.class, idClient);
    }

    @Override
    public List<Client> trouverTousLesClients() {
        return em.createQuery(
            "SELECT DISTINCT c FROM Client c LEFT JOIN FETCH c.listReserv", 
            Client.class
        ).getResultList();
    }

    @Override
    public List<Client> clientsAyantReserveFootball() {
        return em.createQuery(
            "SELECT DISTINCT c FROM Client c " +
            "JOIN FETCH c.listReserv " +
            "WHERE EXISTS ( " +
            "   SELECT r FROM Reservation r " +
            "   WHERE r.client = c " +
            "   AND r.terrain.type = 'Football' " +
            ") " +
            "ORDER BY c.dateInscription DESC",
            Client.class
        ).getResultList();
    }




    @Override
    public List<Object[]> montantTotalParClient() {
        return em.createQuery(
            "SELECT c.nom, SUM(p.montant) " +
            "FROM Client c " +
            "JOIN c.listReserv r " +
            "JOIN r.paiement p " +
            "GROUP BY c.nom " +
            "ORDER BY SUM(p.montant) DESC",
            Object[].class
        ).getResultList();
    }

}
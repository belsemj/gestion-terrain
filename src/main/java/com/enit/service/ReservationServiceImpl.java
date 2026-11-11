package com.enit.service;

import com.enit.entities.Reservation;
import com.enit.entities.Paiement;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.time.LocalDate;
import java.util.List;

@Stateless
public class ReservationServiceImpl implements ILocalReservation {

    @PersistenceContext(unitName = "UP")
    private EntityManager em;

    @Override
    public void ajouterReservation(Reservation reservation) {
        em.merge(reservation);
    }


    @Override
    public void supprimerReservation(Long idReservation) {
        Reservation r = em.find(Reservation.class, idReservation);
        if (r != null) {
            em.remove(r);
        }
    }
    @Override
    public void modifierReservation(Reservation reservation) {
        em.merge(reservation); 
    }


    @Override
    public Reservation trouverReservationParId(Long idReservation) {
        return em.find(Reservation.class, idReservation);
    }

    @Override
    public List<Reservation> trouverToutesLesReservations() {
        return em.createQuery("SELECT r FROM Reservation r", Reservation.class)
                 .getResultList();
    }

    @Override
    public List<Reservation> reservationsParMois(int mois, int annee) {
        return em.createQuery(
                "SELECT r FROM Reservation r WHERE MONTH(r.dateReservation) = :m AND YEAR(r.dateReservation) = :a",
                Reservation.class
        ).setParameter("m", mois)
         .setParameter("a", annee)
         .getResultList();
    }

    @Override
    public void supprimerReservationsAvant(LocalDate date) {

        em.createQuery(
                "DELETE FROM Paiement p WHERE p.reservation.idReservation IN " +
                "(SELECT r.idReservation FROM Reservation r WHERE r.dateReservation < :d)"
        ).setParameter("d", date)
         .executeUpdate();
        

        em.createQuery(
                "DELETE FROM Reservation r WHERE r.dateReservation < :d"
        ).setParameter("d", date)
         .executeUpdate();
    }
}
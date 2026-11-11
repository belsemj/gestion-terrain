package com.enit.service;

import com.enit.entities.Reservation;
import java.time.LocalDate;
import java.util.List;
import jakarta.ejb.Local;

@Local
public interface ILocalReservation {

    void ajouterReservation(Reservation reservation);

    void supprimerReservation(Long idReservation);

    Reservation trouverReservationParId(Long idReservation);

    List<Reservation> trouverToutesLesReservations();

    List<Reservation> reservationsParMois(int mois, int annee);

    void supprimerReservationsAvant(LocalDate date);
    void modifierReservation(Reservation reservation);

}

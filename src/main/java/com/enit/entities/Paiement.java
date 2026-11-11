package com.enit.entities;

import java.time.LocalDate;  
import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "paiement")
public class Paiement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idPaiement;

    private double montant; 

    @Temporal(TemporalType.DATE)
    private Date datePaiement;

    @Column(length = 50)
    private String modePaiement;

    @OneToOne
    @JoinColumn(name = "id_reservation", unique = true)
    private Reservation reservation;

    public Paiement() {}


    public Paiement(double montant, LocalDate datePaiement, String modePaiement, Reservation reservation) {
        super();
        this.montant = montant;
        this.datePaiement = java.sql.Date.valueOf(datePaiement);
        this.modePaiement = modePaiement;
        this.reservation = reservation;
    }


    public Long getIdPaiement() { return idPaiement; }
    public void setIdPaiement(Long idPaiement) { this.idPaiement = idPaiement; }

    public double getMontant() { return montant; }
    public void setMontant(double montant) { this.montant = montant; }

    public Date getDatePaiement() { return datePaiement; }
    public void setDatePaiement(Date datePaiement) { this.datePaiement = datePaiement; }

    public String getModePaiement() { return modePaiement; }
    public void setModePaiement(String modePaiement) { this.modePaiement = modePaiement; }

    public Reservation getReservation() { return reservation; }
    public void setReservation(Reservation reservation) { this.reservation = reservation; }

    @Override
    public String toString() {
        return "Paiement [idPaiement=" + idPaiement + ", montant=" + montant + 
               ", datePaiement=" + datePaiement + ", modePaiement=" + modePaiement + "]";
    }
}
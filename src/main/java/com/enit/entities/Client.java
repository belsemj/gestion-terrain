package com.enit.entities;

import jakarta.persistence.*;


import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import java.util.Date;
@Entity
@Table(name = "client", uniqueConstraints = {@UniqueConstraint(columnNames = {"email"})})
public class Client {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idClient;

    @Column(length = 50, nullable = false)
    private String nom;

    @Column(length = 50, nullable = false, unique = true)
    private String email;

    @Column(length = 60)
    private String telephone;
    
    @Temporal(TemporalType.DATE)
    private Date dateInscription;

    @OneToMany(
    	    mappedBy = "client",
    	    cascade = CascadeType.ALL,
    	    orphanRemoval = true,
    	    fetch = FetchType.LAZY
    	)
    	private List<Reservation> listReserv = new ArrayList<>();


    public Client() {}

    public Client(String nom, String email, String telephone, LocalDate dateInscription) {
        this.nom = nom;
        this.email = email;
        this.telephone = telephone;
        this.dateInscription = java.sql.Date.valueOf(dateInscription);
    }

    public Long getIdClient() {
        return idClient;
    }

    public void setIdClient(Long idClient) {
        this.idClient = idClient;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public Date  getDateInscription() {
        return dateInscription;
    }

    public void setDateInscription(Date  dateInscription) {
        this.dateInscription = dateInscription;
    }

    public List<Reservation> getListReserv() {
        return listReserv;
    }

    public void setListReserv(List<Reservation> listReserv) {
        this.listReserv = listReserv;
    }

    @Override
    public String toString() {
        return "Client [idClient=" + idClient + ", nom=" + nom + ", email=" + email + ", telephone=" + telephone
                + ", dateInscription=" + dateInscription + ", nombreReservations=" + listReserv.size() + "]";
    }
}

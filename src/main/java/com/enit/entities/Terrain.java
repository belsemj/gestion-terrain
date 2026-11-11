package com.enit.entities;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "terrain")
public class Terrain {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idTerrain;

    @Column(length = 50, nullable = false)
    private String nom;

    @Column(length = 50)
    private String type;

    private Integer capacite;

    @Column(length = 100)
    private String localisation;

    @OneToMany(
    	    mappedBy = "terrain",
    	    cascade = CascadeType.ALL,
    	    orphanRemoval = true,
    	    fetch = FetchType.LAZY
    	)
    	private List<Reservation> listReserv = new ArrayList<>();




    public Terrain() {}

    public Terrain( String nom, String type, Integer capacite, String localisation) {
		super();
		this.nom = nom;
		this.type = type;
		this.capacite = capacite;
		this.localisation = localisation;
	}

	public Long getIdTerrain() {
        return idTerrain;
    }

    public void setIdTerrain(Long idTerrain) {
        this.idTerrain = idTerrain;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Integer getCapacite() {
        return capacite;
    }

    public void setCapacite(Integer capacite) {
        this.capacite = capacite;
    }

    public String getLocalisation() {
        return localisation;
    }

    public void setLocalisation(String localisation) {
        this.localisation = localisation;
    }

    public List<Reservation> getListReserv() {
        return listReserv;
    }

    public void setListReserv(List<Reservation> listReserv) {
        this.listReserv = listReserv;
    }

    @Override
    public String toString() {
        return "Terrain [idTerrain=" + idTerrain +
               ", nom=" + nom +
               ", type=" + type +
               ", capacite=" + capacite +
               ", localisation=" + localisation + ", nombreReservations=" + listReserv.size() + "]";
    }
}

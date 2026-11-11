package com.enit.service;

import com.enit.entities.Paiement;
import jakarta.ejb.Local;
import java.util.List;

@Local
public interface ILocalPaiement {

    void ajouterPaiement(Paiement paiement);
    
    void modifierPaiement(Paiement paiement); // NOUVELLE MÉTHODE

    void modifierModePaiement(Long idPaiement, String nouveauMode);

    Paiement trouverPaiementParId(Long idPaiement);

    List<Paiement> trouverTousLesPaiements();
}
package com.enit.service;

import com.enit.entities.Paiement;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class PaiementServiceImpl implements ILocalPaiement {

    @PersistenceContext(unitName = "UP")
    private EntityManager em;

    @Override
    public void ajouterPaiement(Paiement paiement) {
        em.persist(paiement);
    }
    
    @Override
    public void modifierPaiement(Paiement paiement) {
        em.merge(paiement);
    }

    @Override
    public void modifierModePaiement(Long idPaiement, String nouveauMode) {
        Paiement p = em.find(Paiement.class, idPaiement);
        if (p != null) {
            p.setModePaiement(nouveauMode);
            em.merge(p);
        }
    }

    @Override
    public Paiement trouverPaiementParId(Long idPaiement) {
        return em.find(Paiement.class, idPaiement);
    }

    @Override
    public List<Paiement> trouverTousLesPaiements() {
        return em.createQuery("SELECT p FROM Paiement p", Paiement.class)
                 .getResultList();
    }
}
package com.enit.service;

import com.enit.entities.Client;
import java.util.List;
import jakarta.ejb.Local;

@Local
public interface ILocalClient {

    void ajouterClient(Client client);

    void modifierClient(Client client);

    void supprimerClient(Long idClient);

    Client trouverClientParId(Long idClient);

    List<Client> trouverTousLesClients();

    List<Client> clientsAyantReserveFootball();

    List<Object[]> montantTotalParClient();
}

package com.enit.controller;

import com.enit.entities.Client;
import com.enit.service.ILocalClient;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;

@WebServlet("/client")
public class ClientServlet extends HttpServlet {
    
    @EJB
    private ILocalClient clientService;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "ajout":
                afficherFormulaire(request, response);
                break;
            case "edit":
                editerClient(request, response);
                break;
            case "delete":
                supprimerClient(request, response);
                break;
            case "football":
                clientsFootball(request, response);
                break;
            case "montants":
                montantsParClient(request, response);
                break;
            case "list":
            default:
                listerClients(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("ajouter".equals(action)) {
            ajouterClient(request, response);
        } else if ("modifier".equals(action)) {
            modifierClient(request, response);
        }
    }
    
    private void listerClients(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Client> clients = clientService.trouverTousLesClients();
        request.setAttribute("clients", clients);
        request.getRequestDispatcher("/client/list.jsp").forward(request, response);
    }
    
    private void clientsFootball(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Client> clients = clientService.clientsAyantReserveFootball();
        request.setAttribute("clients", clients);
        request.setAttribute("mode", "football");
        request.getRequestDispatcher("/client/list.jsp").forward(request, response);
    }
    
    private void montantsParClient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Object[]> montants = clientService.montantTotalParClient();
        request.setAttribute("montants", montants);
        request.setAttribute("mode", "montants");
        request.getRequestDispatcher("/client/list.jsp").forward(request, response);
    }
    
    private void afficherFormulaire(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/client/form.jsp").forward(request, response);
    }
    
    private void editerClient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam != null) {
            Long id = Long.parseLong(idParam);
            Client client = clientService.trouverClientParId(id);
            request.setAttribute("client", client);
        }
        request.getRequestDispatcher("/client/form.jsp").forward(request, response);
    }
    
    private void ajouterClient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nom = request.getParameter("nom");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String dateStr = request.getParameter("dateInscription");
        
        LocalDate dateInscription = dateStr != null && !dateStr.isEmpty() 
                ? LocalDate.parse(dateStr) : LocalDate.now();
        
        Client client = new Client(nom, email, telephone, dateInscription);
        clientService.ajouterClient(client);
        
        response.sendRedirect(request.getContextPath() + "/client?action=list");
    }
    
    private void modifierClient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        Long id = Long.parseLong(idParam);
        
        String nom = request.getParameter("nom");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String dateStr = request.getParameter("dateInscription");
        
        Client client = clientService.trouverClientParId(id);
        if (client != null) {
            client.setNom(nom);
            client.setEmail(email);
            client.setTelephone(telephone);
            
            if (dateStr != null && !dateStr.isEmpty()) {
                LocalDate date = LocalDate.parse(dateStr);
                client.setDateInscription(java.sql.Date.valueOf(date));
            }
            
            clientService.modifierClient(client);
        }
        
        response.sendRedirect(request.getContextPath() + "/client?action=list");
    }
    
    private void supprimerClient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                Long id = Long.parseLong(idParam);
                

                clientService.supprimerClient(id);
                

                request.getSession().setAttribute("successMessage", "Client supprim  avec succ s");
                
            } catch (Exception e) {

                request.getSession().setAttribute("errorMessage", 
                    "Erreur lors de la suppression : " + e.getMessage());
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/client?action=list");
    }
}
package com.enit.controller;

import com.enit.entities.Paiement;
import com.enit.entities.Reservation;
import com.enit.service.ILocalPaiement;
import com.enit.service.ILocalReservation;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/paiement")
public class PaiementServlet extends HttpServlet {
    
    @EJB
    private ILocalPaiement paiementService;
    
    @EJB
    private ILocalReservation reservationService;
    
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
                editerPaiement(request, response);
                break;
            case "delete":
                supprimerPaiement(request, response);
                break;
            case "list":
            default:
                listerPaiements(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("ajouter".equals(action)) {
            ajouterPaiement(request, response);
        } else if ("modifier".equals(action)) {
            modifierPaiement(request, response);
        } else if ("changerMode".equals(action)) {
            changerModePaiement(request, response);
        }
    }
    
    private void listerPaiements(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Paiement> paiements = paiementService.trouverTousLesPaiements();
        request.setAttribute("paiements", paiements);
        request.getRequestDispatcher("/paiement/list.jsp").forward(request, response);
    }
    
    private void afficherFormulaire(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        

        List<Reservation> reservations = reservationService.trouverToutesLesReservations();
        request.setAttribute("reservations", reservations);
        request.getRequestDispatcher("/paiement/form.jsp").forward(request, response);
    }
    
    private void editerPaiement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam != null) {
            Long id = Long.parseLong(idParam);
            Paiement paiement = paiementService.trouverPaiementParId(id);
            request.setAttribute("paiement", paiement);
        }
        request.getRequestDispatcher("/paiement/form.jsp").forward(request, response);
    }
    
    private void ajouterPaiement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String montantStr = request.getParameter("montant");
        String dateStr = request.getParameter("datePaiement");
        String modePaiement = request.getParameter("modePaiement");
        String reservationIdStr = request.getParameter("reservationId");
        

        if (montantStr == null || dateStr == null || modePaiement == null || reservationIdStr == null) {
            request.setAttribute("error", "Tous les champs sont obligatoires");
            afficherFormulaire(request, response);
            return;
        }
        
        try {

            double montant = Double.parseDouble(montantStr);
            LocalDate datePaiement = LocalDate.parse(dateStr);
            Long reservationId = Long.parseLong(reservationIdStr);
            
            Reservation reservation = reservationService.trouverReservationParId(reservationId);
            
            if (reservation != null) {

                Paiement paiement = new Paiement(montant, datePaiement, modePaiement, reservation);
                paiementService.ajouterPaiement(paiement);
                

                reservation.setPaiement(paiement);
            } else {
                request.setAttribute("error", "Réservation non trouvée");
                afficherFormulaire(request, response);
                return;
            }
            
            response.sendRedirect(request.getContextPath() + "/paiement?action=list");
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Format de montant invalide");
            afficherFormulaire(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            afficherFormulaire(request, response);
        }
    }
    
    private void modifierPaiement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        Long id = Long.parseLong(idParam);
        
        String montantStr = request.getParameter("montant");
        String dateStr = request.getParameter("datePaiement");
        String modePaiement = request.getParameter("modePaiement");
        

        double montant = Double.parseDouble(montantStr);
        
        Paiement paiement = paiementService.trouverPaiementParId(id);
        if (paiement != null) {
            paiement.setMontant(montant);
            paiement.setDatePaiement(java.sql.Date.valueOf(LocalDate.parse(dateStr)));
            paiement.setModePaiement(modePaiement);
            

        }
        
        response.sendRedirect(request.getContextPath() + "/paiement?action=list");
    }
    
    private void changerModePaiement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        String nouveauMode = request.getParameter("mode");
        
        if (idParam != null && nouveauMode != null) {
            Long id = Long.parseLong(idParam);
            paiementService.modifierModePaiement(id, nouveauMode);
        }
        
        response.sendRedirect(request.getContextPath() + "/paiement?action=list");
    }
    
    private void supprimerPaiement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        response.sendRedirect(request.getContextPath() + "/paiement?action=list");
    }
}
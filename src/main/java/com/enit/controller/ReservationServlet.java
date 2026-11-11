package com.enit.controller;

import com.enit.entities.Reservation;
import com.enit.entities.Client;
import com.enit.entities.Terrain;
import com.enit.service.ILocalReservation;
import com.enit.service.ILocalClient;
import com.enit.service.ILocalTerrain;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {
    
    @EJB
    private ILocalReservation reservationService;
    
    @EJB
    private ILocalClient clientService;
    
    @EJB
    private ILocalTerrain terrainService;
    
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
                editerReservation(request, response);
                break;
            case "delete":
                supprimerReservation(request, response);
                break;
            case "mois":
                reservationsParMois(request, response);
                break;
            case "list":
            default:
                listerReservations(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("ajouter".equals(action)) {
            ajouterReservation(request, response);
        } else if ("modifier".equals(action)) {
            modifierReservation(request, response);
        }
    }
    
    private void listerReservations(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Reservation> reservations = reservationService.trouverToutesLesReservations();
        request.setAttribute("reservations", reservations);
        request.getRequestDispatcher("/reservation/list.jsp").forward(request, response);
    }
    
    private void reservationsParMois(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String moisStr = request.getParameter("mois");
        String anneeStr = request.getParameter("annee");
        
        int mois = moisStr != null ? Integer.parseInt(moisStr) : LocalDate.now().getMonthValue();
        int annee = anneeStr != null ? Integer.parseInt(anneeStr) : LocalDate.now().getYear();
        
        List<Reservation> reservations = reservationService.reservationsParMois(mois, annee);
        request.setAttribute("reservations", reservations);
        request.setAttribute("mois", mois);
        request.setAttribute("annee", annee);
        request.setAttribute("mode", "mois");
        
        request.getRequestDispatcher("/reservation/filtreMois.jsp").forward(request, response);
    }
    
    private void afficherFormulaire(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        

        List<Client> clients = clientService.trouverTousLesClients();
        List<Terrain> terrains = terrainService.trouverTousLesTerrains();
        
        request.setAttribute("clients", clients);
        request.setAttribute("terrains", terrains);
        request.getRequestDispatcher("/reservation/form.jsp").forward(request, response);
    }
    
    private void editerReservation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam != null) {
            Long id = Long.parseLong(idParam);
            Reservation reservation = reservationService.trouverReservationParId(id);
            request.setAttribute("reservation", reservation);
        }
        

        List<Client> clients = clientService.trouverTousLesClients();
        List<Terrain> terrains = terrainService.trouverTousLesTerrains();
        
        request.setAttribute("clients", clients);
        request.setAttribute("terrains", terrains);
        request.getRequestDispatcher("/reservation/form.jsp").forward(request, response);
    }
    
    private void ajouterReservation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String dateStr = request.getParameter("dateReservation");
        String heureDebutStr = request.getParameter("heureDebut");
        String heureFinStr = request.getParameter("heureFin");
        String clientIdStr = request.getParameter("clientId");
        String terrainIdStr = request.getParameter("terrainId");
        
        LocalDate dateReservation = LocalDate.parse(dateStr);
        LocalTime heureDebut = LocalTime.parse(heureDebutStr);
        LocalTime heureFin = LocalTime.parse(heureFinStr);
        
        Long clientId = Long.parseLong(clientIdStr);
        Long terrainId = Long.parseLong(terrainIdStr);
        
        Client client = clientService.trouverClientParId(clientId);
        Terrain terrain = terrainService.trouverTerrainParId(terrainId);
        
        if (client != null && terrain != null) {
            Reservation reservation = new Reservation(
                dateReservation, heureDebut, heureFin, client, terrain
            );
            reservationService.ajouterReservation(reservation);
        }
        
        response.sendRedirect(request.getContextPath() + "/reservation?action=list");
    }
    
    private void modifierReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long id = Long.parseLong(request.getParameter("id"));

        Reservation reservation = reservationService.trouverReservationParId(id);

        if (reservation != null) {
            reservation.setDateReservation(LocalDate.parse(request.getParameter("dateReservation")));
            reservation.setHeureDebut(LocalTime.parse(request.getParameter("heureDebut")));
            reservation.setHeureFin(LocalTime.parse(request.getParameter("heureFin")));

            Long clientId = Long.parseLong(request.getParameter("clientId"));
            Long terrainId = Long.parseLong(request.getParameter("terrainId"));

            Client client = clientService.trouverClientParId(clientId);
            Terrain terrain = terrainService.trouverTerrainParId(terrainId);

            if (client != null && terrain != null) {
                reservation.setClient(client);
                reservation.setTerrain(terrain);

            }
        }

        response.sendRedirect(request.getContextPath() + "/reservation?action=list");
    }

    private void supprimerReservation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam != null) {
            Long id = Long.parseLong(idParam);
            reservationService.supprimerReservation(id);
        }
        
        response.sendRedirect(request.getContextPath() + "/reservation?action=list");
    }
}
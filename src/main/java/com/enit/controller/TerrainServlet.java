package com.enit.controller;

import com.enit.entities.Terrain;
import com.enit.service.ILocalTerrain;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/terrain")
public class TerrainServlet extends HttpServlet {
    
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
                editerTerrain(request, response);
                break;
            case "confirmDelete":
                afficherConfirmation(request, response);
                break;
            case "nonReserves":  
                afficherTerrainsNonReserves(request, response);
                break;
            case "list":
            default:
                listerTerrains(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("ajouter".equals(action)) {
            ajouterTerrain(request, response);
        }
        else if ("modifier".equals(action)) {
            modifierTerrain(request, response);
        }
        else if ("delete".equals(action)) {
            supprimerTerrainConfirmé(request, response);
        }
    }

    
    private void listerTerrains(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Terrain> terrains = terrainService.trouverTousLesTerrains();
        request.setAttribute("terrains", terrains);
        

        List<Object[]> stats = terrainService.compterReservationsParTerrain();
        request.setAttribute("statsReservations", stats);
        
        request.getRequestDispatcher("/terrain/list.jsp").forward(request, response);
    }
    
    private void afficherFormulaire(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/terrain/form.jsp").forward(request, response);
    }
    
    private void editerTerrain(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam != null) {
            Long id = Long.parseLong(idParam);
            Terrain terrain = terrainService.trouverTerrainParId(id);
            request.setAttribute("terrain", terrain);
        }
        request.getRequestDispatcher("/terrain/form.jsp").forward(request, response);
    }
    
    private void ajouterTerrain(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nom = request.getParameter("nom");
        String type = request.getParameter("type");
        String capaciteStr = request.getParameter("capacite");
        String localisation = request.getParameter("localisation");
        
        Integer capacite = capaciteStr != null && !capaciteStr.isEmpty() 
                ? Integer.parseInt(capaciteStr) : null;
        
        Terrain terrain = new Terrain(nom, type, capacite, localisation);
        terrainService.ajouterTerrain(terrain);
        
        response.sendRedirect(request.getContextPath() + "/terrain?action=list");
    }
    
    private void modifierTerrain(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        Long id = Long.parseLong(idParam);
        
        String nom = request.getParameter("nom");
        String type = request.getParameter("type");
        String capaciteStr = request.getParameter("capacite");
        String localisation = request.getParameter("localisation");
        
        Integer capacite = capaciteStr != null && !capaciteStr.isEmpty() 
                ? Integer.parseInt(capaciteStr) : null;
        
        Terrain terrain = terrainService.trouverTerrainParId(id);
        if (terrain != null) {
            terrain.setNom(nom);
            terrain.setType(type);
            terrain.setCapacite(capacite);
            terrain.setLocalisation(localisation);
            
            terrainService.modifierTerrain(terrain);
        }
        
        response.sendRedirect(request.getContextPath() + "/terrain?action=list");
    }
    
    private void supprimerTerrain(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                Long id = Long.parseLong(idParam);
                

                Terrain terrain = terrainService.trouverTerrainParId(id);
                if (terrain != null && terrain.getListReserv() != null && !terrain.getListReserv().isEmpty()) {

                    request.setAttribute("terrain", terrain);
                    request.setAttribute("hasReservations", true);
                    request.getRequestDispatcher("/terrain/confirmDelete.jsp").forward(request, response);
                    return;
                }
                

                terrainService.supprimerTerrain(id);
                
            } catch (Exception e) {

                request.setAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
                listerTerrains(request, response);
                return;
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/terrain?action=list");
    }
    
    private void afficherConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long id = Long.parseLong(request.getParameter("id"));

        Terrain terrain = terrainService.trouverTerrainParId(id);
        int nbReservations = terrainService.countReservationsByTerrain(id);

        request.setAttribute("terrain", terrain);
        request.setAttribute("nbReservations", nbReservations);
        request.setAttribute("hasReservations", nbReservations > 0);

        request.getRequestDispatcher("/terrain/confirmDelete.jsp")
               .forward(request, response);
    }



    private void supprimerTerrainConfirmé(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        terrainService.supprimerTerrain(id);

        response.sendRedirect(request.getContextPath() + "/terrain?action=list");
    }

    private void afficherTerrainsNonReserves(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Terrain> terrainsNonReserves = terrainService.trouverTerrainsNonReserves();
        request.setAttribute("terrainsNonReserves", terrainsNonReserves);
        
        request.getRequestDispatcher("/terrain/nonReserves.jsp").forward(request, response);
    }
}



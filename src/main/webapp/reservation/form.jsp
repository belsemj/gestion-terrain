<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.enit.entities.*" %>
<%
    Reservation reservation = (Reservation) request.getAttribute("reservation");
    List<Client> clients = (List<Client>) request.getAttribute("clients");
    List<Terrain> terrains = (List<Terrain>) request.getAttribute("terrains");

    boolean isEdit = reservation != null;
    String action = isEdit ? "modifier" : "ajouter";
    String title = isEdit ? "Modifier une réservation" : "Nouvelle réservation";
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= title %></title>
    <meta charset="UTF-8">

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: "Inter", "Segoe UI", Arial, sans-serif;
            background: #f3f4f6;
            color: #111827;
        }

        .app-header {
            position: sticky;
            top: 0;
            z-index: 10;
            background: #111827;
            color: #f9fafb;
            padding: 12px 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .app-title {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .app-logo {
            width: 32px;
            height: 32px;
            border-radius: 999px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #1f2937;
            font-size: 18px;
        }

        .app-title-text {
            display: flex;
            flex-direction: column;
        }

        .app-title-text h1 {
            margin: 0;
            font-size: 18px;
            font-weight: 700;
        }

        .app-title-text span {
            font-size: 12px;
            color: #9ca3af;
        }

        .app-header-right a {
            text-decoration: none;
            font-size: 13px;
            padding: 7px 12px;
            border-radius: 999px;
            background: #f97316;
            color: #111827;
            font-weight: 600;
        }

        .app-main {
            max-width: 760px;
            margin: 24px auto 32px;
            padding: 0 16px;
        }

        .form-card {
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
            padding: 18px 18px 16px;
        }

        .form-header {
            margin-bottom: 14px;
        }

        .form-title {
            font-size: 18px;
            font-weight: 700;
            margin: 0 0 4px;
        }

        .form-sub {
            font-size: 13px;
            color: #6b7280;
        }

        form { margin-top: 10px; }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 6px;
            color: #374151;
        }

        .required {
            color: #ef4444;
            margin-left: 3px;
        }

        .form-group input,
        .form-group select {
            padding: 9px 11px;
            border-radius: 9px;
            border: 1px solid #d1d5db;
            font-size: 14px;
            background: #f9fafb;
            color: #111827;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #2563eb;
            background: #ffffff;
            box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.15);
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .info-line {
            grid-column: 1 / -1;
            font-size: 12px;
            color: #6b7280;
            background: #e5f2ff;
            border-radius: 9px;
            padding: 8px 10px;
            margin-bottom: 4px;
        }

        .form-actions {
            margin-top: 18px;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn {
            border: none;
            border-radius: 999px;
            padding: 8px 16px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #374151;
        }

        .btn-primary {
            background: #22c55e;
            color: #111827;
        }

        @media (max-width: 700px) {
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<header class="app-header">
    <div class="app-title">
        <div class="app-logo">📅</div>
        <div class="app-title-text">
            <h1>Gestion Sportive</h1>
            <span>Réservations</span>
        </div>
    </div>
    <div class="app-header-right">
        <a href="home">🏠 Dashboard</a>
    </div>
</header>

<main class="app-main">
    <section class="form-card">
        <div class="form-header">
            <h2 class="form-title"><%= title %></h2>
            <p class="form-sub">
                Choisissez le client, le terrain, la date et les horaires de réservation.
            </p>
        </div>

        <form action="reservation" method="post">
            <% if (isEdit) { %>
                <input type="hidden" name="id" value="<%= reservation.getIdReservation() %>">
            <% } %>
            <input type="hidden" name="action" value="<%= action %>">

            <div class="form-grid">
                <div class="info-line">
                    Tous les champs sont obligatoires, vérifiez bien les horaires et le terrain.
                </div>

                <div class="form-group">
                    <label>Date de réservation<span class="required">*</span></label>
                    <input type="date"
                           name="dateReservation"
                           value="<%= isEdit && reservation.getDateReservation() != null
                                   ? reservation.getDateReservation().toString()
                                   : java.time.LocalDate.now().toString() %>"
                           required>
                </div>

                <div class="form-group">
                    <label>Client<span class="required">*</span></label>
                    <select name="clientId" required>
                        <option value="">-- Sélectionner un client --</option>
                        <% if (clients != null) {
                               for (Client c : clients) { %>
                                   <option value="<%= c.getIdClient() %>"
                                       <%= isEdit && reservation.getClient() != null &&
                                           reservation.getClient().getIdClient().equals(c.getIdClient()) ? "selected" : "" %>>
                                       <%= c.getNom() %> (<%= c.getEmail() %>)
                                   </option>
                        <%     }
                           } %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Heure de début<span class="required">*</span></label>
                    <input type="time"
                           name="heureDebut"
                           value="<%= isEdit && reservation.getHeureDebut() != null
                                   ? reservation.getHeureDebut().toString()
                                   : "09:00" %>"
                           required>
                </div>

                <div class="form-group">
                    <label>Heure de fin<span class="required">*</span></label>
                    <input type="time"
                           name="heureFin"
                           value="<%= isEdit && reservation.getHeureFin() != null
                                   ? reservation.getHeureFin().toString()
                                   : "10:00" %>"
                           required>
                </div>

                <div class="form-group full-width">
                    <label>Terrain<span class="required">*</span></label>
                    <select name="terrainId" required>
                        <option value="">-- Sélectionner un terrain --</option>
                        <% if (terrains != null) {
                               for (Terrain t : terrains) { %>
                                   <option value="<%= t.getIdTerrain() %>"
                                       <%= isEdit && reservation.getTerrain() != null &&
                                           reservation.getTerrain().getIdTerrain().equals(t.getIdTerrain()) ? "selected" : "" %>>
                                       <%= t.getNom() %> (<%= t.getType() %>)
                                   </option>
                        <%     }
                           } %>
                    </select>
                </div>
            </div>

            <div class="form-actions">
                <a href="reservation?action=list" class="btn btn-secondary">Annuler</a>
                <button type="submit" class="btn btn-primary">
                    <%= isEdit ? "Enregistrer" : "Ajouter la réservation" %>
                </button>
            </div>
        </form>
    </section>
</main>

</body>
</html>

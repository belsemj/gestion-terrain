<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.enit.entities.*, java.text.SimpleDateFormat" %>
<%
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");

    int total = reservations != null ? reservations.size() : 0;
    int actives = 0;
    if (reservations != null) {
        java.time.LocalDate today = java.time.LocalDate.now();
        for (Reservation r : reservations) {
            if (r.getDateReservation() != null) {
                java.time.LocalDate d = r.getDateReservation();
                if (!d.isBefore(today)) {
                    actives++;
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Gestion des Réservations</title>
    <meta charset="UTF-8">

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: "Inter", "Segoe UI", Arial, sans-serif;
            background: #f3f4f6;
            color: #111827;
        }

        /* HEADER type home simplifié */
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

        /* MAIN */
        .app-main {
            max-width: 1120px;
            margin: 24px auto 32px;
            padding: 0 16px;
        }

        .page-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            gap: 12px;
        }

        .page-title-block {
            display: flex;
            flex-direction: column;
        }

        .page-title {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
        }

        .page-sub {
            font-size: 13px;
            color: #6b7280;
        }

        .btn-primary {
            text-decoration: none;
            padding: 8px 14px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 600;
            background: #2563eb;
            color: #ffffff;
        }

        .alert {
            padding: 10px 12px;
            border-radius: 9px;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .alert-success {
            background: #dcfce7;
            color: #166534;
        }

        .alert-error {
            background: #fee2e2;
            color: #b91c1c;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .stat-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 12px 12px 10px;
            box-shadow: 0 6px 20px rgba(15, 23, 42, 0.08);
        }

        .stat-label {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: #6b7280;
            margin-bottom: 2px;
        }

        .stat-value {
            font-size: 18px;
            font-weight: 700;
        }

        .stat-sub {
            font-size: 12px;
            color: #9ca3af;
        }

        .table-card {
            background: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(15, 23, 42, 0.08);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        thead {
            background: #f9fafb;
        }

        th, td {
            padding: 10px 12px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }

        th {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: #6b7280;
        }

        tbody tr:hover {
            background: #f3f4ff;
        }

        .client-name {
            font-weight: 700;
        }

        .client-email {
            font-size: 12px;
            color: #6b7280;
        }

        .terrain-name {
            font-weight: 700;
            color: #2563eb;
        }

        .time-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 999px;
            font-size: 12px;
            background: #fef9c3;
            color: #854d0e;
        }

        .actions {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .btn-action {
            text-decoration: none;
            padding: 5px 9px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }

        .btn-edit {
            background: #dcfce7;
            color: #166534;
        }

        .btn-delete {
            background: #fee2e2;
            color: #b91c1c;
        }

        .empty-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 30px 20px;
            text-align: center;
            box-shadow: 0 6px 20px rgba(15, 23, 42, 0.08);
            margin-top: 10px;
        }

        @media (max-width: 768px) {
            .page-head { flex-direction: column; align-items: flex-start; }
            .table-card { overflow-x: auto; }
            table { min-width: 900px; }
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

    <div class="page-head">
        <div class="page-title-block">
            <h2 class="page-title">Gestion des réservations</h2>
            <p class="page-sub">Visualisez et gérez tous vos créneaux réservés.</p>
        </div>
        <a href="reservation?action=ajout" class="btn-primary">➕ Nouvelle réservation</a>
    </div>

    <% if (successMessage != null) { session.removeAttribute("successMessage"); %>
        <div class="alert alert-success"><%= successMessage %></div>
    <% } %>

    <% if (errorMessage != null) { session.removeAttribute("errorMessage"); %>
        <div class="alert alert-error"><%= errorMessage %></div>
    <% } %>

    <section class="stats-grid">
        <div class="stat-card">
            <div class="stat-label">Total réservations</div>
            <div class="stat-value"><%= total %></div>
            <div class="stat-sub">toutes périodes</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">À venir</div>
            <div class="stat-value"><%= actives %></div>
            <div class="stat-sub">du jour et plus tard</div>
        </div>
    </section>

    <% if (reservations != null && !reservations.isEmpty()) { %>

        <section class="table-card">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Date</th>
                    <th>Horaires</th>
                    <th>Client</th>
                    <th>Terrain</th>
                    <th>Type</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Reservation r : reservations) { %>
                    <tr>
                        <td>#<%= r.getIdReservation() %></td>
                        <td>
                            <% if (r.getDateReservation() != null) { %>
                                <%= sdf.format(java.sql.Date.valueOf(r.getDateReservation())) %>
                            <% } else { %>
                                N/A
                            <% } %>
                        </td>
                        <td>
                            <span class="time-badge">
                                <%= r.getHeureDebut() %> – <%= r.getHeureFin() %>
                            </span>
                        </td>
                        <td>
                            <% if (r.getClient() != null) { %>
                                <div class="client-name"><%= r.getClient().getNom() %></div>
                                <div class="client-email"><%= r.getClient().getEmail() %></div>
                            <% } else { %>
                                N/A
                            <% } %>
                        </td>
                        <td>
                            <% if (r.getTerrain() != null) { %>
                                <span class="terrain-name"><%= r.getTerrain().getNom() %></span>
                            <% } else { %>
                                N/A
                            <% } %>
                        </td>
                        <td>
                            <% if (r.getTerrain() != null && r.getTerrain().getType() != null) { %>
                                <%= r.getTerrain().getType() %>
                            <% } else { %>
                                N/A
                            <% } %>
                        </td>
                        <td>
                            <div class="actions">
                                <a href="reservation?action=edit&id=<%= r.getIdReservation() %>"
                                   class="btn-action btn-edit">
                                    Modifier
                                </a>
                                <a href="reservation?action=delete&id=<%= r.getIdReservation() %>"
                                   class="btn-action btn-delete"
                                   onclick="return confirm('Confirmer la suppression de cette réservation ?')">
                                    Supprimer
                                </a>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </section>

    <% } else { %>

        <section class="empty-card">
            <p style="font-size:40px;margin:0 0 10px;">📅</p>
            <h3 style="margin:0 0 6px;">Aucune réservation trouvée</h3>
            <p style="margin:0 0 16px;color:#6b7280;font-size:13px;">
                Commencez par ajouter votre première réservation.
            </p>
            <a href="reservation?action=ajout" class="btn-primary">➕ Ajouter une réservation</a>
        </section>

    <% } %>

</main>

</body>
</html>

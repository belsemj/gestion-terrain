<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.enit.entities.Reservation, java.time.format.DateTimeFormatter" %>
<%
    List<Reservation> reservations =
        (List<Reservation>) request.getAttribute("reservations");

    String mode = (String) request.getAttribute("mode");
    Integer mois = (Integer) request.getAttribute("mois");
    Integer annee = (Integer) request.getAttribute("annee");

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");

    int total = reservations != null ? reservations.size() : 0;
    int actives = 0;
    if (reservations != null) {
        java.time.LocalDate today = java.time.LocalDate.now();
        for (Reservation r : reservations) {
            if (r.getDateReservation() != null &&
                !r.getDateReservation().isBefore(today)) {
                actives++;
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Réservations par mois</title>
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

        .filter-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 12px 12px 10px;
            margin-bottom: 14px;
            box-shadow: 0 6px 20px rgba(15, 23, 42, 0.08);
        }

        .filter-title {
            margin: 0 0 8px;
            font-size: 14px;
            font-weight: 700;
            color: #374151;
        }

        .filter-form {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
        }

        .filter-form label {
            font-size: 13px;
            font-weight: 600;
            color: #6b7280;
        }

        .filter-form input {
            padding: 7px 9px;
            border-radius: 9px;
            border: 1px solid #d1d5db;
            font-size: 13px;
            width: 100px;
        }

        .filter-form button,
        .filter-form a {
            padding: 7px 12px;
            border-radius: 999px;
            border: none;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
        }

        .filter-form button {
            background: #2563eb;
            color: #ffffff;
        }

        .filter-form a {
            background: #e5e7eb;
            color: #374151;
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

        .time-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 999px;
            font-size: 12px;
            background: #fef9c3;
            color: #854d0e;
        }

        .client-name {
            font-weight: 700;
        }

        .terrain-name {
            font-weight: 700;
            color: #2563eb;
        }

        .terrain-type {
            font-size: 12px;
            color: #6b7280;
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
            .filter-form { flex-direction: column; align-items: stretch; }
            .filter-form input,
            .filter-form button,
            .filter-form a { width: 100%; }
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
            <span>Réservations par mois</span>
        </div>
    </div>
    <div class="app-header-right">
        <a href="home">🏠 Dashboard</a>
    </div>
</header>

<main class="app-main">

    <div class="page-head">
        <div class="page-title-block">
            <h2 class="page-title">Liste des réservations</h2>
            <p class="page-sub">
                Filtre par mois/année et visualisation des réservations.
            </p>
        </div>
        <a href="reservation?action=ajout" class="btn-primary">➕ Nouvelle réservation</a>
    </div>

    <% if (successMessage != null) { session.removeAttribute("successMessage"); %>
        <div class="alert alert-success"><%= successMessage %></div>
    <% } %>

    <% if (errorMessage != null) { session.removeAttribute("errorMessage"); %>
        <div class="alert alert-error"><%= errorMessage %></div>
    <% } %>

    <section class="filter-card">
        <h3 class="filter-title">Filtrer par mois</h3>
        <form class="filter-form" action="reservation" method="get">
            <input type="hidden" name="action" value="mois">

            <label>Mois :</label>
            <input type="number" name="mois" min="1" max="12"
                   value="<%= (mois != null ? mois : java.time.LocalDate.now().getMonthValue()) %>">

            <label>Année :</label>
            <input type="number" name="annee"
                   value="<%= (annee != null ? annee : java.time.LocalDate.now().getYear()) %>">

            <button type="submit">Filtrer</button>

            <% if ("mois".equals(mode)) { %>
                <a href="reservation?action=list">Voir toutes</a>
            <% } %>
        </form>
    </section>

    <section class="stats-grid">
        <div class="stat-card">
            <div class="stat-label">Total réservations</div>
            <div class="stat-value"><%= total %></div>
            <div class="stat-sub">dans la sélection</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">À venir</div>
            <div class="stat-value"><%= actives %></div>
            <div class="stat-sub">à partir d’aujourd’hui</div>
        </div>
    </section>

    <% if (reservations != null && !reservations.isEmpty()) { %>

        <section class="table-card">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Date</th>
                    <th>Début</th>
                    <th>Fin</th>
                    <th>Client</th>
                    <th>Terrain</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Reservation r : reservations) { %>
                    <tr>
                        <td>#<%= r.getIdReservation() %></td>
                        <td><%= r.getDateReservation().format(dateFormatter) %></td>
                        <td><span class="time-badge"><%= r.getHeureDebut().format(timeFormatter) %></span></td>
                        <td><span class="time-badge"><%= r.getHeureFin().format(timeFormatter) %></span></td>
                        <td><span class="client-name"><%= r.getClient().getNom() %></span></td>
                        <td>
                            <span class="terrain-name"><%= r.getTerrain().getNom() %></span>
                            <div class="terrain-type"><%= r.getTerrain().getType() %></div>
                        </td>
                        <td>
                            <div class="actions">
                                <a href="reservation?action=edit&id=<%= r.getIdReservation() %>"
                                   class="btn-action btn-edit">
                                    Modifier
                                </a>
                                <a href="reservation?action=delete&id=<%= r.getIdReservation() %>"
                                   class="btn-action btn-delete"
                                   onclick="return confirm('Supprimer cette réservation ?')">
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
            <p style="font-size:40px;margin:0 0 10px;">📭</p>
            <h3 style="margin:0 0 6px;">Aucune réservation trouvée</h3>
            <p style="margin:0 0 16px;color:#6b7280;font-size:13px;">
                <% if ("mois".equals(mode)) { %>
                    Aucune réservation pour <%= mois %>/<%= annee %>.
                <% } else { %>
                    Ajoutez une première réservation pour commencer le suivi.
                <% } %>
            </p>
            <a href="reservation?action=ajout" class="btn-primary">➕ Nouvelle réservation</a>
        </section>

    <% } %>

</main>

</body>
</html>

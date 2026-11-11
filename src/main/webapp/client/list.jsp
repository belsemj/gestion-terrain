<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.enit.entities.Client, java.text.SimpleDateFormat" %>
<%
    List<Client> clients = (List<Client>) request.getAttribute("clients");
    List<Object[]> montants = (List<Object[]>) request.getAttribute("montants");
    String mode = (String) request.getAttribute("mode");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Clients</title>
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
            background: #22c55e;
            color: #111827;
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

        .filters-bar {
            background: #ffffff;
            border-radius: 12px;
            padding: 10px 12px;
            margin-bottom: 12px;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 16px rgba(15, 23, 42, 0.07);
        }

        .filters-label {
            font-size: 13px;
            font-weight: 600;
            color: #374151;
        }

        .filter-btn {
            text-decoration: none;
            padding: 6px 11px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
            background: #eff6ff;
            color: #1d4ed8;
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

        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 999px;
            font-size: 11px;
        }

        .badge-amount {
            background: #dcfce7;
            color: #166534;
        }

        .badge-reservations {
            background: #eff6ff;
            color: #1d4ed8;
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
            background: #e0f2fe;
            color: #1d4ed8;
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
        }

        @media (max-width: 768px) {
            .page-head {
                flex-direction: column;
                align-items: flex-start;
            }
            .table-card {
                overflow-x: auto;
            }
            table {
                min-width: 800px;
            }
        }
    </style>
</head>
<body>

<header class="app-header">
    <div class="app-title">
        <div class="app-logo">👥</div>
        <div class="app-title-text">
            <h1>Gestion Sportive</h1>
            <span>Clients</span>
        </div>
    </div>
    <div class="app-header-right">
        <a href="home">🏠 Dashboard</a>
    </div>
</header>

<main class="app-main">

    <div class="page-head">
        <div class="page-title-block">
            <h2 class="page-title">Gestion des clients</h2>
            <p class="page-sub">Consultez et mettez à jour vos clients et montants.</p>
        </div>
        <a href="client?action=ajout" class="btn-primary">➕ Nouveau client</a>
    </div>

    <% if (successMessage != null) { session.removeAttribute("successMessage"); %>
        <div class="alert alert-success"><%= successMessage %></div>
    <% } %>

    <% if (errorMessage != null) { session.removeAttribute("errorMessage"); %>
        <div class="alert alert-error"><%= errorMessage %></div>
    <% } %>

    <section class="filters-bar">
        <span class="filters-label">Affichage :</span>
        <a href="client?action=list" class="filter-btn">Tous les clients</a>
        <a href="client?action=football" class="filter-btn">Clients football</a>
        <a href="client?action=montants" class="filter-btn">Montants (DT)</a>
    </section>

    <% if ("montants".equals(mode) && montants != null) { %>

        <section class="table-card">
            <table>
                <thead>
                <tr>
                    <th>Client</th>
                    <th>Total payé (DT)</th>
                </tr>
                </thead>
                <tbody>
                <% for (Object[] row : montants) { %>
                    <tr>
                        <td class="client-name"><%= row[0] %></td>
                        <td><span class="badge badge-amount"><%= row[1] %> DT</span></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </section>

    <% } else if (clients != null && !clients.isEmpty()) { %>

        <section class="table-card">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nom</th>
                    <th>Email</th>
                    <th>Téléphone</th>
                    <th>Date inscription</th>
                    <th>Réservations</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Client c : clients) {
                    int nb = c.getListReserv() != null ? c.getListReserv().size() : 0;
                %>
                    <tr>
                        <td>#<%= c.getIdClient() %></td>
                        <td class="client-name"><%= c.getNom() %></td>
                        <td><%= c.getEmail() %></td>
                        <td><%= c.getTelephone() != null ? c.getTelephone() : "—" %></td>
                        <td><%= c.getDateInscription() != null ? sdf.format(c.getDateInscription()) : "—" %></td>
                        <td>
                            <span class="badge badge-reservations">
                                <%= nb %> réservation<%= nb > 1 ? "s" : "" %>
                            </span>
                        </td>
                        <td>
                            <div class="actions">
                                <a class="btn-action btn-edit"
                                   href="client?action=edit&id=<%= c.getIdClient() %>">
                                    Modifier
                                </a>
                                <a class="btn-action btn-delete"
                                   href="client?action=delete&id=<%= c.getIdClient() %>"
                                   onclick="return confirm('Confirmer la suppression de <%= c.getNom() %> ?')">
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
            <h3 style="margin:0 0 6px;">Aucun client trouvé</h3>
            <p style="margin:0 0 16px;color:#6b7280;font-size:13px;">
                Ajoutez votre premier client pour commencer le suivi.
            </p>
            <a href="client?action=ajout" class="btn-primary">➕ Ajouter un client</a>
        </section>

    <% } %>

</main>

</body>
</html>

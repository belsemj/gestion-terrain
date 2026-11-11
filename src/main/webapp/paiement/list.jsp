<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.enit.entities.*, java.text.SimpleDateFormat, java.text.DecimalFormat" %>
<%
    List<Paiement> paiements = (List<Paiement>) request.getAttribute("paiements");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    DecimalFormat df = new DecimalFormat("#,##0.00");

    double totalMontant = 0;
    int paiementsCeMois = 0;

    if (paiements != null) {
        java.time.LocalDate maintenant = java.time.LocalDate.now();
        for (Paiement p : paiements) {
            totalMontant += p.getMontant();
            if (p.getDatePaiement() != null) {
                java.time.LocalDate datePaiement =
                    new java.sql.Date(p.getDatePaiement().getTime()).toLocalDate();
                if (datePaiement.getMonth() == maintenant.getMonth() &&
                    datePaiement.getYear() == maintenant.getYear()) {
                    paiementsCeMois++;
                }
            }
        }
    }

    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Paiements</title>
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

        .amount-value {
            font-weight: 700;
            color: #16a34a;
        }

        .mode-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 999px;
            font-size: 11px;
            background: #eff6ff;
            color: #1d4ed8;
        }

        .client-name {
            font-weight: 700;
        }

        .terrain-text {
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
            background: #e0f2fe;
            color: #1d4ed8;
        }

        .mode-select {
            padding: 4px 8px;
            border-radius: 999px;
            border: 1px solid #d1d5db;
            background: #f9fafb;
            font-size: 12px;
        }

        .empty-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 30px 20px;
            text-align: center;
            box-shadow: 0 6px 20px rgba(15, 23, 42, 0.08);
            margin-top: 10px;
        }

        .info-box {
            margin-top: 12px;
            padding: 10px 12px;
            background: #e5f2ff;
            border-radius: 9px;
            font-size: 12px;
            color: #1d4ed8;
        }

        .info-box a {
            color: #1d4ed8;
            font-weight: 600;
            text-decoration: none;
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
        <div class="app-logo">💰</div>
        <div class="app-title-text">
            <h1>Gestion Sportive</h1>
            <span>Paiements</span>
        </div>
    </div>
    <div class="app-header-right">
        <a href="home">🏠 Dashboard</a>
    </div>
</header>

<main class="app-main">

    <div class="page-head">
        <div class="page-title-block">
            <h2 class="page-title">Historique des paiements</h2>
            <p class="page-sub">Visualisez et mettez à jour les paiements liés aux réservations.</p>
        </div>
        <a href="paiement?action=ajout" class="btn-primary">➕ Nouveau paiement</a>
    </div>

    <% if (successMessage != null) { session.removeAttribute("successMessage"); %>
        <div class="alert alert-success"><%= successMessage %></div>
    <% } %>

    <% if (errorMessage != null) { session.removeAttribute("errorMessage"); %>
        <div class="alert alert-error"><%= errorMessage %></div>
    <% } %>

    <section class="stats-grid">
        <div class="stat-card">
            <div class="stat-label">Total paiements</div>
            <div class="stat-value"><%= paiements != null ? paiements.size() : 0 %></div>
            <div class="stat-sub">transactions</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Recettes totales (DT)</div>
            <div class="stat-value"><%= df.format(totalMontant) %></div>
            <div class="stat-sub">montant cumulé</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Ce mois</div>
            <div class="stat-value"><%= paiementsCeMois %></div>
            <div class="stat-sub">paiements enregistrés</div>
        </div>
    </section>

    <% if (paiements != null && !paiements.isEmpty()) { %>

        <section class="table-card">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Montant</th>
                    <th>Date</th>
                    <th>Mode</th>
                    <th>Réservation</th>
                    <th>Client</th>
                    <th>Terrain</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Paiement p : paiements) { %>
                    <tr>
                        <td>#<%= p.getIdPaiement() %></td>
                        <td><span class="amount-value"><%= df.format(p.getMontant()) %> DT</span></td>
                        <td>
                            <% if (p.getDatePaiement() != null) { %>
                                <%= sdf.format(p.getDatePaiement()) %>
                            <% } else { %>
                                N/A
                            <% } %>
                        </td>
                        <td>
                            <% if (p.getModePaiement() != null) {
                                   String icon = "💰";
                                   switch (p.getModePaiement()) {
                                       case "Carte": icon = "💳"; break;
                                       case "Espèces": icon = "💵"; break;
                                       case "Chèque": icon = "📝"; break;
                                       case "Virement": icon = "🏦"; break;
                                   }
                            %>
                                <span class="mode-badge"><%= icon %> <%= p.getModePaiement() %></span>
                            <% } else { %>
                                N/A
                            <% } %>
                        </td>
                        <td>
                            <% if (p.getReservation() != null) { %>
                                #<%= p.getReservation().getIdReservation() %>
                            <% } else { %>
                                N/A
                            <% } %>
                        </td>
                        <td>
                            <% if (p.getReservation() != null && p.getReservation().getClient() != null) { %>
                                <span class="client-name"><%= p.getReservation().getClient().getNom() %></span>
                            <% } else { %>
                                N/A
                            <% } %>
                        </td>
                        <td>
                            <% if (p.getReservation() != null && p.getReservation().getTerrain() != null) { %>
                                <span class="terrain-text"><%= p.getReservation().getTerrain().getNom() %></span>
                            <% } else { %>
                                N/A
                            <% } %>
                        </td>
                        <td>
                            <div class="actions">
                                <a href="paiement?action=edit&id=<%= p.getIdPaiement() %>" class="btn-action">
                                    Modifier
                                </a>
                                <form action="paiement" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="changerMode">
                                    <input type="hidden" name="id" value="<%= p.getIdPaiement() %>">
                                    <select name="mode" class="mode-select" onchange="this.form.submit()">
                                        <option value="">Changer mode</option>
                                        <option value="Carte">Carte</option>
                                        <option value="Espèces">Espèces</option>
                                        <option value="Chèque">Chèque</option>
                                        <option value="Virement">Virement</option>
                                    </select>
                                </form>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </section>

    <% } else { %>

        <section class="empty-card">
            <p style="font-size:40px;margin:0 0 10px;">💰</p>
            <h3 style="margin:0 0 6px;">Aucun paiement enregistré</h3>
            <p style="margin:0 0 16px;color:#6b7280;font-size:13px;">
                Ajoutez un premier paiement pour commencer le suivi.
            </p>
            <a href="paiement?action=ajout" class="btn-primary">➕ Ajouter un paiement</a>
        </section>

    <% } %>

    <section class="info-box">
        Pour voir les montants par client, consulte la page
        <a href="client?action=montants">Clients & Montants</a>.
    </section>

</main>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.enit.entities.Terrain" %>
<%
    List<Terrain> terrains = (List<Terrain>) request.getAttribute("terrains");
    List<Object[]> stats = (List<Object[]>) request.getAttribute("statsReservations");

    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Liste des Terrains</title>
    <meta charset="UTF-8">

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: "Inter", "Segoe UI", Arial, sans-serif;
            background: radial-gradient(circle at top left, #e0f2ff 0%, #e5edff 35%, #eef2ff 65%, #ffffff 100%);
            color: #0f172a;
            min-height: 100vh;
            padding-top: 80px;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            padding: 16px 32px;
            box-shadow: 0 10px 30px rgba(148, 163, 184, 0.35);
            border-bottom: 2px solid rgba(37, 99, 235, 0.4);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 50;
        }

        .header-content {
            max-width: 1600px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo-icon {
            font-size: 30px;
            padding: 6px 8px;
            border-radius: 14px;
            background: rgba(15, 23, 42, 0.85);
            color: #e5edff;
            box-shadow: 0 6px 16px rgba(15, 23, 42, 0.5);
        }

        .logo-text h1 {
            margin: 0;
            font-size: 20px;
            font-weight: 800;
            color: #1f2937;
        }

        .logo-text span {
            font-size: 11px;
            color: #6b7280;
        }

        .nav-home {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #2563eb 0%, #0ea5e9 80%);
            color: white;
            padding: 10px 20px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 4px 16px rgba(37, 99, 235, 0.5);
        }

        .nav-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 22px rgba(37, 99, 235, 0.7);
        }

        .container {
            max-width: 1600px;
            margin: 0 auto;
            padding: 28px 32px 40px;
        }

        .page-header {
            background: rgba(255, 255, 255, 0.98);
            padding: 24px 26px;
            border-radius: 22px;
            box-shadow: 0 18px 50px rgba(148, 163, 184, 0.35);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 24px;
        }

        .page-title-block {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .page-header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 900;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .page-header-sub {
            font-size: 13px;
            color: #6b7280;
        }

        .header-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 18px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.25s ease;
        }

        .btn-add {
            background: linear-gradient(135deg, #22c55e 0%, #16a34a 60%, #0ea5e9 100%);
            color: white;
            box-shadow: 0 8px 24px rgba(34, 197, 94, 0.6);
        }

        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(34, 197, 94, 0.8);
        }

        .btn-available {
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
        }

        .btn-available:hover {
            background: #dbeafe;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
        }

        .alert {
            padding: 14px 18px;
            border-radius: 16px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            animation: slideIn 0.25s ease;
            box-shadow: 0 8px 22px rgba(148, 163, 184, 0.35);
            font-size: 13px;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-6px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .alert-success {
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            color: #065f46;
            border-left: 4px solid #10b981;
        }

        .alert-error {
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            color: #991b1b;
            border-left: 4px solid #ef4444;
        }

        .table-container {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 18px 50px rgba(148, 163, 184, 0.35);
            margin-bottom: 24px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        thead {
            background: linear-gradient(135deg, #f9fafb 0%, #eef2ff 100%);
        }

        th {
            padding: 14px 16px;
            text-align: left;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.12em;
            color: #6b7280;
            font-weight: 800;
            border-bottom: 2px solid #e5e7eb;
        }

        td {
            padding: 14px 16px;
            border-bottom: 1px solid #eef2ff;
            color: #374151;
            font-weight: 500;
        }

        tbody tr {
            transition: all 0.25s ease;
        }

        tbody tr:hover {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.05) 0%, rgba(14, 165, 233, 0.05) 100%);
            transform: scale(1.005);
        }

        .terrain-name {
            font-weight: 800;
            color: #0f172a;
        }

        .badge-type {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
        }

        .action-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .btn-action {
            padding: 7px 12px;
            border-radius: 999px;
            font-size: 12px;
            text-decoration: none;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.25s ease;
        }

        .btn-edit {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #86efac;
        }

        .btn-edit:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(34, 197, 94, 0.6);
        }

        .btn-delete {
            background: #fee2e2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        .btn-delete:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(239, 68, 68, 0.6);
        }

        .empty-state {
            text-align: center;
            padding: 60px 30px;
            background: rgba(255, 255, 255, 0.98);
            border-radius: 20px;
            box-shadow: 0 18px 50px rgba(148, 163, 184, 0.35);
        }

        .empty-state-icon {
            font-size: 60px;
            margin-bottom: 16px;
        }

        .empty-state h3 {
            margin: 0 0 10px 0;
            font-size: 22px;
            color: #0f172a;
            font-weight: 800;
        }

        .empty-state p {
            margin: 0 0 18px 0;
            color: #6b7280;
            font-size: 14px;
        }

        .stats-section {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 20px;
            padding: 22px 24px 24px;
            box-shadow: 0 18px 50px rgba(148, 163, 184, 0.35);
        }

        .stats-section h2 {
            margin: 0 0 16px 0;
            font-size: 20px;
            font-weight: 900;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .stats-section table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .stats-section th,
        .stats-section td {
            padding: 10px 12px;
            border-bottom: 1px solid #eef2ff;
            text-align: left;
        }

        @media (max-width: 1000px) {
            .container { padding: 22px 16px 32px; }
        }

        @media (max-width: 768px) {
            .page-header { flex-direction: column; align-items: flex-start; }
            .header-actions { width: 100%; }
            .btn-pill { width: 100%; justify-content: center; }
            .table-container { overflow-x: auto; }
            table { min-width: 800px; }
        }
    </style>
</head>

<body>

<header class="header">
    <div class="header-content">
        <div class="logo">
            <span class="logo-icon">🏟️</span>
            <div class="logo-text">
                <h1>Gestion Sportive</h1>
                <span>Terrains • Réservations • Paiements</span>
            </div>
        </div>
        <a href="home" class="nav-home">
            🏠 Dashboard
        </a>
    </div>
</header>

<div class="container">

    <div class="page-header">
        <div class="page-title-block">
            <h1>
                <span>⚽</span>
                Liste des Terrains
            </h1>
            <div class="page-header-sub">
                Gérez vos terrains et consultez leurs statistiques de réservation.
            </div>
        </div>
        <div class="header-actions">
            <a href="terrain?action=ajout" class="btn-pill btn-add">
                ➕ Nouveau Terrain
            </a>
            <a href="terrain?action=nonReserves" class="btn-pill btn-available">
                ✅ Terrains disponibles
            </a>
        </div>
    </div>

    <% if (successMessage != null) { session.removeAttribute("successMessage"); %>
        <div class="alert alert-success">
            <span>✅</span>
            <%= successMessage %>
        </div>
    <% } %>

    <% if (errorMessage != null) { session.removeAttribute("errorMessage"); %>
        <div class="alert alert-error">
            <span>❌</span>
            <%= errorMessage %>
        </div>
    <% } %>

    <% if (terrains != null && !terrains.isEmpty()) { %>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>🆔 ID</th>
                        <th>🏟️ Nom</th>
                        <th>⚽ Type</th>
                        <th>👥 Capacité</th>
                        <th>📍 Localisation</th>
                        <th>⚙️ Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Terrain t : terrains) { %>
                    <tr>
                        <td><strong>#<%= t.getIdTerrain() %></strong></td>
                        <td class="terrain-name"><%= t.getNom() %></td>
                        <td><span class="badge-type"><%= t.getType() %></span></td>
                        <td><%= t.getCapacite() != null ? t.getCapacite() : "—" %></td>
                        <td><%= t.getLocalisation() != null ? t.getLocalisation() : "—" %></td>
                        <td>
                            <div class="action-buttons">
                                <a href="terrain?action=edit&id=<%= t.getIdTerrain() %>" class="btn-action btn-edit">
                                    ✏️ Modifier
                                </a>
                                <a href="terrain?action=confirmDelete&id=<%= t.getIdTerrain() %>"
                                   class="btn-action btn-delete">
                                    🗑️ Supprimer
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

    <% } else { %>

        <div class="empty-state">
            <div class="empty-state-icon">🏟️</div>
            <h3>Aucun terrain trouvé</h3>
            <p>Ajoutez votre premier terrain pour commencer à prendre des réservations.</p>
            <a href="terrain?action=ajout" class="btn-pill btn-add">
                ➕ Ajouter un Terrain
            </a>
        </div>

    <% } %>

    <% if (stats != null && !stats.isEmpty()) { %>
        <div class="stats-section" id="stats">
            <h2>
                <span>📊</span>
                Statistiques des réservations
            </h2>
            <table>
                <thead>
                    <tr>
                        <th>Terrain</th>
                        <th>Nombre de réservations</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Object[] stat : stats) { %>
                    <tr>
                        <td class="terrain-name"><%= stat[0] %></td>
                        <td><strong><%= stat[1] %></strong></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>

</div>

</body>
</html>

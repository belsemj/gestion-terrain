<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.enit.entities.Terrain" %>
<%
    List<Terrain> terrainsNonReserves =
        (List<Terrain>) request.getAttribute("terrainsNonReserves");
    int totalNonReserves = terrainsNonReserves != null ? terrainsNonReserves.size() : 0;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Terrains non réservés</title>
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

        /* HEADER type home.jsp */
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

        .logo-text {
            display: flex;
            flex-direction: column;
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

        /* PAGE */
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
            margin-bottom: 22px;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .page-header-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
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

        .breadcrumbs {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .breadcrumb-link {
            padding: 8px 14px;
            border-radius: 999px;
            background: #eff6ff;
            color: #1d4ed8;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            border: 1px solid #bfdbfe;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.25s ease;
        }

        .breadcrumb-link:hover {
            background: #dbeafe;
            transform: translateY(-1px);
        }

        .page-header-sub {
            font-size: 13px;
            color: #6b7280;
        }

        /* INFO CARD */
        .info-card {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 18px;
            padding: 18px 20px;
            box-shadow: 0 18px 50px rgba(148, 163, 184, 0.3);
            margin-bottom: 18px;
        }

        .info-card h2 {
            margin: 0 0 8px 0;
            font-size: 18px;
            font-weight: 800;
            color: #1d4ed8;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-card p {
            margin: 0;
            font-size: 13px;
            color: #1d4ed8;
        }

        /* STATS */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 18px;
            margin-bottom: 20px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 18px;
            padding: 18px 18px 16px;
            box-shadow: 0 18px 50px rgba(148, 163, 184, 0.35);
            border-top: 4px solid #22c55e;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .stat-icon {
            font-size: 20px;
            padding: 6px 8px;
            border-radius: 14px;
            background: #dcfce7;
            color: #166534;
            display: inline-block;
        }

        .stat-label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.12em;
            color: #6b7280;
            font-weight: 700;
        }

        .stat-number {
            font-size: 20px;
            font-weight: 900;
            color: #0f172a;
        }

        .stat-sub {
            font-size: 12px;
            color: #9ca3af;
        }

        .availability-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 999px;
            background: #dcfce7;
            color: #166534;
            font-size: 12px;
            font-weight: 700;
            border: 1px solid #86efac;
        }

        /* TABLE */
        .table-container {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 18px 50px rgba(148, 163, 184, 0.35);
            margin-bottom: 22px;
        }

        .table-header {
            padding: 18px 20px;
        }

        .table-header h2 {
            margin: 0;
            font-size: 18px;
            font-weight: 900;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 8px;
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
            padding: 12px 16px;
            text-align: left;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.12em;
            color: #6b7280;
            font-weight: 800;
            border-bottom: 2px solid #e5e7eb;
        }

        td {
            padding: 12px 16px;
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
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
        }

        .muted {
            color: #9ca3af;
            font-style: italic;
            font-size: 13px;
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

        .btn-reserve {
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
        }

        .btn-reserve:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(37, 99, 235, 0.5);
        }

        /* EMPTY STATE */
        .empty-state {
            text-align: center;
            padding: 60px 30px;
            background: rgba(255, 255, 255, 0.98);
            border-radius: 20px;
            box-shadow: 0 18px 50px rgba(148, 163, 184, 0.35);
            margin-bottom: 22px;
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
            margin: 4px 0;
            color: #6b7280;
            font-size: 14px;
        }

        .empty-state-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
            margin-top: 18px;
        }

        .btn-pill {
            padding: 10px 18px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.25s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #22c55e 0%, #16a34a 60%, #0ea5e9 100%);
            color: white;
            box-shadow: 0 8px 24px rgba(34, 197, 94, 0.6);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(34, 197, 94, 0.8);
        }

        .btn-secondary {
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
        }

        .btn-secondary:hover {
            background: #dbeafe;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
        }

        /* FOOTER TIP */
        .tip-card {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 18px;
            padding: 18px 20px;
            box-shadow: 0 18px 50px rgba(148, 163, 184, 0.3);
        }

        .tip-card h2 {
            margin: 0 0 8px 0;
            font-size: 16px;
            font-weight: 800;
            color: #065f46;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .tip-card p {
            margin: 0;
            font-size: 13px;
            color: #065f46;
        }

        .tip-card a {
            color: #065f46;
            font-weight: 700;
            text-decoration: none;
            border-bottom: 1px solid #10b981;
        }

        .tip-card a:hover {
            border-bottom-color: #065f46;
        }

        @media (max-width: 900px) {
            .container { padding: 22px 16px 32px; }
            .page-header { padding: 18px 16px; }
            .page-header-title { flex-direction: column; align-items: flex-start; }
            .breadcrumbs { width: 100%; }
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
        <div class="page-header-title">
            <h1>
                <span>✅</span>
                Terrains non réservés
            </h1>
            <div class="breadcrumbs">
                <a href="home" class="breadcrumb-link">🏠 Accueil</a>
                <a href="terrain?action=list" class="breadcrumb-link">📋 Tous les terrains</a>
                <a href="terrain?action=ajout" class="breadcrumb-link">➕ Ajouter un terrain</a>
            </div>
        </div>
        <div class="page-header-sub">
            Cette vue affiche uniquement les terrains qui n’ont encore jamais été réservés.
        </div>
    </div>

    <div class="info-card">
        <h2>ℹ️ Information</h2>
        <p>Les terrains listés ici sont immédiatement disponibles pour planifier de nouvelles réservations.</p>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon">🏟️</div>
            <div class="stat-label">Terrains disponibles</div>
            <div class="stat-number"><%= totalNonReserves %></div>
            <div class="stat-sub">sans aucune réservation enregistrée</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Statut</div>
            <div class="availability-pill">
                <span>🟢</span>
                Toujours disponibles
            </div>
            <div class="stat-sub">parfaits pour de nouvelles activités</div>
        </div>
    </div>

    <% if (terrainsNonReserves != null && !terrainsNonReserves.isEmpty()) { %>

        <div class="table-container">
            <div class="table-header">
                <h2>
                    <span>📋</span>
                    Liste des terrains non réservés
                </h2>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>🏟️ Terrain</th>
                        <th>⚽ Type</th>
                        <th>📍 Localisation</th>
                        <th>👥 Capacité</th>
                        <th>⚙️ Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Terrain t : terrainsNonReserves) { %>
                    <tr>
                        <td class="terrain-name"><%= t.getNom() %></td>
                        <td>
                            <span class="badge-type">
                                <%= t.getType() != null ? t.getType() : "Non spécifié" %>
                            </span>
                        </td>
                        <td>
                            <% if (t.getLocalisation() != null && !t.getLocalisation().isEmpty()) { %>
                                📍 <%= t.getLocalisation() %>
                            <% } else { %>
                                <span class="muted">Non spécifiée</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (t.getCapacite() != null) { %>
                                👥 <%= t.getCapacite() %> personnes
                            <% } else { %>
                                <span class="muted">Non spécifiée</span>
                            <% } %>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="terrain?action=edit&id=<%= t.getIdTerrain() %>"
                                   class="btn-action btn-edit">
                                    ✏️ Modifier
                                </a>
                                <a href="reservation?action=ajout&terrainId=<%= t.getIdTerrain() %>"
                                   class="btn-action btn-reserve">
                                    📅 Réserver
                                </a>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="tip-card">
            <h2>💡 Astuce</h2>
            <p>
                Vous pouvez aussi créer une réservation depuis la page
                <a href="reservation?action=ajout">Nouvelle réservation</a>
                puis sélectionner l’un de ces terrains disponibles.
            </p>
        </div>

    <% } else { %>

        <div class="empty-state">
            <div class="empty-state-icon">🎉</div>
            <h3>Aucun terrain non réservé</h3>
            <p>Tous vos terrains ont déjà été utilisés au moins une fois.</p>
            <p>Bonne nouvelle : vos installations sont très sollicitées.</p>
            <div class="empty-state-actions">
                <a href="terrain?action=ajout" class="btn-pill btn-primary">
                    ➕ Ajouter un nouveau terrain
                </a>
                <a href="terrain?action=list" class="btn-pill btn-secondary">
                    📋 Voir tous les terrains
                </a>
            </div>
        </div>

    <% } %>

</div>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.enit.entities.Terrain" %>
<%
    Terrain terrain = (Terrain) request.getAttribute("terrain");
    int nbReservations = (Integer) request.getAttribute("nbReservations");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Confirmer la suppression</title>
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
            max-width: 640px;
            margin: 32px auto;
            padding: 0 16px;
        }

        .confirm-card {
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.12);
            padding: 18px 18px 16px;
        }

        .confirm-title {
            font-size: 18px;
            font-weight: 700;
            margin: 0 0 6px;
            color: #b91c1c;
        }

        .confirm-sub {
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 12px;
        }

        .warn-box {
            background: #fef2f2;
            border-radius: 9px;
            padding: 10px 11px;
            border-left: 4px solid #ef4444;
            margin-bottom: 10px;
            font-size: 13px;
            color: #7f1d1d;
        }

        .info-box {
            background: #eff6ff;
            border-radius: 9px;
            padding: 10px 11px;
            border-left: 4px solid #2563eb;
            font-size: 13px;
            color: #1d4ed8;
            margin-bottom: 12px;
        }

        .info-box ul {
            margin: 6px 0 0 18px;
            padding: 0;
        }

        .danger-text {
            font-size: 13px;
            color: #92400e;
            background: #fffbeb;
            border-radius: 9px;
            border: 1px solid #fbbf24;
            padding: 8px 10px;
            margin-bottom: 14px;
            text-align: center;
        }

        .actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 8px;
        }

        .btn {
            border: none;
            border-radius: 999px;
            padding: 8px 14px;
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

        .btn-danger {
            background: #ef4444;
            color: #f9fafb;
        }

        @media (max-width: 640px) {
            .actions {
                flex-direction: column-reverse;
                align-items: stretch;
            }
        }
    </style>
</head>
<body>

<header class="app-header">
    <div class="app-title">
        <div class="app-logo">🏟️</div>
        <div class="app-title-text">
            <h1>Gestion Sportive</h1>
            <span>Terrains</span>
        </div>
    </div>
    <div class="app-header-right">
        <a href="home">🏠 Dashboard</a>
    </div>
</header>

<main class="app-main">
    <section class="confirm-card">
        <h2 class="confirm-title">Confirmer la suppression</h2>
        <p class="confirm-sub">
            Terrain concerné : "<%= terrain.getNom() %>".
        </p>

        <div class="warn-box">
            Ce terrain possède <strong><%= nbReservations %> réservation(s)</strong> associée(s).
        </div>

        <div class="info-box">
            La suppression de ce terrain entraînera aussi la suppression :
            <ul>
                <li>des réservations liées à ce terrain</li>
                <li>des paiements associés à ces réservations</li>
            </ul>
        </div>

        <div class="danger-text">
            Cette action est définitive. Aucune récupération ne sera possible.
        </div>

        <div class="actions">
            <a href="terrain?action=list" class="btn btn-secondary">Annuler</a>
            <form action="terrain" method="post" style="display:inline;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%= terrain.getIdTerrain() %>">
                <button type="submit" class="btn btn-danger">
                    Supprimer le terrain
                </button>
            </form>
        </div>
    </section>
</main>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion des Terrains</title>
    <meta charset="UTF-8">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Inter", "Segoe UI", Arial, sans-serif;
            background: #f3f4f6;
            color: #111827;
        }

        /* BARRE DU HAUT */
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

        .app-header-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .currency-pill {
            padding: 6px 10px;
            border-radius: 999px;
            background: #f97316;
            color: #111827;
            font-size: 12px;
            font-weight: 700;
        }

        /* CONTENEUR GLOBAL */
        .app-main {
            max-width: 1120px;
            margin: 24px auto 32px;
            padding: 0 16px;
        }

        /* SECTION INTRO */
        .intro-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 18px 18px 16px;
            box-shadow: 0 8px 20px rgba(15, 23, 42, 0.08);
            margin-bottom: 18px;
        }

        .intro-title {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .intro-sub {
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 14px;
        }

        .intro-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .btn-primary,
        .btn-ghost {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 12px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
        }

        .btn-primary {
            background: #2563eb;
            color: #ffffff;
        }

        .btn-ghost {
            background: #eff6ff;
            color: #1d4ed8;
        }

        /* GRILLE 2 COLONNES */
        .layout-grid {
            display: grid;
            grid-template-columns: 2fr 1.1fr;
            gap: 16px;
            margin-bottom: 18px;
        }

        /* CARTE RESUMÉ GAUCHE */
        .overview-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 16px 16px 14px;
            box-shadow: 0 8px 20px rgba(15, 23, 42, 0.06);
        }

        .overview-title {
            font-size: 15px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .overview-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .overview-tag {
            padding: 4px 8px;
            border-radius: 999px;
            background: #eef2ff;
            color: #4338ca;
            font-size: 12px;
            font-weight: 600;
        }

        /* CARTES STATIQUES DROITE */
        .side-stack {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .small-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 10px 12px;
            box-shadow: 0 8px 18px rgba(15, 23, 42, 0.05);
            font-size: 13px;
        }

        .small-card-title {
            font-weight: 700;
            margin-bottom: 4px;
        }

        /* SECTION NAVIGATION PRINCIPALE */
        .section-title {
            font-size: 14px;
            font-weight: 700;
            color: #4b5563;
            margin: 18px 0 8px;
        }

        .nav-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px;
        }

        .nav-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 12px 12px 10px;
            box-shadow: 0 8px 20px rgba(15, 23, 42, 0.05);
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .nav-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-head-left {
            display: flex;
            flex-direction: column;
        }

        .nav-head-title {
            font-size: 14px;
            font-weight: 700;
        }

        .nav-head-sub {
            font-size: 11px;
            color: #9ca3af;
        }

        .nav-badge {
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 999px;
            background: #ecfeff;
            color: #0f766e;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .nav-links {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .nav-links a {
            font-size: 13px;
            text-decoration: none;
            color: #374151;
            padding: 6px 7px;
            border-radius: 8px;
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            transition: background 0.15s ease, color 0.15s ease, border-color 0.15s ease;
        }

        .nav-links a:hover {
            background: #2563eb;
            color: #ffffff;
            border-color: #1d4ed8;
        }

        /* SECTION ACTIONS RAPIDES / RAPPORTS */
        .bottom-grid {
            display: grid;
            grid-template-columns: 1.4fr 1fr;
            gap: 14px;
            margin-top: 18px;
        }

        .quick-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 12px 14px;
            box-shadow: 0 8px 20px rgba(15, 23, 42, 0.06);
        }

        .quick-title {
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .quick-sub {
            font-size: 12px;
            color: #6b7280;
            margin-bottom: 10px;
        }

        .quick-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 8px;
        }

        .quick-btn {
            text-decoration: none;
            font-size: 13px;
            padding: 7px 4px;
            border-radius: 9px;
            text-align: center;
            color: #ffffff;
            background: #16a34a;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 4px;
        }

        .report-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 12px 14px;
            box-shadow: 0 8px 20px rgba(15, 23, 42, 0.06);
        }

        .report-links {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-top: 6px;
        }

        .report-link {
            text-decoration: none;
            font-size: 13px;
            padding: 7px 9px;
            border-radius: 9px;
            color: #111827;
            background: #fef3c7;
            font-weight: 600;
        }

        /* RESPONSIVE */
        @media (max-width: 980px) {
            .layout-grid {
                grid-template-columns: 1fr;
            }
            .nav-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
            .bottom-grid {
                grid-template-columns: 1fr;
            }
            .quick-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 700px) {
            .nav-grid {
                grid-template-columns: 1fr;
            }
            .quick-grid {
                grid-template-columns: 1fr;
            }
            .app-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
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
            <span>Tableau de bord</span>
        </div>
    </div>
    <div class="app-header-right">
        <div class="currency-pill">DT - Dinar Tunisien</div>
    </div>
</header>

<main class="app-main">

    <!-- INTRO -->
    <section class="intro-card">
        <div class="intro-title">Bienvenue sur votre tableau de bord</div>
        <div class="intro-sub">
            Gérez vos terrains, réservations, clients et paiements depuis une interface claire et épurée.
        </div>
        <div class="intro-actions">
            <a href="reservation?action=ajout" class="btn-primary">➕ Nouvelle réservation</a>
            <a href="terrain?action=nonReserves" class="btn-ghost">✅ Terrains disponibles</a>
        </div>
    </section>

    <!-- APERÇU + PETITES CARTES -->
    <section class="layout-grid">
        <article class="overview-card">
            <div class="overview-title">Vue d’ensemble</div>
            <p style="font-size:13px;color:#6b7280;margin-bottom:10px;">
                Accédez rapidement aux sections clés de votre activité sportive.
            </p>
            <div class="overview-tags">
                <span class="overview-tag">Terrains ⚽</span>
                <span class="overview-tag">Clients 👥</span>
                <span class="overview-tag">Réservations 📅</span>
                <span class="overview-tag">Paiements 💰</span>
            </div>
        </article>

        <aside class="side-stack">
            <div class="small-card">
                <div class="small-card-title">Terrains</div>
                <div>Consultez la liste, les créneaux libres et ajoutez de nouveaux terrains.</div>
            </div>
            <div class="small-card">
                <div class="small-card-title">Clients</div>
                <div>Suivez vos clients, leurs réservations et leurs règlements.</div>
            </div>
        </aside>
    </section>

    <!-- NAVIGATION PRINCIPALE -->
    <section>
        <div class="section-title">Navigation principale</div>
        <div class="nav-grid">
            <!-- Terrains -->
            <article class="nav-card">
                <div class="nav-head">
                    <div class="nav-head-left">
                        <span class="nav-head-title">Terrains</span>
                        <span class="nav-head-sub">Gestion des terrains</span>
                    </div>
                    <span class="nav-badge">Gestion</span>
                </div>
                <div class="nav-links">
                    <a href="terrain?action=list">📋 Liste des terrains</a>
                    <a href="terrain?action=nonReserves">✅ Terrains disponibles</a>
                    <a href="terrain?action=ajout">➕ Ajouter terrain</a>
                </div>
            </article>

            <!-- Réservations -->
            <article class="nav-card">
                <div class="nav-head">
                    <div class="nav-head-left">
                        <span class="nav-head-title">Réservations</span>
                        <span class="nav-head-sub">Planning des créneaux</span>
                    </div>
                    <span class="nav-badge">Planning</span>
                </div>
                <div class="nav-links">
                    <a href="reservation?action=list">📋 Toutes les réservations</a>
                    <a href="reservation?action=ajout">➕ Nouvelle réservation</a>
                    <a href="reservation?action=mois&mois=<%= java.time.LocalDate.now().getMonthValue() %>&annee=<%= java.time.LocalDate.now().getYear() %>">
                        📆 Mois courant
                    </a>
                </div>
            </article>

            <!-- Clients & Paiements -->
            <article class="nav-card">
                <div class="nav-head">
                    <div class="nav-head-left">
                        <span class="nav-head-title">Clients & Paiements</span>
                        <span class="nav-head-sub">Suivi financier</span>
                    </div>
                    <span class="nav-badge">Suivi</span>
                </div>
                <div class="nav-links">
                    <a href="client?action=list">📋 Liste clients</a>
                    <a href="client?action=ajout">➕ Ajouter client</a>
                    <a href="client?action=football">⚽ Clients football</a>
                    <a href="client?action=montants">💵 Montants (DT)</a>
                    <a href="paiement?action=list">📄 Liste paiements</a>
                    <a href="paiement?action=ajout">➕ Ajouter paiement</a>
                </div>
            </article>
        </div>
    </section>

    <!-- ACTIONS RAPIDES & RAPPORTS -->
    <section class="bottom-grid">
        <article class="quick-card">
            <div class="quick-title">Actions rapides</div>
            <div class="quick-sub">Créez les éléments les plus utilisés en un clic.</div>
            <div class="quick-grid">
                <a href="terrain?action=ajout" class="quick-btn">➕ Terrain</a>
                <a href="client?action=ajout" class="quick-btn">👤 Client</a>
                <a href="reservation?action=ajout" class="quick-btn">📅 Réservation</a>
                <a href="paiement?action=ajout" class="quick-btn">💰 Paiement</a>
            </div>
        </article>

        <article class="report-card">
            <div class="quick-title">Rapports & statistiques</div>
            <div class="quick-sub">Analysez les performances et les montants encaissés.</div>
            <div class="report-links">
                <a href="terrain?action=list#stats" class="report-link">
                    Statistiques par terrain
                </a>
                <a href="client?action=montants" class="report-link">
                    Total paiements (DT)
                </a>
            </div>
        </article>
    </section>

</main>

</body>
</html>

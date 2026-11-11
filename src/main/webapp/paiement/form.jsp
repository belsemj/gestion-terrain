<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.enit.entities.*, java.text.SimpleDateFormat" %>
<%
    Paiement paiement = (Paiement) request.getAttribute("paiement");
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");

    boolean isEdit = paiement != null;
    String action = isEdit ? "modifier" : "ajouter";
    String title = isEdit ? "Modifier un paiement" : "Nouveau paiement";

    String montantValue = "";
    if (isEdit && paiement.getMontant() != 0) {
        montantValue = String.format(java.util.Locale.US, "%.2f", paiement.getMontant());
    }
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

        /* HEADER type home.jsp simplifié */
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

        input, select {
            padding: 9px 11px;
            border-radius: 9px;
            border: 1px solid #d1d5db;
            font-size: 14px;
            background: #f9fafb;
            color: #111827;
        }

        input:focus, select:focus {
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
    <section class="form-card">
        <div class="form-header">
            <h2 class="form-title"><%= title %></h2>
            <p class="form-sub">
                Associez un paiement à une réservation et renseignez les informations nécessaires.
            </p>
        </div>

        <form action="paiement" method="post">
            <% if (isEdit) { %>
                <input type="hidden" name="id" value="<%= paiement.getIdPaiement() %>">
            <% } %>
            <input type="hidden" name="action" value="<%= action %>">

            <div class="form-grid">
                <div class="info-line">
                    Les champs marqués d’un <span class="required">*</span> sont obligatoires.
                </div>

                <div class="form-group">
                    <label for="montant">
                        Montant (DT)<span class="required">*</span>
                    </label>
                    <input type="number" id="montant" name="montant"
                           value="<%= montantValue %>"
                           min="0" step="0.01" required>
                </div>

                <div class="form-group">
                    <label for="datePaiement">
                        Date de paiement<span class="required">*</span>
                    </label>
                    <input type="date" id="datePaiement" name="datePaiement"
                           value="<%= isEdit && paiement.getDatePaiement() != null
                                   ? new java.sql.Date(paiement.getDatePaiement().getTime()).toLocalDate().toString()
                                   : java.time.LocalDate.now().toString() %>"
                           required>
                </div>

                <div class="form-group">
                    <label for="modePaiement">
                        Mode de paiement<span class="required">*</span>
                    </label>
                    <select id="modePaiement" name="modePaiement" required>
                        <option value="">-- Sélectionner --</option>
                        <option value="Carte"   <%= isEdit && "Carte".equals(paiement.getModePaiement()) ? "selected" : "" %>>Carte</option>
                        <option value="Espèces" <%= isEdit && "Espèces".equals(paiement.getModePaiement()) ? "selected" : "" %>>Espèces</option>
                        <option value="Chèque"  <%= isEdit && "Chèque".equals(paiement.getModePaiement()) ? "selected" : "" %>>Chèque</option>
                        <option value="Virement"<%= isEdit && "Virement".equals(paiement.getModePaiement()) ? "selected" : "" %>>Virement</option>
                    </select>
                </div>

                <div class="form-group full-width">
                    <label for="reservationId">
                        Réservation liée<span class="required">*</span>
                    </label>
                    <select id="reservationId" name="reservationId" required <%= isEdit ? "disabled" : "" %>>
                        <option value="">-- Sélectionner une réservation --</option>
                        <% if (reservations != null) {
                               for (Reservation r : reservations) {
                                   boolean selected = isEdit && paiement.getReservation() != null &&
                                           paiement.getReservation().getIdReservation() == r.getIdReservation();
                                   if (selected || r.getPaiement() == null) {
                        %>
                            <option value="<%= r.getIdReservation() %>" <%= selected ? "selected" : "" %>>
                                #<%= r.getIdReservation() %> - <%= r.getClient().getNom() %> • <%= r.getTerrain().getNom() %>
                            </option>
                        <%         }
                               }
                           } %>
                    </select>
                    <% if (isEdit && paiement.getReservation() != null) { %>
                        <input type="hidden" name="reservationId"
                               value="<%= paiement.getReservation().getIdReservation() %>">
                    <% } %>
                </div>
            </div>

            <div class="form-actions">
                <a href="paiement?action=list" class="btn btn-secondary">Annuler</a>
                <button type="submit" class="btn btn-primary">
                    <%= isEdit ? "Enregistrer" : "Ajouter le paiement" %>
                </button>
            </div>
        </form>
    </section>
</main>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate — My Earnings</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>

<nav class="navbar navbar-driver">
  <div class="navbar-brand">
    <span class="logo-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="2.5" fill="currentColor"/><line x1="12" y1="9.5" x2="12" y2="3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="14.17" y1="13.25" x2="19.79" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="9.83" y1="13.25" x2="4.21" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></span>
    <span class="logo-text">SteerMate</span>
  </div>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/driver/dashboard" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/driver/earnings"  class="nav-link active">Earnings</a>
    <a href="${pageContext.request.contextPath}/driver/profile"   class="nav-link">Profile</a>
  </div>
  <div class="navbar-user">
    <div class="nav-avatar nav-avatar-driver">${fn:substring(sessionScope.loggedUser.name,0,1)}</div>
    <div class="nav-user-info">
      <div class="nav-user-name">${sessionScope.loggedUser.name}</div>
      <div class="nav-user-role">Driver</div>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="btn-nav-logout">Logout</a>
  </div>
</nav>

<main class="main-content">
  <div class="page-header">
    <div>
      <h1 class="page-title">My Earnings</h1>
      <p class="page-subtitle">${sessionScope.loggedUser.email}</p>
      <span class="role-banner role-banner-driver"><span class="role-banner-dot"></span>Driver</span>
    </div>
  </div>

  <div class="stats-grid stats-grid-2">
    <div class="stat-card stat-green">
      <div class="stat-icon">&#128176;</div>
      <div class="stat-info">
        <div class="stat-value">Rs. <fmt:formatNumber value="${earningsToday}" pattern="#,##0.00"/></div>
        <div class="stat-label">Today's Net Earnings</div>
      </div>
    </div>
    <div class="stat-card stat-orange">
      <div class="stat-icon">&#11088;</div>
      <div class="stat-info">
        <div class="stat-value">
          ${not empty profile ? profile.rating : '0.00'}
          <span style="font-size:1rem;font-weight:400;color:var(--text-muted)">
            / ${not empty profile ? profile.totalTrips : 0} trips
          </span>
        </div>
        <div class="stat-label">Rating &amp; Trip Count</div>
      </div>
    </div>
  </div>

  <div class="card">
    <div class="card-header">
      <h2 class="card-title">Trip History</h2>
    </div>
    <div class="table-responsive">
      <table class="data-table">
        <thead>
          <tr>
            <th>Trip ID</th>
            <th>Car Owner</th>
            <th>From</th>
            <th>To</th>
            <th>Status</th>
            <th>Gross Fare</th>
            <th>Platform Fee (15%)</th>
            <th>Net Earnings</th>
            <th>Date</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty trips}">
              <tr><td colspan="9" class="table-empty">No trips yet.</td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="trip" items="${trips}">
              <tr>
                <td><strong>${trip.tripId}</strong></td>
                <td>${trip.ownerName}</td>
                <td class="text-truncate">${trip.pickupLocation}</td>
                <td class="text-truncate">${trip.dropoffLocation}</td>
                <td><span class="badge badge-${trip.tripStatus.name().toLowerCase().replace('_','-')}">${trip.tripStatus.name().replace('_',' ')}</span></td>
                <td class="text-nowrap">Rs. <fmt:formatNumber value="${trip.totalFare}" pattern="#,##0.00"/></td>
                <td class="text-nowrap text-muted">Rs. <fmt:formatNumber value="${trip.platformFee}" pattern="#,##0.00"/></td>
                <td class="text-nowrap"><strong>Rs. <fmt:formatNumber value="${trip.driverEarnings}" pattern="#,##0.00"/></strong></td>
                <td class="text-nowrap text-muted">
                  ${fn:replace(fn:substring(trip.createdAt, 0, 16), 'T', ' ')}
                </td>
              </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </div>
</main>

</body>
</html>

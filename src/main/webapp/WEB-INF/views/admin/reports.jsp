<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate — Reports &amp; Analytics</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>

<nav class="navbar navbar-admin">
  <div class="navbar-brand">
    <span class="logo-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="2.5" fill="currentColor"/><line x1="12" y1="9.5" x2="12" y2="3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="14.17" y1="13.25" x2="19.79" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="9.83" y1="13.25" x2="4.21" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></span>
    <span class="logo-text">SteerMate</span>
  </div>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/users"     class="nav-link">Users</a>
    <a href="${pageContext.request.contextPath}/admin/drivers"   class="nav-link">Drivers</a>
    <a href="${pageContext.request.contextPath}/admin/trips"     class="nav-link">Trips</a>
    <a href="${pageContext.request.contextPath}/admin/reports"   class="nav-link active">Reports</a>
  </div>
  <div class="navbar-user">
    <div class="nav-avatar nav-avatar-admin">${fn:substring(sessionScope.loggedUser.name,0,1)}</div>
    <div class="nav-user-info">
      <div class="nav-user-name">${sessionScope.loggedUser.name}</div>
      <div class="nav-user-role">Administrator</div>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="btn-nav-logout">Logout</a>
  </div>
</nav>

<main class="main-content">
  <div class="page-header">
    <div>
      <h1 class="page-title">Reports &amp; Analytics</h1>
      <p class="page-subtitle">Platform performance overview and key metrics.</p>
    </div>
  </div>

  <%-- Summary Stats --%>
  <div class="stats-grid stats-grid-4">
    <div class="stat-card stat-blue">
      <div class="stat-icon">&#128101;</div>
      <div class="stat-info">
        <div class="stat-value">${stats.totalOwners}</div>
        <div class="stat-label">Total Car Owners</div>
      </div>
    </div>
    <div class="stat-card stat-green">
      <div class="stat-icon">&#128663;</div>
      <div class="stat-info">
        <div class="stat-value">${stats.approvedDrivers}</div>
        <div class="stat-label">Approved Drivers</div>
      </div>
    </div>
    <div class="stat-card stat-orange">
      <div class="stat-icon">&#128197;</div>
      <div class="stat-info">
        <div class="stat-value">${stats.activeTrips}</div>
        <div class="stat-label">Active Trips (Live)</div>
      </div>
    </div>
    <div class="stat-card stat-purple">
      <div class="stat-icon">&#128176;</div>
      <div class="stat-info">
        <div class="stat-value">Rs. <fmt:formatNumber value="${stats.todayRevenue}" pattern="#,##0"/></div>
        <div class="stat-label">Today's Revenue</div>
      </div>
    </div>
  </div>

  <div class="reports-grid">

    <%-- Trip Status Breakdown --%>
    <div class="card report-section">
      <div class="card-header">
        <h2 class="card-title">Trip Status Breakdown</h2>
      </div>
      <c:set var="totalTripsCount" value="0"/>
      <c:forEach var="entry" items="${statusBreakdown}">
        <c:set var="totalTripsCount" value="${totalTripsCount + entry.value}"/>
      </c:forEach>
      <c:choose>
        <c:when test="${not empty statusBreakdown}">
          <c:forEach var="entry" items="${statusBreakdown}">
            <c:set var="pct" value="${totalTripsCount > 0 ? (entry.value * 100 / totalTripsCount) : 0}"/>
            <div class="stat-bar-row">
              <div class="stat-bar-label">
                <span class="badge badge-${fn:toLowerCase(fn:replace(entry.key,'_','-'))}">${fn:replace(entry.key,'_',' ')}</span>
              </div>
              <div class="stat-bar-track">
                <div class="stat-bar-fill stat-bar-fill-${fn:toLowerCase(fn:replace(entry.key,'_','-'))}"
                     style="width:${pct}%"></div>
              </div>
              <div class="stat-bar-count">${entry.value} (<fmt:formatNumber value="${pct}" pattern="0"/>%)</div>
            </div>
          </c:forEach>
          <div class="report-total">Total: ${totalTripsCount} trips</div>
        </c:when>
        <c:otherwise>
          <p class="text-muted">No trip data available.</p>
        </c:otherwise>
      </c:choose>
    </div>

    <%-- Vehicle Type Breakdown --%>
    <div class="card report-section">
      <div class="card-header">
        <h2 class="card-title">Vehicle Type Usage</h2>
      </div>
      <c:set var="totalVehicleTrips" value="0"/>
      <c:forEach var="entry" items="${vehicleBreakdown}">
        <c:set var="totalVehicleTrips" value="${totalVehicleTrips + entry.value}"/>
      </c:forEach>
      <c:choose>
        <c:when test="${not empty vehicleBreakdown}">
          <c:forEach var="entry" items="${vehicleBreakdown}">
            <c:set var="pct" value="${totalVehicleTrips > 0 ? (entry.value * 100 / totalVehicleTrips) : 0}"/>
            <div class="stat-bar-row">
              <div class="stat-bar-label"><strong>${entry.key}</strong></div>
              <div class="stat-bar-track">
                <div class="stat-bar-fill stat-bar-fill-info" style="width:${pct}%"></div>
              </div>
              <div class="stat-bar-count">${entry.value} trip(s)</div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <p class="text-muted">No vehicle data available.</p>
        </c:otherwise>
      </c:choose>
    </div>

  </div><%-- /reports-grid --%>

  <%-- Top Drivers --%>
  <div class="card report-section">
    <div class="card-header">
      <h2 class="card-title">Top Drivers by Trip Count</h2>
    </div>
    <c:choose>
      <c:when test="${not empty topDrivers}">
        <div class="table-responsive">
          <table class="data-table">
            <thead>
              <tr>
                <th>Rank</th>
                <th>Driver Name</th>
                <th>License</th>
                <th>Experience</th>
                <th>Rating</th>
                <th>Total Trips</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="dp" items="${topDrivers}" varStatus="s">
              <tr>
                <td><strong>#${s.index + 1}</strong></td>
                <td>
                  <div class="driver-mini">
                    <div class="driver-mini-avatar">${fn:substring(dp.driverName,0,1)}</div>
                    ${dp.driverName}
                  </div>
                </td>
                <td>${dp.licenseNumber}</td>
                <td>${dp.experienceYears} yr(s)</td>
                <td><span class="rating-star">&#9733;</span> ${dp.rating}</td>
                <td><strong>${dp.totalTrips}</strong></td>
              </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </c:when>
      <c:otherwise>
        <p class="text-muted">No driver data available.</p>
      </c:otherwise>
    </c:choose>
  </div>

  <%-- Revenue Last 7 Days --%>
  <div class="card report-section">
    <div class="card-header">
      <h2 class="card-title">Revenue — Last 7 Days</h2>
    </div>
    <c:choose>
      <c:when test="${not empty revenueLastNDays}">
        <div class="table-responsive">
          <table class="data-table">
            <thead>
              <tr>
                <th>Date</th>
                <th>Completed Trips</th>
                <th>Total Revenue</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="row" items="${revenueLastNDays}">
              <tr>
                <td>${row[0]}</td>
                <td>${row[2]}</td>
                <td class="text-nowrap"><strong>Rs. <fmt:formatNumber value="${row[1]}" pattern="#,##0.00"/></strong></td>
              </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </c:when>
      <c:otherwise>
        <p class="text-muted">No completed trips in the last 7 days.</p>
      </c:otherwise>
    </c:choose>
  </div>

</main>

</body>
</html>

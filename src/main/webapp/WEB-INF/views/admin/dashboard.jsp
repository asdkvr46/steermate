<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate Admin — Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>

<nav class="navbar navbar-admin">
  <div class="navbar-brand">
    <span class="logo-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="2.5" fill="currentColor"/><line x1="12" y1="9.5" x2="12" y2="3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="14.17" y1="13.25" x2="19.79" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="9.83" y1="13.25" x2="4.21" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></span>
    <span class="logo-text">SteerMate</span>
  </div>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active">Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/users"    class="nav-link">Users</a>
    <a href="${pageContext.request.contextPath}/admin/drivers"  class="nav-link">Drivers</a>
    <a href="${pageContext.request.contextPath}/admin/trips"    class="nav-link">Trips</a>
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
      <h1 class="page-title">System Overview</h1>
      <p class="page-subtitle">Monitoring all platform activity</p>
      <span class="role-banner role-banner-admin"><span class="role-banner-dot"></span>Administrator</span>
    </div>
  </div>

  <!-- Stats Cards -->
  <div class="stats-grid">
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
      <div class="stat-icon">&#128205;</div>
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

  <!-- Live Trip Monitoring -->
  <div class="card">
    <div class="card-header">
      <h2 class="card-title">&#128994; Live Trip Monitoring</h2>
      <a href="${pageContext.request.contextPath}/admin/trips" class="btn btn-sm btn-secondary">View All Trips</a>
    </div>
    <div class="table-responsive">
      <table class="data-table">
        <thead>
          <tr>
            <th>Trip ID</th>
            <th>Car Owner</th>
            <th>Assigned Driver</th>
            <th>Vehicle</th>
            <th>Status</th>
            <th>Est. Fare</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty activeTrips}">
              <tr><td colspan="7" class="table-empty">&#128205; No active trips at this moment.</td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="trip" items="${activeTrips}">
              <tr>
                <td><strong>${trip.tripId}</strong></td>
                <td>${trip.ownerName}</td>
                <td>
                  <c:choose>
                    <c:when test="${not empty trip.driverName}">${trip.driverName}</c:when>
                    <c:otherwise><span class="text-muted">Searching...</span></c:otherwise>
                  </c:choose>
                </td>
                <td>${trip.vehiclePlate}</td>
                <td>
                  <span class="badge badge-${trip.tripStatus.name().toLowerCase().replace('_','-')}">
                    ${trip.tripStatus.name().replace('_',' ')}
                  </span>
                </td>
                <td class="text-nowrap">Rs. <fmt:formatNumber value="${trip.totalFare}" pattern="#,##0.00"/></td>
                <td>
                  <form method="post" action="${pageContext.request.contextPath}/admin/trips" style="display:inline">
                    <input type="hidden" name="id" value="${trip.id}">
                    <input type="hidden" name="status" value="CANCELLED">
                    <button type="submit" class="btn btn-xs btn-danger"
                            onclick="return confirm('Cancel this trip?')">Cancel</button>
                  </form>
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

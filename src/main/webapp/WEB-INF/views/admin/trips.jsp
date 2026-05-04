<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate Admin — Trips</title>
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
    <a href="${pageContext.request.contextPath}/admin/users"    class="nav-link">Users</a>
    <a href="${pageContext.request.contextPath}/admin/drivers"  class="nav-link">Drivers</a>
    <a href="${pageContext.request.contextPath}/admin/trips"    class="nav-link active">Trips</a>
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
      <h1 class="page-title">All Trips</h1>
      <p class="page-subtitle">Full trip history across the platform</p>
      <span class="role-banner role-banner-admin"><span class="role-banner-dot"></span>Administrator</span>
    </div>
  </div>

  <c:if test="${not empty param.msg}">
    <div class="alert alert-success">Trip updated successfully.</div>
  </c:if>

  <div class="card">
    <div class="table-responsive">
      <table class="data-table">
        <thead>
          <tr>
            <th>Trip ID</th>
            <th>Car Owner</th>
            <th>Driver</th>
            <th>Vehicle</th>
            <th>Pickup</th>
            <th>Dropoff</th>
            <th>Status</th>
            <th>Total Fare</th>
            <th>Date</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty trips}">
              <tr><td colspan="10" class="table-empty">No trips found.</td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="trip" items="${trips}">
              <tr>
                <td><strong>${trip.tripId}</strong></td>
                <td>${trip.ownerName}</td>
                <td>${not empty trip.driverName ? trip.driverName : '—'}</td>
                <td class="text-nowrap">${trip.vehiclePlate}</td>
                <td class="text-truncate">${trip.pickupLocation}</td>
                <td class="text-truncate">${trip.dropoffLocation}</td>
                <td>
                  <span class="badge badge-${trip.tripStatus.name().toLowerCase().replace('_','-')}">
                    ${trip.tripStatus.name().replace('_',' ')}
                  </span>
                </td>
                <td class="text-nowrap">Rs. <fmt:formatNumber value="${trip.totalFare}" pattern="#,##0.00"/></td>
                <td class="text-nowrap text-muted">
                  ${fn:replace(fn:substring(trip.createdAt, 0, 16), 'T', ' ')}
                </td>
                <td>
                  <c:if test="${trip.tripStatus.name() != 'COMPLETED' && trip.tripStatus.name() != 'CANCELLED'}">
                    <form method="post" action="${pageContext.request.contextPath}/admin/trips" style="display:inline">
                      <input type="hidden" name="id"     value="${trip.id}">
                      <input type="hidden" name="status" value="CANCELLED">
                      <button type="submit" class="btn btn-xs btn-danger"
                              onclick="return confirm('Cancel this trip?')">Cancel</button>
                    </form>
                  </c:if>
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

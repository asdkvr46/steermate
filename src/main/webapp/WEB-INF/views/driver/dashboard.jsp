<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate — Driver Hub</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>

<nav class="navbar navbar-driver">
  <div class="navbar-brand">
    <span class="logo-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="2.5" fill="currentColor"/><line x1="12" y1="9.5" x2="12" y2="3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="14.17" y1="13.25" x2="19.79" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="9.83" y1="13.25" x2="4.21" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></span>
    <span class="logo-text">SteerMate</span>
  </div>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/driver/dashboard" class="nav-link active">Dashboard</a>
    <a href="${pageContext.request.contextPath}/driver/earnings"  class="nav-link">Earnings</a>
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
      <h1 class="page-title">Welcome, ${sessionScope.loggedUser.name}</h1>
      <p class="page-subtitle">${sessionScope.loggedUser.email}</p>
      <span class="role-banner role-banner-driver"><span class="role-banner-dot"></span>Driver</span>
    </div>
    <div class="online-badge">&#9679; Online &amp; Receiving Requests</div>
  </div>

  <c:if test="${not empty param.msg}">
    <div class="alert ${param.msg == 'completed' ? 'alert-success' : 'alert-info'}">
      <c:choose>
        <c:when test="${param.msg == 'completed'}">&#10003; Trip completed! Earnings updated.</c:when>
        <c:when test="${param.msg == 'accepted'}">&#128205; You accepted the trip. Head to the pickup location.</c:when>
        <c:otherwise>Action completed.</c:otherwise>
      </c:choose>
    </div>
  </c:if>

  <!-- Stats -->
  <div class="stats-grid stats-grid-3">
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
        <div class="stat-value">${not empty profile ? profile.rating : '0.00'}</div>
        <div class="stat-label">Your Rating</div>
      </div>
    </div>
    <div class="stat-card stat-blue">
      <div class="stat-icon">&#128663;</div>
      <div class="stat-info">
        <div class="stat-value">${not empty profile ? profile.totalTrips : 0}</div>
        <div class="stat-label">Total Trips Completed</div>
      </div>
    </div>
  </div>

  <!-- New Trip Requests -->
  <div class="card">
    <div class="card-header">
      <h2 class="card-title">&#128205; Available Trip Requests</h2>
    </div>
    <c:choose>
      <c:when test="${empty searchingTrips}">
        <div class="card-empty">
          <span class="empty-icon">&#128205;</span>
          <p>No trip requests at the moment. Stay online to receive new requests.</p>
        </div>
      </c:when>
      <c:otherwise>
        <c:forEach var="trip" items="${searchingTrips}">
        <div class="trip-request-card">
          <div class="trip-request-header">
            <span class="trip-request-id">Trip ${trip.tripId}</span>
            <span class="trip-request-fare">Rs. <fmt:formatNumber value="${trip.totalFare}" pattern="#,##0.00"/></span>
          </div>
          <div class="trip-request-body">
            <div class="trip-detail-row">
              <span class="trip-label">&#128101; Car Owner</span>
              <span>${trip.ownerName}</span>
            </div>
            <div class="trip-detail-row">
              <span class="trip-label">&#128663; Vehicle</span>
              <span>${trip.vehicleDisplay}</span>
            </div>
            <div class="trip-detail-row">
              <span class="trip-label">&#128205; Pickup</span>
              <span>${trip.pickupLocation}</span>
            </div>
            <div class="trip-detail-row">
              <span class="trip-label">&#127937; Dropoff</span>
              <span>${trip.dropoffLocation}</span>
            </div>
          </div>
          <div class="fare-breakdown fare-compact">
            <div class="fare-row"><span>Gross Fare</span><span>Rs. <fmt:formatNumber value="${trip.totalFare}" pattern="#,##0.00"/></span></div>
            <div class="fare-row fare-row-platform"><span>Platform Fee (15%)</span><span>&minus; Rs. <fmt:formatNumber value="${trip.platformFee}" pattern="#,##0.00"/></span></div>
            <div class="fare-row fare-total"><span>Your Take-Home</span><span>Rs. <fmt:formatNumber value="${trip.driverEarnings}" pattern="#,##0.00"/></span></div>
          </div>
          <div class="trip-request-actions">
            <form method="post" action="${pageContext.request.contextPath}/driver/dashboard" style="display:inline">
              <input type="hidden" name="tripId" value="${trip.id}">
              <input type="hidden" name="action" value="accept">
              <button type="submit" class="btn btn-success btn-lg">&#10003; Accept Trip</button>
            </form>
            <form method="post" action="${pageContext.request.contextPath}/driver/dashboard" style="display:inline">
              <input type="hidden" name="tripId" value="${trip.id}">
              <input type="hidden" name="action" value="decline">
              <button type="submit" class="btn btn-outline-danger btn-lg">&#10007; Decline</button>
            </form>
          </div>
        </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>

  <!-- My Active/Recent Trips -->
  <c:if test="${not empty recentTrips}">
  <div class="card">
    <div class="card-header">
      <h2 class="card-title">My Recent Trips</h2>
      <a href="${pageContext.request.contextPath}/driver/earnings" class="btn btn-sm btn-secondary">View Earnings</a>
    </div>
    <div class="table-responsive">
      <table class="data-table">
        <thead>
          <tr>
            <th>Trip ID</th>
            <th>Car Owner</th>
            <th>Vehicle</th>
            <th>Status</th>
            <th>Net Earnings</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="trip" items="${recentTrips}" end="4">
          <tr>
            <td><strong>${trip.tripId}</strong></td>
            <td>${trip.ownerName}</td>
            <td>${trip.vehiclePlate}</td>
            <td><span class="badge badge-${trip.tripStatus.name().toLowerCase().replace('_','-')}">${trip.tripStatus.name().replace('_',' ')}</span></td>
            <td class="text-nowrap">Rs. <fmt:formatNumber value="${trip.driverEarnings}" pattern="#,##0.00"/></td>
            <td>
              <c:if test="${trip.tripStatus.name() == 'DRIVER_ASSIGNED'}">
                <form method="post" action="${pageContext.request.contextPath}/driver/dashboard" style="display:inline">
                  <input type="hidden" name="tripId" value="${trip.id}">
                  <input type="hidden" name="action" value="arrive">
                  <button type="submit" class="btn btn-xs btn-secondary">I've Arrived</button>
                </form>
              </c:if>
              <c:if test="${trip.tripStatus.name() == 'DRIVER_ARRIVING'}">
                <form method="post" action="${pageContext.request.contextPath}/driver/dashboard" style="display:inline">
                  <input type="hidden" name="tripId" value="${trip.id}">
                  <input type="hidden" name="action" value="start">
                  <button type="submit" class="btn btn-xs btn-primary">Start Trip</button>
                </form>
              </c:if>
              <c:if test="${trip.tripStatus.name() == 'IN_PROGRESS'}">
                <form method="post" action="${pageContext.request.contextPath}/driver/dashboard" style="display:inline">
                  <input type="hidden" name="tripId" value="${trip.id}">
                  <input type="hidden" name="action" value="complete">
                  <button type="submit" class="btn btn-xs btn-success">&#10003; Complete</button>
                </form>
              </c:if>
            </td>
          </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
  </c:if>
</main>

</body>
</html>

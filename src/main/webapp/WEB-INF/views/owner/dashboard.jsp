<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate — Car Owner Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>

<nav class="navbar navbar-owner">
  <div class="navbar-brand">
    <span class="logo-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="2.5" fill="currentColor"/><line x1="12" y1="9.5" x2="12" y2="3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="14.17" y1="13.25" x2="19.79" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="9.83" y1="13.25" x2="4.21" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></span>
    <span class="logo-text">SteerMate</span>
  </div>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/owner/dashboard" class="nav-link active">Dashboard</a>
    <a href="${pageContext.request.contextPath}/owner/book"      class="nav-link">Book a Driver</a>
    <a href="${pageContext.request.contextPath}/owner/trips"     class="nav-link">My Trips</a>
    <a href="${pageContext.request.contextPath}/owner/search"    class="nav-link">Search Drivers</a>
    <a href="${pageContext.request.contextPath}/owner/wishlist"  class="nav-link">Wishlist</a>
    <a href="${pageContext.request.contextPath}/owner/profile"   class="nav-link">Profile</a>
  </div>
  <div class="navbar-user">
    <div class="nav-avatar nav-avatar-owner">${fn:substring(sessionScope.loggedUser.name,0,1)}</div>
    <div class="nav-user-info">
      <div class="nav-user-name">${sessionScope.loggedUser.name}</div>
      <div class="nav-user-role">Car Owner</div>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="btn-nav-logout">Logout</a>
  </div>
</nav>

<%-- Compute stats from all trips --%>
<c:set var="totalTrips"     value="${recentTrips.size()}"/>
<c:set var="completedTrips" value="0"/>
<c:set var="totalSpent"     value="0.0"/>
<c:forEach var="t" items="${recentTrips}">
  <c:if test="${t.tripStatus.name() == 'COMPLETED'}">
    <c:set var="completedTrips" value="${completedTrips + 1}"/>
    <c:set var="totalSpent"     value="${totalSpent + t.totalFare}"/>
  </c:if>
</c:forEach>

<main class="main-content">
  <div class="page-header">
    <div>
      <h1 class="page-title">Welcome back, ${sessionScope.loggedUser.name}</h1>
      <p class="page-subtitle">${sessionScope.loggedUser.email}</p>
      <span class="role-banner role-banner-owner"><span class="role-banner-dot"></span>Car Owner</span>
    </div>
    <a href="${pageContext.request.contextPath}/owner/book" class="btn btn-primary btn-lg">+ Book a Driver</a>
  </div>

  <c:if test="${not empty param.msg}">
    <div class="alert alert-info">Trip cancelled successfully.</div>
  </c:if>
  <c:if test="${not empty param.booked}">
    <div class="alert alert-success">&#10003; Trip request submitted! We're finding a driver for you.</div>
  </c:if>

  <!-- Stats -->
  <div class="stats-grid stats-grid-3">
    <div class="stat-card stat-blue">
      <div class="stat-icon">&#128663;</div>
      <div class="stat-info">
        <div class="stat-value">${totalTrips}</div>
        <div class="stat-label">Total Trips Booked</div>
      </div>
    </div>
    <div class="stat-card stat-green">
      <div class="stat-icon">&#10003;</div>
      <div class="stat-info">
        <div class="stat-value">${completedTrips}</div>
        <div class="stat-label">Completed Trips</div>
      </div>
    </div>
    <div class="stat-card stat-orange">
      <div class="stat-icon">&#128176;</div>
      <div class="stat-info">
        <div class="stat-value">Rs. <fmt:formatNumber value="${totalSpent}" pattern="#,##0"/></div>
        <div class="stat-label">Total Spent</div>
      </div>
    </div>
  </div>

  <!-- Active Trip Card -->
  <c:if test="${not empty activeTrip}">
  <div class="card card-active-trip">
    <div class="card-header">
      <h2 class="card-title">&#128663; Active Trip &mdash; ${activeTrip.tripId}</h2>
      <span class="badge badge-${activeTrip.tripStatus.name().toLowerCase().replace('_','-')} badge-lg">
        ${activeTrip.tripStatus.name().replace('_',' ')}
      </span>
    </div>
    <div class="trip-detail-grid">
      <div class="trip-detail-block">
        <div class="trip-detail-label">&#128205; Pickup</div>
        <div class="trip-detail-value">${activeTrip.pickupLocation}</div>
      </div>
      <div class="trip-detail-block">
        <div class="trip-detail-label">&#127937; Dropoff</div>
        <div class="trip-detail-value">${activeTrip.dropoffLocation}</div>
      </div>
      <c:if test="${not empty activeTrip.driverName}">
      <div class="trip-detail-block">
        <div class="trip-detail-label">&#128101; Assigned Driver</div>
        <div class="trip-detail-value">${activeTrip.driverName}</div>
      </div>
      </c:if>
      <div class="trip-detail-block">
        <div class="trip-detail-label">&#128663; Your Vehicle</div>
        <div class="trip-detail-value">${activeTrip.vehicleDisplay}</div>
      </div>
    </div>
    <div class="fare-breakdown">
      <h4 class="fare-title">Fare Breakdown</h4>
      <div class="fare-row"><span>Base Driver Fee</span><span>Rs. <fmt:formatNumber value="${activeTrip.baseFee}" pattern="#,##0.00"/></span></div>
      <div class="fare-row"><span>Distance Fee</span><span>Rs. <fmt:formatNumber value="${activeTrip.distanceFee}" pattern="#,##0.00"/></span></div>
      <div class="fare-row"><span>Time Fee</span><span>Rs. <fmt:formatNumber value="${activeTrip.timeFee}" pattern="#,##0.00"/></span></div>
      <div class="fare-row fare-row-platform"><span>Platform Fee (15%)</span><span>Rs. <fmt:formatNumber value="${activeTrip.platformFee}" pattern="#,##0.00"/></span></div>
      <div class="fare-row fare-total"><span>Total Fare</span><span>Rs. <fmt:formatNumber value="${activeTrip.totalFare}" pattern="#,##0.00"/></span></div>
      <div class="fare-row"><span>Payment Method</span><span>${activeTrip.paymentMethod}</span></div>
    </div>
    <div class="card-actions">
      <form method="post" action="${pageContext.request.contextPath}/owner/dashboard">
        <input type="hidden" name="action" value="cancel">
        <input type="hidden" name="tripId" value="${activeTrip.id}">
        <button type="submit" class="btn btn-danger"
                onclick="return confirm('Are you sure you want to cancel this trip?')">
          Cancel Trip
        </button>
      </form>
    </div>
  </div>
  </c:if>

  <c:if test="${empty activeTrip}">
  <div class="card card-cta">
    <div class="cta-content">
      <span class="cta-icon">&#128663;</span>
      <div>
        <h3>No active trip</h3>
        <p>Need a driver for your car? Book one now &mdash; insured up to Rs. 50 Lakhs.</p>
      </div>
      <a href="${pageContext.request.contextPath}/owner/book" class="btn btn-primary">Book a Driver</a>
    </div>
  </div>
  </c:if>

  <!-- Recent Trips -->
  <c:if test="${not empty recentTrips}">
  <div class="card">
    <div class="card-header">
      <h2 class="card-title">Recent Trips</h2>
      <a href="${pageContext.request.contextPath}/owner/trips" class="btn btn-sm btn-secondary">View All</a>
    </div>
    <div class="table-responsive">
      <table class="data-table">
        <thead>
          <tr>
            <th>Trip ID</th>
            <th>Driver</th>
            <th>From</th>
            <th>To</th>
            <th>Status</th>
            <th>Fare</th>
            <th>Date</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="trip" items="${recentTrips}" end="4">
          <tr>
            <td><strong>${trip.tripId}</strong></td>
            <td>${not empty trip.driverName ? trip.driverName : '—'}</td>
            <td class="text-truncate">${trip.pickupLocation}</td>
            <td class="text-truncate">${trip.dropoffLocation}</td>
            <td><span class="badge badge-${trip.tripStatus.name().toLowerCase().replace('_','-')}">${trip.tripStatus.name().replace('_',' ')}</span></td>
            <td class="text-nowrap">Rs. <fmt:formatNumber value="${trip.totalFare}" pattern="#,##0.00"/></td>
            <td class="text-nowrap text-muted">
              ${fn:replace(fn:substring(trip.createdAt, 0, 16), 'T', ' ')}
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

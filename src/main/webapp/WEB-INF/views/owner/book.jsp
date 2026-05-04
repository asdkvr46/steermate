<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate — Book a Driver</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>

<nav class="navbar navbar-owner">
  <div class="navbar-brand">
    <span class="logo-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="2.5" fill="currentColor"/><line x1="12" y1="9.5" x2="12" y2="3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="14.17" y1="13.25" x2="19.79" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="9.83" y1="13.25" x2="4.21" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></span>
    <span class="logo-text">SteerMate</span>
  </div>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/owner/dashboard" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/owner/book"      class="nav-link active">Book a Driver</a>
    <a href="${pageContext.request.contextPath}/owner/trips"     class="nav-link">My Trips</a>
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

<main class="main-content">
  <div class="page-header">
    <div>
      <h1 class="page-title">Book a Driver</h1>
      <p class="page-subtitle">A verified driver will come to you and drive your car to the destination.</p>
      <span class="role-banner role-banner-owner"><span class="role-banner-dot"></span>Car Owner</span>
    </div>
  </div>

  <c:if test="${empty vehicles}">
    <div class="alert alert-warning">
      &#9888; You have no vehicles registered. Please contact support to add your vehicle.
    </div>
  </c:if>

  <c:if test="${not empty vehicles}">
  <div class="card" style="max-width: 680px; margin: 0 auto;">
    <div class="card-header">
      <h2 class="card-title">Trip Request</h2>
    </div>
    <form method="post" action="${pageContext.request.contextPath}/owner/book" class="auth-form">

      <div class="form-group">
        <label for="vehicleId" class="form-label">Select Your Vehicle</label>
        <select id="vehicleId" name="vehicleId" class="form-input" required>
          <option value="">-- Choose a vehicle --</option>
          <c:forEach var="v" items="${vehicles}">
            <option value="${v.id}">${v.displayName} &mdash; ${v.color}</option>
          </c:forEach>
        </select>
      </div>

      <div class="form-group">
        <label for="pickup" class="form-label">&#128205; Pickup Location</label>
        <input type="text" id="pickup" name="pickup" class="form-input"
               placeholder="e.g. Thamel Marg, Kathmandu" required>
      </div>

      <div class="form-group">
        <label for="dropoff" class="form-label">&#127937; Dropoff Location</label>
        <input type="text" id="dropoff" name="dropoff" class="form-input"
               placeholder="e.g. Tribhuvan International Airport" required>
      </div>

      <div class="form-group">
        <label for="distanceKm" class="form-label">Estimated Distance (km)</label>
        <input type="number" id="distanceKm" name="distanceKm" class="form-input"
               min="0.5" max="200" step="0.5" placeholder="e.g. 12.5" required
               oninput="updateFarePreview(this.value)">
      </div>

      <div class="fare-preview" id="farePreview" style="display:none">
        <h4 class="fare-title">Estimated Fare</h4>
        <div class="fare-row"><span>Base Fee</span><span>Rs. 150.00</span></div>
        <div class="fare-row"><span>Distance Fee</span><span id="distFeeVal">Rs. 0.00</span></div>
        <div class="fare-row"><span>Time Fee (est.)</span><span id="timeFeeVal">Rs. 0.00</span></div>
        <div class="fare-row fare-row-platform"><span>Platform Fee (15%)</span><span id="platformFeeVal">Rs. 0.00</span></div>
        <div class="fare-row fare-total"><span>Total</span><span id="totalFareVal">Rs. 150.00</span></div>
      </div>

      <div class="form-group">
        <label for="paymentMethod" class="form-label">Payment Method</label>
        <select id="paymentMethod" name="paymentMethod" class="form-input" required>
          <option value="CASH">Cash</option>
          <option value="ESEWA">eSewa</option>
          <option value="CARD">Card</option>
        </select>
      </div>

      <button type="submit" class="btn btn-primary btn-block btn-lg">Request Driver</button>
      <a href="${pageContext.request.contextPath}/owner/dashboard"
         class="btn btn-secondary btn-block" style="margin-top:8px">Cancel</a>
    </form>
  </div>
  </c:if>
</main>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

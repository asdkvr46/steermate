<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate — My Wishlist</title>
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
    <a href="${pageContext.request.contextPath}/owner/book"      class="nav-link">Book a Driver</a>
    <a href="${pageContext.request.contextPath}/owner/trips"     class="nav-link">My Trips</a>
    <a href="${pageContext.request.contextPath}/owner/search"    class="nav-link">Search Drivers</a>
    <a href="${pageContext.request.contextPath}/owner/wishlist"  class="nav-link active">Wishlist</a>
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

<main class="main-content">
  <div class="page-header">
    <div>
      <h1 class="page-title">My Driver Wishlist</h1>
      <p class="page-subtitle">Your saved favourite drivers for quick access.</p>
    </div>
    <a href="${pageContext.request.contextPath}/owner/search" class="btn btn-secondary">+ Find More Drivers</a>
  </div>

  <c:choose>
    <c:when test="${not empty wishlistedDrivers}">
      <p class="search-meta">${wishlistedDrivers.size()} driver(s) saved in your wishlist</p>
      <div class="driver-cards-grid">
        <c:forEach var="dp" items="${wishlistedDrivers}">
          <div class="driver-card">
            <div class="driver-card-header">
              <div class="driver-avatar">${fn:substring(dp.driverName,0,1)}</div>
              <div class="driver-card-info">
                <h3 class="driver-name">${dp.driverName}</h3>
                <span class="driver-license">${dp.licenseNumber}</span>
              </div>
              <div class="driver-rating">
                <span class="rating-star">&#9733;</span>
                <fmt:formatNumber value="${dp.rating}" pattern="0.0"/>
              </div>
            </div>
            <div class="driver-card-body">
              <div class="driver-meta-row">
                <span class="driver-meta-label">Experience</span>
                <span class="driver-meta-value">${dp.experienceYears} year(s)</span>
              </div>
              <div class="driver-meta-row">
                <span class="driver-meta-label">Total Trips</span>
                <span class="driver-meta-value">${dp.totalTrips}</span>
              </div>
              <div class="driver-meta-row">
                <span class="driver-meta-label">Phone</span>
                <span class="driver-meta-value">${dp.driverPhone}</span>
              </div>
              <c:if test="${not empty dp.bio}">
                <p class="driver-bio">${dp.bio}</p>
              </c:if>
            </div>
            <div class="driver-card-footer">
              <form method="post" action="${pageContext.request.contextPath}/owner/wishlist">
                <input type="hidden" name="driverId" value="${dp.userId}">
                <input type="hidden" name="action"   value="remove">
                <button type="submit" class="btn btn-wishlist btn-wishlist-active"
                        onclick="return confirm('Remove ${dp.driverName} from your wishlist?')">
                  &#9733; Remove from Wishlist
                </button>
              </form>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:when>
    <c:otherwise>
      <div class="empty-state">
        <div class="empty-icon">&#9734;</div>
        <h3>Your wishlist is empty</h3>
        <p>Search for drivers and add them to your wishlist for quick access.</p>
        <a href="${pageContext.request.contextPath}/owner/search" class="btn btn-primary" style="margin-top:16px">Search Drivers</a>
      </div>
    </c:otherwise>
  </c:choose>
</main>

</body>
</html>

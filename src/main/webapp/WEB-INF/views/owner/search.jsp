<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate — Search Drivers</title>
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
    <a href="${pageContext.request.contextPath}/owner/search"    class="nav-link active">Search Drivers</a>
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

<main class="main-content">
  <div class="page-header">
    <div>
      <h1 class="page-title">Search Drivers</h1>
      <p class="page-subtitle">Find approved drivers by name, license number, or phone.</p>
    </div>
  </div>

  <div class="card">
    <form method="get" action="${pageContext.request.contextPath}/owner/search" class="search-bar-form">
      <div class="search-bar">
        <input type="text" name="q" value="${fn:escapeXml(query)}"
               placeholder="Search by driver name, license number, or phone..."
               class="search-input" autofocus>
        <button type="submit" class="btn btn-primary">Search</button>
      </div>
    </form>
  </div>

  <c:if test="${not empty searchError}">
    <div class="alert alert-danger">${searchError}</div>
  </c:if>

  <c:if test="${not empty query and empty searchError}">
    <c:choose>
      <c:when test="${not empty results}">
        <p class="search-meta">${results.size()} driver(s) found for "<strong>${fn:escapeXml(query)}</strong>"</p>
        <div class="driver-cards-grid">
          <c:forEach var="dp" items="${results}">
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
                <c:set var="inWishlist" value="${wishlistIds.contains(dp.userId)}"/>
                <form method="post" action="${pageContext.request.contextPath}/owner/wishlist">
                  <input type="hidden" name="driverId" value="${dp.userId}">
                  <input type="hidden" name="from" value="search">
                  <input type="hidden" name="q" value="${fn:escapeXml(query)}">
                  <c:choose>
                    <c:when test="${inWishlist}">
                      <input type="hidden" name="action" value="remove">
                      <button type="submit" class="btn btn-wishlist btn-wishlist-active">&#9733; In Wishlist</button>
                    </c:when>
                    <c:otherwise>
                      <input type="hidden" name="action" value="add">
                      <button type="submit" class="btn btn-wishlist">&#9734; Add to Wishlist</button>
                    </c:otherwise>
                  </c:choose>
                </form>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <div class="empty-state">
          <div class="empty-icon">&#128269;</div>
          <h3>No drivers found</h3>
          <p>No approved drivers match "<strong>${fn:escapeXml(query)}</strong>". Try a different search term.</p>
        </div>
      </c:otherwise>
    </c:choose>
  </c:if>

  <c:if test="${empty query}">
    <div class="empty-state">
      <div class="empty-icon">&#128101;</div>
      <h3>Find your driver</h3>
      <p>Enter a driver name, license number, or phone number above to search.</p>
    </div>
  </c:if>
</main>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate — My Profile</title>
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
    <a href="${pageContext.request.contextPath}/owner/wishlist"  class="nav-link">Wishlist</a>
    <a href="${pageContext.request.contextPath}/owner/profile"   class="nav-link active">Profile</a>
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
      <h1 class="page-title">My Profile</h1>
      <p class="page-subtitle">Update your personal information.</p>
    </div>
  </div>

  <c:if test="${not empty param.msg}">
    <div class="alert alert-success">&#10003; Profile updated successfully.</div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
  </c:if>

  <div class="card profile-card">
    <div class="profile-avatar-section">
      <div class="profile-avatar">${fn:substring(sessionScope.loggedUser.name,0,1)}</div>
      <div>
        <h2>${sessionScope.loggedUser.name}</h2>
        <span class="role-banner role-banner-owner"><span class="role-banner-dot"></span>Car Owner</span>
      </div>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/owner/profile" class="profile-form">
      <div class="form-group">
        <label class="form-label" for="name">Full Name</label>
        <input type="text" id="name" name="name"
               value="${not empty error ? fn:escapeXml(param.name) : fn:escapeXml(profileUser.name)}"
               class="form-control" placeholder="Your full name" required>
        <small class="form-hint">Letters and spaces only, 2–120 characters.</small>
      </div>

      <div class="form-group">
        <label class="form-label" for="email">Email Address</label>
        <input type="email" id="email" value="${fn:escapeXml(profileUser.email)}"
               class="form-control" disabled>
        <small class="form-hint">Email cannot be changed.</small>
      </div>

      <div class="form-group">
        <label class="form-label" for="phone">Phone Number</label>
        <input type="text" id="phone" name="phone"
               value="${not empty error ? fn:escapeXml(param.phone) : fn:escapeXml(profileUser.phone)}"
               class="form-control" placeholder="10-digit phone number" required maxlength="10">
        <small class="form-hint">Exactly 10 digits, no spaces or dashes.</small>
      </div>

      <div class="form-group">
        <label class="form-label">Account Status</label>
        <div><span class="badge badge-approved">${profileUser.status}</span></div>
      </div>

      <div class="form-group">
        <label class="form-label">Member Since</label>
        <div class="text-muted">${fn:substring(profileUser.createdAt.toString(), 0, 10)}</div>
      </div>

      <button type="submit" class="btn btn-primary">Save Changes</button>
    </form>
  </div>
</main>

</body>
</html>

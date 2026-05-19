<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate — Register</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body class="auth-body">

<nav class="auth-topbar">
  <a href="${pageContext.request.contextPath}/about"    class="auth-topbar-link">About</a>
  <a href="${pageContext.request.contextPath}/contact"  class="auth-topbar-link">Contact</a>
</nav>

<div class="auth-container">
  <div class="auth-card auth-card-wide">
    <div class="auth-logo">
      <span class="logo-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="2.5" fill="currentColor"/><line x1="12" y1="9.5" x2="12" y2="3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="14.17" y1="13.25" x2="19.79" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="9.83" y1="13.25" x2="4.21" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></span>
      <span class="logo-text">SteerMate</span>
    </div>
    <h2 class="auth-title">Create Account</h2>

    <c:if test="${not empty error}">
      <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="alert alert-success">${success}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/register" class="auth-form" id="registerForm">

      <div class="form-group">
        <label class="form-label">I am registering as:</label>
        <div class="role-selector">
          <label class="role-option ${empty role || role == 'OWNER' ? 'selected' : ''}">
            <input type="radio" name="role" value="OWNER"
                   ${empty role || role == 'OWNER' ? 'checked' : ''}
                   onchange="toggleDriverFields(false)">
            <span class="role-icon">&#128663;</span>
            <span>Car Owner</span>
          </label>
          <label class="role-option ${role == 'DRIVER' ? 'selected' : ''}">
            <input type="radio" name="role" value="DRIVER"
                   ${role == 'DRIVER' ? 'checked' : ''}
                   onchange="toggleDriverFields(true)">
            <span class="role-icon">&#128101;</span>
            <span>Driver</span>
          </label>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="name" class="form-label">Full Name</label>
          <input type="text" id="name" name="name" class="form-input"
                 value="${not empty name ? name : ''}"
                 placeholder="Aayush Shrestha" required>
        </div>
        <div class="form-group">
          <label for="phone" class="form-label">Phone Number</label>
          <input type="tel" id="phone" name="phone" class="form-input"
                 value="${not empty phone ? phone : ''}"
                 placeholder="98XXXXXXXX" required>
        </div>
      </div>

      <div class="form-group">
        <label for="email" class="form-label">Email Address</label>
        <input type="email" id="email" name="email" class="form-input"
               value="${not empty email ? email : ''}"
               placeholder="you@example.com" required>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="password" class="form-label">Password</label>
          <input type="password" id="password" name="password" class="form-input"
                 placeholder="Min. 6 characters" required>
        </div>
        <div class="form-group">
          <label for="confirmPassword" class="form-label">Confirm Password</label>
          <input type="password" id="confirmPassword" name="confirmPassword" class="form-input"
                 placeholder="Repeat password" required>
        </div>
      </div>

      <!-- Driver-only fields -->
      <div id="driverFields" style="${role == 'DRIVER' ? 'display:block' : 'display:none'}" >
        <hr class="form-divider">
        <h4 class="form-section-title">Driver Details</h4>

        <div class="form-row">
          <div class="form-group">
            <label for="licenseNumber" class="form-label">License Number</label>
            <input type="text" id="licenseNumber" name="licenseNumber" class="form-input"
                   placeholder="DL-BAG-XXXX-YYYY">
          </div>
          <div class="form-group">
            <label for="licenseExpiry" class="form-label">License Expiry</label>
            <input type="date" id="licenseExpiry" name="licenseExpiry" class="form-input">
          </div>
        </div>

        <div class="form-group">
          <label for="experienceYears" class="form-label">Years of Experience</label>
          <input type="number" id="experienceYears" name="experienceYears" class="form-input"
                 min="0" max="50" placeholder="0" value="0">
        </div>

        <div class="form-group">
          <label for="bio" class="form-label">Short Bio (optional)</label>
          <textarea id="bio" name="bio" class="form-input" rows="3"
                    placeholder="Describe your driving experience..."></textarea>
        </div>
      </div>

      <button type="submit" class="btn btn-primary btn-block">Create Account</button>
    </form>

    <p class="auth-footer">
      Already have an account?
      <a href="${pageContext.request.contextPath}/login">Sign in</a>
    </p>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
  function toggleDriverFields(show) {
    document.getElementById('driverFields').style.display = show ? 'block' : 'none';
  }
</script>
</body>
</html>

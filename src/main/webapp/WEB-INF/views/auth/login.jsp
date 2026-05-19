<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate — Sign In</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body class="auth-body">

<nav class="auth-topbar">
  <a href="${pageContext.request.contextPath}/about"    class="auth-topbar-link">About</a>
  <a href="${pageContext.request.contextPath}/contact"  class="auth-topbar-link">Contact</a>
</nav>

<div class="auth-container">
  <div class="auth-card">
    <div class="auth-logo">
      <span class="logo-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="2.5" fill="currentColor"/><line x1="12" y1="9.5" x2="12" y2="3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="14.17" y1="13.25" x2="19.79" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="9.83" y1="13.25" x2="4.21" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></span>
      <span class="logo-text">SteerMate</span>
    </div>
    <h2 class="auth-title">Welcome Back</h2>
    <p class="auth-subtitle">Sign in to your account</p>

    <c:if test="${not empty error}">
      <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty param.timeout}">
      <div class="alert alert-warning">Your session expired. Please sign in again.</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/login" class="auth-form">
      <div class="form-group">
        <label for="email" class="form-label">Email Address</label>
        <input type="email" id="email" name="email" class="form-input"
               value="${not empty email ? email : ''}"
               placeholder="you@example.com" required autofocus>
      </div>

      <div class="form-group">
        <label for="password" class="form-label">Password</label>
        <input type="password" id="password" name="password" class="form-input"
               placeholder="Enter your password" required>
      </div>

      <button type="submit" class="btn btn-primary btn-block">Sign In</button>
    </form>

    <p class="auth-footer">
      Don't have an account?
      <a href="${pageContext.request.contextPath}/register">Register here</a>
    </p>
  </div>
</div>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>SteerMate — Access Denied</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body class="auth-body">
  <div class="auth-container">
    <div class="auth-card" style="text-align:center">
      <div style="font-size:4rem; margin-bottom:16px">403</div>
      <h2 class="auth-title">Access Denied</h2>
      <p style="color:#7F8C8D; margin: 16px 0 24px">You do not have permission to view this page.</p>
      <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">Go to Dashboard</a>
    </div>
  </div>
</body>
</html>

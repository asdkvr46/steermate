<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>SteerMate — Server Error</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body class="auth-body">
  <div class="auth-container">
    <div class="auth-card" style="text-align:center">
      <div style="font-size:4rem; margin-bottom:16px">500</div>
      <h2 class="auth-title">Server Error</h2>
      <p style="color:#7F8C8D; margin: 16px 0 24px">Something went wrong on our end. Please try again.</p>
      <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go Home</a>
    </div>
  </div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate — Contact Us</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body class="page-public">

<nav class="navbar navbar-public">
  <div class="navbar-brand">
    <span class="logo-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="2.5" fill="currentColor"/><line x1="12" y1="9.5" x2="12" y2="3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="14.17" y1="13.25" x2="19.79" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="9.83" y1="13.25" x2="4.21" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></span>
    <span class="logo-text">SteerMate</span>
  </div>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/about"   class="nav-link">About</a>
    <a href="${pageContext.request.contextPath}/contact" class="nav-link active">Contact</a>
  </div>
  <div class="navbar-user">
    <a href="${pageContext.request.contextPath}/login"    class="btn btn-sm btn-secondary">Login</a>
    <a href="${pageContext.request.contextPath}/register" class="btn btn-sm btn-primary" style="margin-left:8px">Register</a>
  </div>
</nav>

<main class="main-content">
  <div class="public-hero">
    <div class="public-hero-icon">&#128140;</div>
    <h1 class="public-hero-title">Contact Us</h1>
    <p class="public-hero-sub">Reach our support, driver onboarding, or partnerships team &mdash; we respond within 4 business hours.</p>
  </div>

  <div class="public-contact-layout">

    <div class="card public-card">
      <h2 class="public-card-title">Send a Message</h2>

      <c:if test="${not empty success}">
        <div class="alert alert-success">&#10003; ${success}</div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
      </c:if>

      <c:if test="${empty success}">
      <form method="post" action="${pageContext.request.contextPath}/contact" class="profile-form">
        <div class="form-group">
          <label class="form-label" for="name">Full Name</label>
          <input type="text" id="name" name="name"
                 value="${fn:escapeXml(name)}"
                 class="form-control" placeholder="Your full name" required>
        </div>
        <div class="form-group">
          <label class="form-label" for="email">Email Address</label>
          <input type="email" id="email" name="email"
                 value="${fn:escapeXml(email)}"
                 class="form-control" placeholder="your@email.com" required>
        </div>
        <div class="form-group">
          <label class="form-label" for="subject">Subject</label>
          <input type="text" id="subject" name="subject"
                 value="${fn:escapeXml(subject)}"
                 class="form-control" placeholder="What is your enquiry about?" required>
        </div>
        <div class="form-group">
          <label class="form-label" for="message">Message</label>
          <textarea id="message" name="message" class="form-control" rows="5"
                    placeholder="Write your message here (at least 10 characters)..."
                    required minlength="10">${fn:escapeXml(message)}</textarea>
        </div>
        <button type="submit" class="btn btn-primary">Send Message</button>
      </form>
      </c:if>
    </div>

    <div>
      <div class="card public-card contact-info-card">
        <h2 class="public-card-title">Head Office</h2>
        <ul class="contact-info-list">
          <li><span class="contact-info-icon">&#128205;</span> 4th Floor, Kamalpokhari Plaza, Kamalpokhari, Kathmandu 44600, Nepal</li>
          <li><span class="contact-info-icon">&#128222;</span> +977-1-4523890 &nbsp;(Landline)</li>
          <li><span class="contact-info-icon">&#128241;</span> +977-9801234567 &nbsp;(Mobile / Viber)</li>
          <li><span class="contact-info-icon">&#128140;</span> support@steermate.com</li>
          <li><span class="contact-info-icon">&#128336;</span> Sun – Fri, 8:00am – 8:00pm NST</li>
          <li><span class="contact-info-icon">&#128680;</span> 24/7 trip helpline: +977-9801234500</li>
        </ul>
      </div>

      <div class="card public-card" style="margin-top:16px">
        <h2 class="public-card-title">Department Contacts</h2>
        <ul class="contact-info-list">
          <li><span class="contact-info-icon">&#128101;</span> <strong>Rider Support:</strong> support@steermate.com</li>
          <li><span class="contact-info-icon">&#128663;</span> <strong>Driver Onboarding:</strong> drivers@steermate.com</li>
          <li><span class="contact-info-icon">&#128188;</span> <strong>Partnerships:</strong> partners@steermate.com</li>
          <li><span class="contact-info-icon">&#128737;</span> <strong>Safety / Incidents:</strong> safety@steermate.com</li>
          <li><span class="contact-info-icon">&#128231;</span> <strong>Media &amp; Press:</strong> press@steermate.com</li>
        </ul>
      </div>

      <div class="card public-card" style="margin-top:16px">
        <h2 class="public-card-title">Response Times</h2>
        <ul class="public-list">
          <li><strong>Live trip issues:</strong> &lt; 5 minutes (24/7 hotline)</li>
          <li><strong>Email enquiries:</strong> within 4 business hours</li>
          <li><strong>Driver applications:</strong> reviewed within 24 hours</li>
          <li><strong>Refunds &amp; disputes:</strong> resolved within 3 working days</li>
        </ul>
      </div>

      <div class="card public-card" style="margin-top:16px">
        <h2 class="public-card-title">Quick Links</h2>
        <ul class="public-list">
          <li><a href="${pageContext.request.contextPath}/register">Register as Car Owner or Driver</a></li>
          <li><a href="${pageContext.request.contextPath}/login">Login to your account</a></li>
          <li><a href="${pageContext.request.contextPath}/about">Learn about SteerMate</a></li>
        </ul>
      </div>
    </div>

  </div>
</main>

<footer class="public-footer">
  <p>&copy; 2025 SteerMate Pvt. Ltd. &bull; Kamalpokhari, Kathmandu, Nepal &bull; All rights reserved.</p>
</footer>

</body>
</html>

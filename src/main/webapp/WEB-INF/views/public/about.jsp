<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate — About Us</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body class="page-public">

<nav class="navbar navbar-public">
  <div class="navbar-brand">
    <span class="logo-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="2.5" fill="currentColor"/><line x1="12" y1="9.5" x2="12" y2="3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="14.17" y1="13.25" x2="19.79" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="9.83" y1="13.25" x2="4.21" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></span>
    <span class="logo-text">SteerMate</span>
  </div>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/about"   class="nav-link active">About</a>
    <a href="${pageContext.request.contextPath}/contact" class="nav-link">Contact</a>
  </div>
  <div class="navbar-user">
    <a href="${pageContext.request.contextPath}/login"    class="btn btn-sm btn-secondary">Login</a>
    <a href="${pageContext.request.contextPath}/register" class="btn btn-sm btn-primary" style="margin-left:8px">Register</a>
  </div>
</nav>

<main class="main-content">

  <div class="public-hero">
    <div class="public-hero-icon">&#128663;</div>
    <h1 class="public-hero-title">About SteerMate</h1>
    <p class="public-hero-sub">On-demand professional drivers for car owners across the Kathmandu Valley.</p>
  </div>

  <!-- Top-level numeric snapshot -->
  <div class="public-content-grid" style="max-width:1100px">
    <div class="stat-card stat-blue">
      <div class="stat-icon">&#128101;</div>
      <div class="stat-info">
        <div class="stat-value">1,240+</div>
        <div class="stat-label">Verified Drivers</div>
      </div>
    </div>
    <div class="stat-card stat-green">
      <div class="stat-icon">&#128663;</div>
      <div class="stat-info">
        <div class="stat-value">38,500+</div>
        <div class="stat-label">Trips Completed</div>
      </div>
    </div>
    <div class="stat-card stat-orange">
      <div class="stat-icon">&#9733;</div>
      <div class="stat-info">
        <div class="stat-value">4.8 / 5</div>
        <div class="stat-label">Average Driver Rating</div>
      </div>
    </div>
    <div class="stat-card stat-purple">
      <div class="stat-icon">&#9201;</div>
      <div class="stat-info">
        <div class="stat-value">8 min</div>
        <div class="stat-label">Median Driver Assignment</div>
      </div>
    </div>
  </div>

  <div class="public-content-grid">

    <div class="card public-card">
      <h2 class="public-card-title">&#127919; Our Mission</h2>
      <p>SteerMate connects car owners with skilled, verified drivers for on-demand trips across the Kathmandu Valley.
         We believe safe, professional driving services should be accessible to everyone &mdash;
         whether you need an airport transfer, a city ride, or a full-day engagement.</p>
    </div>

    <div class="card public-card">
      <h2 class="public-card-title">&#128205; Service Coverage</h2>
      <ul class="public-list">
        <li><strong>Kathmandu</strong> &mdash; 24/7 coverage across all 32 wards</li>
        <li><strong>Lalitpur</strong> &mdash; 24/7 coverage, Patan to Godawari</li>
        <li><strong>Bhaktapur</strong> &mdash; 6am to 11pm, all major neighbourhoods</li>
        <li><strong>TIA Airport transfers</strong> &mdash; round the clock</li>
        <li><strong>Out-of-valley</strong> &mdash; Pokhara, Chitwan, Nagarkot on request</li>
      </ul>
    </div>

    <div class="card public-card">
      <h2 class="public-card-title">&#128736; How It Works</h2>
      <ol class="public-list">
        <li><strong>Register</strong> as a car owner or a professional driver.</li>
        <li><strong>Admin review</strong> verifies every account before activation.</li>
        <li><strong>Book a driver</strong> by selecting your vehicle, route, and payment method.</li>
        <li><strong>Drivers accept trips</strong>, navigate the workflow, and earn through the platform.</li>
        <li><strong>Transparent pricing</strong> with itemised fare breakdown on every trip.</li>
      </ol>
    </div>

    <div class="card public-card">
      <h2 class="public-card-title">&#128176; Fare Structure</h2>
      <ul class="public-list">
        <li><strong>Base fee:</strong> Rs. 250 per trip</li>
        <li><strong>Distance:</strong> Rs. 35 per km</li>
        <li><strong>Time:</strong> Rs. 4 per minute</li>
        <li><strong>Platform fee:</strong> 15% (covers verification &amp; support)</li>
        <li><strong>Minimum fare:</strong> Rs. 400 &nbsp;&middot;&nbsp; <strong>Cancellation:</strong> Rs. 50 after 3 min</li>
      </ul>
    </div>

    <div class="card public-card">
      <h2 class="public-card-title">&#128663; Supported Vehicles</h2>
      <ul class="public-list">
        <li><strong>Hatchback</strong> &mdash; Swift, i10, WagonR</li>
        <li><strong>Sedan</strong> &mdash; Dzire, City, Verna</li>
        <li><strong>SUV</strong> &mdash; XUV300, Creta, Seltos</li>
        <li><strong>Premium SUV</strong> &mdash; Fortuner, Endeavour, MU-X</li>
        <li><strong>Electric</strong> &mdash; Nexon EV, MG ZS EV, BYD Atto 3</li>
      </ul>
    </div>

    <div class="card public-card">
      <h2 class="public-card-title">&#128275; Safety &amp; Trust</h2>
      <ul class="public-list">
        <li>Every driver reviewed by admin before approval.</li>
        <li>License numbers and expiry dates verified at registration.</li>
        <li>Average <strong>6.4 years</strong> driving experience across the fleet.</li>
        <li>Passwords encrypted using BCrypt hashing.</li>
        <li>Sessions managed securely with automatic expiry.</li>
      </ul>
    </div>

    <div class="card public-card">
      <h2 class="public-card-title">&#128181; Payment Methods</h2>
      <ul class="public-list">
        <li>Cash on completion</li>
        <li>eSewa</li>
        <li>Khalti</li>
      </ul>
      <p class="text-muted" style="margin-top:10px;font-size:0.85rem">
        Full fare breakdown shown before booking. No hidden surcharges.
      </p>
    </div>

    <div class="card public-card">
      <h2 class="public-card-title">&#128222; Get In Touch</h2>
      <p>Reach our support team for booking issues, driver onboarding, or partnership enquiries.</p>
      <p style="margin-top:10px"><strong>Support:</strong> +977-1-4523890</p>
      <p><strong>Email:</strong> support@steermate.com</p>
      <a href="${pageContext.request.contextPath}/contact" class="btn btn-primary" style="margin-top:14px">Contact Us</a>
    </div>

  </div>
</main>

<footer class="public-footer">
  <p>&copy; 2025 SteerMate Pvt. Ltd. &bull; Kamalpokhari, Kathmandu, Nepal &bull; All rights reserved.</p>
</footer>

</body>
</html>

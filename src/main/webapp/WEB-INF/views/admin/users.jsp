<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SteerMate Admin — Users</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>

<nav class="navbar navbar-admin">
  <div class="navbar-brand">
    <span class="logo-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="2.5" fill="currentColor"/><line x1="12" y1="9.5" x2="12" y2="3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="14.17" y1="13.25" x2="19.79" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="9.83" y1="13.25" x2="4.21" y2="16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></span>
    <span class="logo-text">SteerMate</span>
  </div>
  <div class="navbar-nav">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/users"     class="nav-link active">Users</a>
    <a href="${pageContext.request.contextPath}/admin/drivers"   class="nav-link">Drivers</a>
    <a href="${pageContext.request.contextPath}/admin/trips"     class="nav-link">Trips</a>
    <a href="${pageContext.request.contextPath}/admin/reports"   class="nav-link">Reports</a>
  </div>
  <div class="navbar-user">
    <div class="nav-avatar nav-avatar-admin">${fn:substring(sessionScope.loggedUser.name,0,1)}</div>
    <div class="nav-user-info">
      <div class="nav-user-name">${sessionScope.loggedUser.name}</div>
      <div class="nav-user-role">Administrator</div>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="btn-nav-logout">Logout</a>
  </div>
</nav>

<main class="main-content">
  <div class="page-header">
    <div>
      <h1 class="page-title">User Management</h1>
      <p class="page-subtitle">Manage all registered accounts</p>
      <span class="role-banner role-banner-admin"><span class="role-banner-dot"></span>Administrator</span>
    </div>
  </div>

  <c:if test="${not empty param.msg}">
    <div class="alert alert-success">Action completed successfully.</div>
  </c:if>

  <div class="card">
    <div class="card-header">
      <h2 class="card-title">All Users</h2>
    </div>
    <div class="table-responsive">
      <table class="data-table">
        <thead>
          <tr>
            <th>#</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Role</th>
            <th>Status</th>
            <th>Registered</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="u" items="${users}" varStatus="loop">
          <tr>
            <td class="text-muted">${loop.index + 1}</td>
            <td><strong>${u.name}</strong></td>
            <td>${u.email}</td>
            <td class="text-nowrap">${u.phone}</td>
            <td><span class="badge badge-role-${u.role.name().toLowerCase()}">${u.role}</span></td>
            <td><span class="badge badge-${u.status.name().toLowerCase()}">${u.status}</span></td>
            <td class="text-nowrap text-muted">
              ${fn:replace(fn:substring(u.createdAt, 0, 16), 'T', ' ')}
            </td>
            <td class="action-cell">
              <c:if test="${u.role != 'ADMIN'}">
                <c:if test="${u.status == 'PENDING'}">
                  <form method="post" action="${pageContext.request.contextPath}/admin/users" style="display:inline">
                    <input type="hidden" name="id"     value="${u.id}">
                    <input type="hidden" name="action" value="approve">
                    <button type="submit" class="btn btn-xs btn-success">&#10003; Approve</button>
                  </form>
                </c:if>
                <c:if test="${u.status != 'SUSPENDED'}">
                  <form method="post" action="${pageContext.request.contextPath}/admin/users" style="display:inline">
                    <input type="hidden" name="id"     value="${u.id}">
                    <input type="hidden" name="action" value="suspend">
                    <button type="submit" class="btn btn-xs btn-danger"
                            onclick="return confirm('Suspend this user?')">Suspend</button>
                  </form>
                </c:if>
              </c:if>
            </td>
          </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</main>

</body>
</html>

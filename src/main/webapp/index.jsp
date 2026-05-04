<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Redirect to login or dashboard based on session
    Object user = session.getAttribute("loggedUser");
    if (user != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>

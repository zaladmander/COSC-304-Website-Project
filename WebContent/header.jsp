<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String loggedInUser = (String) session.getAttribute("authenticatedUser");
    boolean loggedIn = (loggedInUser != null);
%>

<nav class="navbar navbar-default" style="margin-bottom: 20px;">
  <div class="container">

    <!-- Brand / title -->
    <div class="navbar-header">
      <a class="navbar-brand" href="index.jsp" style="font-family:cursive; color:#3399FF;">
        <%= getServletContext().getInitParameter("siteTitle") %>
      </a>
    </div>

    <ul class="nav navbar-nav navbar-right">
      <li><a href="index.jsp">Home</a></li>
      <li><a href="listprod.jsp">Products</a></li>
      <li><a href="showcart.jsp">Cart</a></li>

      <% if (loggedIn) { %>
          <li><a href="customer.jsp"><%= loggedInUser %></a></li>
          <li><a href="logout.jsp">Logout</a></li>
      <% } else { %>
          <li><a href="login.jsp">Login</a></li>
      <% } %>
    </ul>

  </div>
</nav>
<hr/>

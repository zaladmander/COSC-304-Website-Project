<%@ page contentType="text/html;charset=UTF-8" %>

<nav class="navbar navbar-default" style="margin-bottom: 20px;">
  <div class="container">

    <!-- Brand / site title -->
    <div class="navbar-header">
      <a class="navbar-brand" href="index.jsp" style="font-family: cursive; color:#3399FF;">
        <%= getServletContext().getInitParameter("siteTitle") %>
      </a>
    </div>

    <!-- Right-side nav links -->
    <ul class="nav navbar-nav navbar-right">
      <li><a href="index.jsp">Home</a></li>
      <li><a href="listprod.jsp">Products</a></li>
      <li><a href="showcart.jsp">Cart</a></li>
      <li><a href="login.jsp">Login</a></li>
    </ul>

  </div>
</nav>

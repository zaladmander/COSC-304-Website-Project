<%@ include file="/WEB-INF/escapeHTML.jsp" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String loggedInUser = (String) session.getAttribute("authenticatedUser");
    boolean loggedIn = (loggedInUser != null);
    String safeUser = escapeHtml(loggedInUser);
%>

<nav class="navbar navbar-default" style="margin-bottom: 20px;">
  <div class="container-fluid" style="display: flex; align-items: center; justify-content: space-between;">

    <div class="navbar-header">
      <a class="navbar-brand" href="index.jsp" style="font-family:cursive; color:#3399FF;">
        <%= getServletContext().getInitParameter("siteTitle") %>
      </a>
    </div>

    <div style="flex: 1; padding: 0 40px;">
      <jsp:include page="/WEB-INF/searchBar.jsp" />
    </div>

    <ul class="nav navbar-nav navbar-right" style="margin: 0;">
      <li><a href="index.jsp">Home</a></li>
      <li><a href="listprod.jsp">Products</a></li>
      <li><a href="showcart.jsp">Cart</a></li>

      <li class="dropdown">
        <a href="#" class="dropdown-toggle"
            data-toggle="dropdown"
            role="button"
            aria-haspopup="true"
            aria-expanded="false">
            <%= (safeUser != null ? safeUser : "Account") %> <span class="caret"></span>
        </a>

        <ul class="dropdown-menu dropdown-menu-right">
            <% if (loggedInUser == null) { %>
                <!-- Not logged in: show login + create account -->
                <li><a href="login.jsp">Sign in</a></li>
                <li><a href="createAccount.jsp">Create account</a></li>
            <% } else { %>
                <!-- Logged in: show account-related stuff -->
                <li><a href="customer.jsp">Account details</a></li>
                <!-- replace list order with personal order history -->
                <li><a href="userOrders.jsp">Order history</a></li>
                <li role="separator" class="divider"></li>
                <li><a href="logout.jsp">Logout</a></li>
            <% } %>
        </ul>
      </li>
    </ul>

  </div>
</nav>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<hr/>
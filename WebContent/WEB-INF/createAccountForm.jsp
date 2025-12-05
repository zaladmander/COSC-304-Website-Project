<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Boolean createdObj = (Boolean) request.getAttribute("caCreated");
    boolean created = createdObj != null && createdObj;

    java.util.List errors = (java.util.List) request.getAttribute("caErrors");
%>

<div class="create-account">
    <% if (created) { %>
        <div class="alert alert-success">
            Account created successfully. You are now logged in as
            <strong><%= request.getParameter("userid") %></strong>.
        </div>
        <p><a href="index.jsp" class="btn btn-primary">Continue shopping</a></p>
    <% } else { %>

        <% if (errors != null && !errors.isEmpty()) { %>
            <div class="alert alert-danger">
                <ul>
                    <% for (Object msg : errors) { %>
                        <li><%= msg %></li>
                    <% } %>

                </ul>
            </div>
        <% } %>

        <form method="post" action="createAccount.jsp">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">First name</label>
                    <input class="form-control" name="firstName"
                           value="<%= request.getParameter("firstName") != null ? request.getParameter("firstName") : "" %>">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Last name</label>
                    <input class="form-control" name="lastName"
                           value="<%= request.getParameter("lastName") != null ? request.getParameter("lastName") : "" %>">
                </div>

                <div class="col-md-6">
                    <label class="form-label">Email</label>
                    <input class="form-control" name="email"
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                </div>

                <div class="col-md-6">
                    <label class="form-label">Phone Number</label>
                    <input class="form-control" name="phonenum"
                           value="<%= request.getParameter("phonenum") != null ? request.getParameter("phonenum") : "" %>">
                </div>

                <div class="col-md-6">
                    <label class="form-label">Address</label>
                    <input class="form-control" name="address"
                           value="<%= request.getParameter("address") != null ? request.getParameter("address") : "" %>">
                </div>

                <div class="col-md-6">
                    <label class="form-label">City</label>
                    <input class="form-control" name="city"
                           value="<%= request.getParameter("city") != null ? request.getParameter("city") : "" %>">
                </div>

                <div class="col-md-4">
                    <label class="form-label">State</label>
                    <input class="form-control" name="state"
                           value="<%= request.getParameter("state") != null ? request.getParameter("state") : "" %>">
                </div>

                <div class="col-md-4">
                    <label class="form-label">Postal Code</label>
                    <input class="form-control" name="postalCode"
                           value="<%= request.getParameter("postalCode") != null ? request.getParameter("postalCode") : "" %>">
                </div>

                <div class="col-md-4">
                    <label class="form-label">Country</label>
                    <input class="form-control" name="country"
                           value="<%= request.getParameter("country") != null ? request.getParameter("country") : "" %>">
                </div>

                <div class="col-md-3">
                    <label class="form-label">Username</label>
                    <input class="form-control" name="userid"
                           value="<%= request.getParameter("userid") != null ? request.getParameter("userid") : "" %>">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Password</label>
                    <input type="password" class="form-control" name="password">
                </div>

            </div>

            <div class="mt-3">
                <button type="submit" class="btn btn-success">Create Account</button>
            </div>
        </form>
    <% } %>
</div>

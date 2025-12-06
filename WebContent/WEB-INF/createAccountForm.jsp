<%@ include file="/WEB-INF/escapeHTML.jsp" %>

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
            <strong><%= escapeHtml(request.getParameter("userid")) %></strong>.
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
                    <label class="form-label" for="firstName">First name</label>
                    <input class="form-control" id="firstName" name="firstName"
                           value="<%= escapeHtml(request.getParameter("firstName")) %>"
                           required>
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="lastName">Last name</label>
                    <input class="form-control" id="lastName" name="lastName"
                           value="<%= escapeHtml(request.getParameter("lastName")) %>"
                           required>
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="email">Email</label>
                    <input class="form-control" id="email" name="email"
                           value="<%= escapeHtml(request.getParameter("email")) %>"
                           required>
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="phonenum">Phone Number</label>
                    <input class="form-control" id="phonenum" name="phonenum"
                           value="<%= escapeHtml(request.getParameter("phonenum")) %>"
                           required>
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="address">Address</label>
                    <input class="form-control" id="address" name="address"
                           value="<%= escapeHtml(request.getParameter("address")) %>"
                           required>
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="city">City</label>
                    <input class="form-control" id="city" name="city"
                           value="<%= escapeHtml(request.getParameter("city")) %>"
                           required>
                </div>
                <div class="col-md-4">
                    <label class="form-label" for="state">State</label>
                    <input class="form-control" id="state" name="state"
                           value="<%= escapeHtml(request.getParameter("state")) %>"
                           required>
                </div>
                <div class="col-md-4">
                    <label class="form-label" for="postalCode">Postal Code</label>
                    <input class="form-control" id="postalCode" name="postalCode"
                           value="<%= escapeHtml(request.getParameter("postalCode")) %>"
                           required>
                </div>
                <div class="col-md-4">
                    <label class="form-label" for="country">Country</label>
                    <input class="form-control" id="country" name="country"
                           value="<%= escapeHtml(request.getParameter("country")) %>"
                           required>
                </div>
                <div class="col-md-3">
                    <label class="form-label" for="userid">Username</label>
                    <input class="form-control" id="userid" name="userid"
                           value="<%= escapeHtml(request.getParameter("userid")) %>"
                           required>
                </div>
                <div class="col-md-3">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>

            </div>

            <div class="mt-3">
                <button type="submit" class="btn btn-success">Create Account</button>
            </div>
        </form>
    <% } %>
</div>

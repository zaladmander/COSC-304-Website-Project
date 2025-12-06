<%@ include file="/WEB-INF/jdbc.jsp" %>
<%@ include file="/WEB-INF/auth.jsp" %>
<%@ include file="/WEB-INF/escapeHTML.jsp" %>

<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html>
<head>
    <shop:head pageName="Edit Account Info" />
</head>
<body>
    <jsp:include page="/WEB-INF/header.jsp" />



    <%
        String userName = (String) session.getAttribute("authenticatedUser");

        String address = "";
        String city = "";
        String state = "";
        String postalCode = "";
        String country = "";

        try {
            getConnection();
            String sql = "SELECT address, city, state, postalCode, country " +
                         "FROM customer WHERE userId = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, userName);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                address = rs.getString("address") != null ? rs.getString("address") : "";
                city = rs.getString("city") != null ? rs.getString("city") : "";
                state = rs.getString("state") != null ? rs.getString("state") : "";
                postalCode = rs.getString("postalCode") != null ? rs.getString("postalCode") : "";
                country = rs.getString("country") != null ? rs.getString("country") : "";
            }

            rs.close();
            ps.close();
            closeConnection();
        } catch (Exception e) {
            e.printStackTrace(); // Log the error to server logs
            request.setAttribute("dbError", "An error occurred while loading your account information. Please try again later.");
        }
    
    %>

    <%
        String dbError = (String) request.getAttribute("dbError");
        if (dbError != null && !dbError.isEmpty()) {
    %>
        <div style="color: red; font-weight: bold; margin: 1em 0;">
            <%= escapeHtml(dbError) %>
        </div>
    <%
        }
    %>
    <jsp:include page="/WEB-INF/handleEditUserInfo.jsp" />

    <%
        java.util.List<String> errors =
            (java.util.List<String>) request.getAttribute("editErrors");
        Boolean updatedObj = (Boolean) request.getAttribute("editUpdated");
        boolean updated = updatedObj != null && updatedObj;

        if ("POST".equalsIgnoreCase(request.getMethod()) && updated && (errors == null || errors.isEmpty())) {
            response.sendRedirect("customer.jsp");
            return;
        }
    %>

    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 col-lg-6 mx-auto">

                <h2 class="mb-3">Edit account info</h2>

                <% if (updated) { %>
                    <div class="alert alert-success">
                    Account info updated successfully.
                    </div>
                <% } %>

                <% if (errors != null && !errors.isEmpty()) { %>
                    <div class="alert alert-danger">
                        <ul class="mb-0">
                            <% for (String err : errors) { %>
                                <li><%= escapeHtml(err) %></li>
                            <% } %>
                        </ul>
                    </div>
                <% } %>

                <form action="editUserInfo.jsp" method="post">
                    <div class="mb-3">
                        <label class="form-label">Address</label>
                        <input type="text" name="address" class="form-control"
                               value="<%= escapeHtml(address) %>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">City</label>
                        <input type="text" name="city" class="form-control"
                               value="<%= escapeHtml(city) %>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">State / Province</label>
                        <input type="text" name="state" class="form-control"
                               value="<%= escapeHtml(state) %>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Postal Code</label>
                        <input type="text" name="postalCode" class="form-control"
                               value="<%= escapeHtml(postalCode) %>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Country</label>
                        <input type="text" name="country" class="form-control"
                               value="<%= escapeHtml(country) %>">
                    </div>

                    <hr class="my-4">

                    <div class="mb-3">
                        <label class="form-label">New password</label>
                        <input type="password" name="password" class="form-control">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Confirm new password</label>
                        <input type="password" name="confirmPassword" class="form-control">
                    </div>

                    <button type="submit" class="btn btn-primary">Save changes</button>
                    <a href="customer.jsp" class="btn btn-link">Cancel</a>
                </form>

            </div>
        </div>
    </div>
</body>
</html>

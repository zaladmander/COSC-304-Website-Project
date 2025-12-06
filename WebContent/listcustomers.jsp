<%@ include file="/WEB-INF/jdbc.jsp" %>
<%@ include file="/WEB-INF/auth.jsp" %>

<%@ page import="java.sql.*" %>
<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
    <shop:head pageName="Customer List" />
</head>
<body>
    <jsp:include page="/WEB-INF/header.jsp" />
<!-- redirect if not admin -->
<%
    String username = (String) session.getAttribute("authenticatedUser");
    if (username == null || !username.equals("admin304")) {
%>
    <script>
        window.location.href = "index.jsp";
    </script>
<%
        return;
    }
%>

<h1 class="text-center mt-4 mb-3">All Customers</h1>

    <div class="container mt-3">
        <div class="row justify-content-center">
            <div class="col-md-8">

                <table class="table table-striped table-bordered table-sm text-center">
                    <thead class="thead-light">
                        <tr>
                            <th scope="col">Customer ID</th>
                            <th scope="col">Name</th>
                            <th scope="col">UserID</th>
                            <th scope="col">Email</th>
                            <th scope="col">Phone</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        String sql =
                            "SELECT customerId, firstName, lastName, userid, email, phonenum " +
                            "FROM customer";

                        try {
                            getConnection();
                            PreparedStatement ps = con.prepareStatement(sql);
                            ResultSet rs = ps.executeQuery();

                            while (rs.next()) {
                                int cid = rs.getInt("customerId");
                                String fname = rs.getString("firstName");
                                String lname = rs.getString("lastName");
                                String userid = rs.getString("userid");
                                String email = rs.getString("email");
                                String phone = rs.getString("phonenum");
                    %>
                        <tr>
                            <td><%= cid %></td>
                            <td><%= fname + " " + lname %></td>
                            <td><%= userid %></td>
                            <td><%= email %></td>
                            <td><%= phone %></td>
                        </tr>
                    <%
                            }

                            rs.close();
                            ps.close();
                            closeConnection();

                        } catch (SQLException e) {
                    %>
                        <tr>
                            <td colspan="4">Error fetching customers: <%= e.getMessage() %></td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>

            </div>
        </div>
    </div>

</body>
</html>
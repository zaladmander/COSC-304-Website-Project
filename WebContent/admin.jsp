<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>

<!DOCTYPE html>
<html>
<head>
    <%
        String currentPage = "Sales Report";   
        request.setAttribute("currentPage", currentPage);
	%>

    <title>
		<%= (request.getAttribute("currentPage") != null ? request.getAttribute("currentPage") : "") %> 
		<%= (request.getAttribute("currentPage") != null ? " - " : "") %>
		<%= getServletContext().getInitParameter("siteTitle") %>
	</title>
	<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="header.jsp" />

<h1 class="text-center mt-4 mb-3">Admin Sales Report by Day</h1>
<div class="container mt-3">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <table class="table table-striped table-bordered table-sm text-center">
                <thead class="thead-light">
                    <tr>
                        <th scope="col">Order Date</th>
                        <th scope="col">Total Sales Amount</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    String sql =
                        "SELECT CONVERT(DATE, orderDate) AS orderDate, " +
                        "       SUM(totalAmount) AS totalAmount " +
                        "FROM ordersummary " +
                        "GROUP BY CONVERT(DATE, orderDate) " +
                        "ORDER BY CONVERT(DATE, orderDate) DESC";

                    try {
                        getConnection();
                        PreparedStatement ps = con.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();
                        NumberFormat money = NumberFormat.getCurrencyInstance();

                        while (rs.next()) {
                            String orderDate = rs.getString("orderDate");
                            double totalAmount = rs.getDouble("totalAmount");
                %>
                            <tr>
                                <td><%= orderDate %></td>
                                <td><%= money.format(totalAmount) %></td>
                            </tr>
                <%
                        }

                        rs.close();
                        ps.close();
                        closeConnection();
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='2'>Error generating sales report: "
                                    + e.getMessage() + "</td></tr>");
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>


</body>
</html>


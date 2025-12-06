<%@ include file="/WEB-INF/jdbc.jsp" %>
<%@ include file="/WEB-INF/auth.jsp" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
    <shop:head pageName="Sales Report" />
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

<h1 class="text-center mt-4 mb-3">Admin Sales Report by Day</h1>
<div class="container mt-3">
    <div class="row justify-content-center">
        <div class="col-md-6">

            <div class="mb-4">
                <canvas id="salesChart"></canvas>
            </div>

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

                        java.util.List<String> dates = new java.util.ArrayList<>();
                        java.util.List<Double> totals = new java.util.ArrayList<>();

                    try {
                        getConnection();
                        PreparedStatement ps = con.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();
                        NumberFormat money = NumberFormat.getCurrencyInstance();

                        while (rs.next()) {
                            String orderDate = rs.getString("orderDate");
                            double totalAmount = rs.getDouble("totalAmount");

                            dates.add(orderDate);
                            totals.add(totalAmount);
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
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        // Labels: order dates
        const salesLabels = [
            <% for (int i = 0; i < dates.size(); i++) { %>
                '<%= dates.get(i) %>'<%= (i < dates.size() - 1) ? "," : "" %>
            <% } %>
        ];

        // Data: total sales amounts
        const salesData = [
            <% for (int i = 0; i < totals.size(); i++) { %>
                <%= totals.get(i) %><%= (i < totals.size() - 1) ? "," : "" %>
            <% } %>
        ];

        const ctx = document.getElementById('salesChart').getContext('2d');

        new Chart(ctx, {
            type: 'bar',              // or 'line' if you want
            data: {
                labels: salesLabels,
                datasets: [{
                    label: 'Total Sales ($)',
                    data: salesData
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: true }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>

</body>
</html>
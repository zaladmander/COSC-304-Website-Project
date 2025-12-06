<%@ include file="/WEB-INF/jdbc.jsp" %>
<%@ include file="/WEB-INF/auth.jsp" %>
<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <shop:head pageName="Order Report" />
</head>
<body>
    <jsp:include page="/WEB-INF/header.jsp" />

    <%-- redirect if not admin --%>
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

    <h1 class="text-center mt-4 mb-3">Admin Order Report by Day</h1>

    <div class="container mt-3">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <table class="table table-striped table-bordered table-sm text-center">
                    <thead class="thead-light">
                        <tr>
                            <th scope="col">Order Date</th>
                            <th scope="col">Number of Orders</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            String sql =
                                "SELECT CONVERT(DATE, orderDate) AS orderDate, " +
                                "       COUNT(*) AS orderCount " +
                                "FROM ordersummary " +
                                "GROUP BY CONVERT(DATE, orderDate) " +
                                "ORDER BY CONVERT(DATE, orderDate) DESC";

                            java.util.List<String> orderDates = new java.util.ArrayList<>();
                            java.util.List<Integer> orderCounts = new java.util.ArrayList<>();

                            try {
                                getConnection();
                                PreparedStatement ps = con.prepareStatement(sql);
                                ResultSet rs = ps.executeQuery();

                                while (rs.next()) {
                                    String orderDate = rs.getString("orderDate");
                                    int orderCount = rs.getInt("orderCount");

                                    orderDates.add(orderDate);
                                    orderCounts.add(orderCount);
                        %>
                                    <tr>
                                        <td><%= orderDate %></td>
                                        <td><%= orderCount %></td>
                                    </tr>
                        <%
                                }

                                rs.close();
                                ps.close();
                                closeConnection();
                            } catch (SQLException e) {
                        %>
                                <tr>
                                    <td colspan="2">Error generating order report:
                                        <%= e.getMessage() %>
                                    </td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- graph section --%>
        <%
            // Build JS-friendly strings for labels and data
            String orderLabelsJoined = "";
            StringBuilder orderCountsCsv = new StringBuilder();

            for (int i = 0; i < orderDates.size(); i++) {
                if (i > 0) {
                    orderLabelsJoined += "','";
                    orderCountsCsv.append(",");
                }
                orderLabelsJoined += orderDates.get(i);
                orderCountsCsv.append(orderCounts.get(i));
            }
        %>

        <div class="row justify-content-center mt-4">
            <div class="col-md-8">
                <h2 class="text-center">Orders by Day</h2>
                <canvas id="ordersChart" height="120"></canvas>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const orderLabels = ['<%= orderLabelsJoined %>'];
        const orderCounts = [<%= orderCountsCsv.toString() %>];

        const ordersCtx = document.getElementById('ordersChart').getContext('2d');
        new Chart(ordersCtx, {
            type: 'bar',
            data: {
                labels: orderLabels,
                datasets: [{
                    label: 'Number of Orders',
                    data: orderCounts
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            precision: 0
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>

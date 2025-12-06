<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jdbc.jsp" %>

<%
    String userId = request.getParameter("userId");
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    try {
        getConnection();

        String sql =
            "SELECT o.orderId, o.orderDate, o.totalAmount, " +
            "       o.shiptoAddress, o.shiptoCity, o.shiptoState, " +
            "       o.shiptoPostalCode, o.shiptoCountry " +
            "FROM ordersummary o " +
            "JOIN customer c ON o.customerId = c.customerId " +
            "WHERE c.userid = ? " +
            "ORDER BY o.orderDate DESC";

        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userId);
        ResultSet rs = pstmt.executeQuery();

        if (!rs.next()) {
            out.println("<p>You have no orders.</p>");
            rs.close();
            pstmt.close();
            closeConnection();
            return;
        }
%>

<table border="1" cellpadding="5" cellspacing="0">
    <tr>
        <th>Order #</th>
        <th>Date</th>
        <th>Total</th>
        <th>Ship To</th>
    </tr>

<%
        while (rs.next()) {
            int orderId = rs.getInt("orderId");
%>
    <tr>
        <td>
            <%= orderId %>
        </td>

        <td><%= rs.getTimestamp("orderDate") %></td>

        <td><%= currFormat.format(rs.getDouble("totalAmount")) %></td>

        <!-- all location info grouped together -->
        <td>
            <%= rs.getString("shiptoAddress") %><br/>
            <%= rs.getString("shiptoCity") %>,
            <%= rs.getString("shiptoState") %>
            <%= rs.getString("shiptoPostalCode") %><br/>
            <%= rs.getString("shiptoCountry") %>
        </td>
    </tr>
<%
        }

        rs.close();
        pstmt.close();
        closeConnection();
    } catch (SQLException e) {
%>
    <p style="color:red;">Error loading your orders: <%= e.getMessage() %></p>
<%
    }
%>
</table>

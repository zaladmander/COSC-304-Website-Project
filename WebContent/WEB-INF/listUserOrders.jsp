<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jdbc.jsp" %>
<%@ include file="/WEB-INF/escapeHTML.jsp" %>

<%
    String userId = request.getParameter("userId");

    if (userId == null || userId.trim().isEmpty()) {
        out.println("<p>Invalid user ID.</p>");
        return;
    }

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    PreparedStatement pstmt = null;
    ResultSet rs = null;
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

        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();
%>
<%
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
        do {
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
            <%= escapeHtml(rs.getString("shiptoAddress")) %><br/>
            <%= escapeHtml(rs.getString("shiptoCity")) %>,
            <%= escapeHtml(rs.getString("shiptoState")) %>
            <%= escapeHtml(rs.getString("shiptoPostalCode")) %><br/>
            <%= escapeHtml(rs.getString("shiptoCountry")) %>
        </td>
    </tr>
<%
        } while (rs.next());
    } catch (SQLException e) {
        // Log the exception server-side for debugging
        System.err.println("Error loading user orders:");
        e.printStackTrace(System.err);
%>
    <p style="color:red;">Error loading your orders. Please try again later.</p>
<%
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            closeConnection();
        } catch (SQLException e) {
            // log error
        }
    }
%>
</table>

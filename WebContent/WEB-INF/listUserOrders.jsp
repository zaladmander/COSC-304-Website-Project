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
<table class="table table-bordered table-striped">
    <thead>
        <tr>
            <th>Order #</th>
            <th>Date</th>
            <th>Total</th>
            <th>Ship To</th>
        </tr>
    </thead>
    <tbody>
<%  
        do {
%>
        <tr>
            <td><%= rs.getInt("orderId") %></td>
            <td><%= rs.getTimestamp("orderDate") %></td>
            <td><%= currFormat.format(rs.getDouble("totalAmount")) %></td>
            <%
            String shipAddr   = rs.getString("shiptoAddress");
            String shipCity   = rs.getString("shiptoCity");
            String shipState  = rs.getString("shiptoState");
            String shipPostal = rs.getString("shiptoPostalCode");
            String shipCountry= rs.getString("shiptoCountry");

            boolean hasShip =
                (shipAddr   != null && !shipAddr.trim().isEmpty()) ||
                (shipCity   != null && !shipCity.trim().isEmpty()) ||
                (shipState  != null && !shipState.trim().isEmpty()) ||
                (shipPostal != null && !shipPostal.trim().isEmpty()) ||
                (shipCountry!= null && !shipCountry.trim().isEmpty());
            %>

            <td>
            <% if (hasShip) { %>
                <%= escapeHtml(shipAddr) %><br/>
                <%= escapeHtml(shipCity) %>
                <% if (shipState != null && !shipState.trim().isEmpty()) { %>,
                    <%= escapeHtml(shipState) %>
                <% } %><br/>
                <%= escapeHtml(shipPostal) %><br/>
                <%= escapeHtml(shipCountry) %>
            <% } else { %>
                N/A
            <% } %>
            </td>
        </tr>
<%
        } while (rs.next());
%>
    </tbody>
</table>
<%
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
            System.err.println("Error closing resources:");
            e.printStackTrace(System.err);
        }
    }
%>
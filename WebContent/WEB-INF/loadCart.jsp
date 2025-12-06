<%@ include file="jdbc.jsp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>

<%
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList =
    (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

String username = (String) session.getAttribute("authenticatedUser");

// If no cart in session but user is logged in, try to load from DB
if ((productList == null || productList.isEmpty()) && username != null) {
    productList = new HashMap<String, ArrayList<Object>>();

    try {
        getConnection();

        // find customerId
        Integer customerId = null;
        PreparedStatement custStmt = con.prepareStatement(
            "SELECT customerId FROM customer WHERE userid = ?");
        custStmt.setString(1, username);
        ResultSet custRs = custStmt.executeQuery();
        if (custRs.next()) {
            customerId = custRs.getInt("customerId");
        }
        custRs.close();
        custStmt.close();

        if (customerId != null) {
            // load lines from incart
            PreparedStatement stmt = con.prepareStatement(
                "SELECT i.productId, p.productName, i.price, i.quantity " +
                "FROM incart i " +
                "JOIN ordersummary o ON i.orderId = o.orderId " +
                "JOIN product p ON p.productId = i.productId " +
                "WHERE o.customerId = ?");
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String pid  = String.valueOf(rs.getInt("productId"));
                String name = rs.getString("productName");
                double price = rs.getDouble("price");
                int qty = rs.getInt("quantity");

                ArrayList<Object> prod = new ArrayList<Object>();
                prod.add(pid);
                prod.add(name);
                prod.add(price);
                prod.add(qty);

                productList.put(pid, prod);
            }
            rs.close();
            stmt.close();
        }

        closeConnection();
    } catch (SQLException e) {
        System.err.println("Error loading cart from DB: " + e);
    }

    session.setAttribute("productList", productList);
}
%>

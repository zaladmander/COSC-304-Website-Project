<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
String username = (String) session.getAttribute("authenticatedUser");
HashMap<String, ArrayList<Object>> productList =
    (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");


if (username != null) {
    try {
        getConnection();

        // 1) Find customerId
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
            // 2) Find or create cart order for this customer
            Integer cartOrderId = null;

            PreparedStatement findCart = con.prepareStatement(
                "SELECT TOP 1 orderId FROM ordersummary " +
                "WHERE customerId = ? AND totalAmount = 0 AND shiptoAddress IS NULL " +
                "ORDER BY orderDate DESC");
            findCart.setInt(1, customerId);
            ResultSet cartRs = findCart.executeQuery();
            if (cartRs.next()) {
                cartOrderId = cartRs.getInt("orderId");
            }
            cartRs.close();
            findCart.close();

            if (cartOrderId == null) {
                PreparedStatement newCart = con.prepareStatement(
                    "INSERT INTO ordersummary(orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId) " +
                    "VALUES (GETDATE(), 0, NULL, NULL, NULL, NULL, NULL, ?)",
                    Statement.RETURN_GENERATED_KEYS);
                newCart.setInt(1, customerId);
                newCart.executeUpdate();
                ResultSet keys = newCart.getGeneratedKeys();
                if (keys.next()) {
                    cartOrderId = keys.getInt(1);
                }
                keys.close();
                newCart.close();
            }

            if (cartOrderId != null) {
                // 3) Replace incart contents with the current session cart
                PreparedStatement deleteItems = con.prepareStatement(
                    "DELETE FROM incart WHERE orderId = ?");
                deleteItems.setInt(1, cartOrderId);
                deleteItems.executeUpdate();
                deleteItems.close();

                if (!productList.isEmpty()) {
                    PreparedStatement insertItem = con.prepareStatement(
                        "INSERT INTO incart(orderId, productId, quantity, price) " +
                        "VALUES (?, ?, ?, ?)");

                    for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
                        String pid = entry.getKey();
                        ArrayList<Object> prod = entry.getValue();

                        double price = Double.parseDouble(prod.get(2).toString());
                        int qty = Integer.parseInt(prod.get(3).toString());

                        insertItem.setInt(1, cartOrderId);
                        insertItem.setInt(2, Integer.parseInt(pid));
                        insertItem.setInt(3, qty);
                        insertItem.setDouble(4, price);
                        insertItem.addBatch();
                    }

                    insertItem.executeBatch();
                    insertItem.close();
                }
            }
        }

        closeConnection();
    } catch (SQLException e) {
        // If DB sync dies, just log it; cart still lives in session
        System.err.println("Error syncing cart to DB: " + e);
    }
}
%>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
	<%
		String currentPage = "Shipping";   
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

<%
    String orderId = request.getParameter("orderId");

    try {
        getConnection();

        // 1. Validate order id
        String orderSql = "SELECT COUNT(*) AS orderCount FROM ordersummary WHERE orderId = ?;";
        PreparedStatement orderPstmt = con.prepareStatement(orderSql);
        orderPstmt.setString(1, orderId);
        ResultSet orderRs = orderPstmt.executeQuery();
        orderRs.next();
        int orderCount = orderRs.getInt("orderCount");
        orderRs.close();
        orderPstmt.close();

        if (orderCount == 0) {
            out.println("<h2>Invalid Order Id, return to previous page and enter a valid Order Id.</h2>");
            closeConnection();
            return;
        }

        // 2. Start transaction
        con.setAutoCommit(false);

        // 3. Get all items in this order + current inventory in warehouse 1
        String sqlOrderItems =
            "SELECT op.productId, op.quantity, " +
            "       ISNULL(pi.quantity, 0) AS invQty " +
            "FROM orderproduct op " +
            "JOIN ordersummary os ON os.orderId = op.orderId " +
            "LEFT JOIN productinventory pi " +
            "       ON pi.productId = op.productId AND pi.warehouseId = 1 " +
            "WHERE os.orderId = ?;";

        PreparedStatement orderItemsPstmt = con.prepareStatement(sqlOrderItems);
        orderItemsPstmt.setString(1, orderId);
        ResultSet orderItemsRs = orderItemsPstmt.executeQuery();

        class OrderItem {
            int productId;
            int qty;
            int currentInv;
        }

        java.util.List<OrderItem> orderItems = new java.util.ArrayList<OrderItem>();
        boolean anyItem = false;

        boolean insufficient = false;
        int badProductId = -1;
        int needQty = 0;
        int haveQty = 0;

        // 4. Check inventory + print one line per product
        while (orderItemsRs.next()) {
            anyItem = true;

            OrderItem it = new OrderItem();
            it.productId  = orderItemsRs.getInt("productId");
            it.qty        = orderItemsRs.getInt("quantity");
            it.currentInv = orderItemsRs.getInt("invQty");   // 0 if null

            int newInv = it.currentInv - it.qty;

            // print using non-negative "new inventory" for display
            int displayNew = (newInv < 0 ? it.currentInv : newInv);
            out.println("Ordered product: " + it.productId +
                        " Qty: " + it.qty +
                        " Previous inventory: " + it.currentInv +
                        " New inventory: " + displayNew + "<br>");

            if (newInv < 0 && !insufficient) {
                insufficient = true;
                badProductId = it.productId;
                needQty = it.qty;
                haveQty = it.currentInv;
            }

            orderItems.add(it);
        }
        orderItemsRs.close();
        orderItemsPstmt.close();

        if (!anyItem) {
            con.rollback();
            con.setAutoCommit(true);
            closeConnection();
            out.println("<h2>No items found in the order.</h2>");
            out.println("<h3><a href=\"index.jsp\">Back to Main Page</a></h3>");
            return;
        }

        // 5. If anything was short, rollback and bail (no extra prints)
        if (insufficient) {
            con.rollback();
            con.setAutoCommit(true);
            closeConnection();
            out.println("<h2>Shipment not done. Insufficient inventory for product id: "
                        + badProductId + " (need " + needQty + ", have " + haveQty + ").</h2>");
            out.println("<h3><a href=\"index.jsp\">Back to Main Page</a></h3>");
            return;
        }

        // 6. Create shipment record
        String sqlInsertShipment =
            "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) " +
            "VALUES (GETDATE(), ?, ?);";
        PreparedStatement shipStmt = con.prepareStatement(
            sqlInsertShipment,
            Statement.RETURN_GENERATED_KEYS
        );
        shipStmt.setString(1, "Shipment for order " + orderId);
        shipStmt.setInt(2, 1); // warehouse 1

        int affected = shipStmt.executeUpdate();
        if (affected == 0) {
            con.rollback();
            con.setAutoCommit(true);
            closeConnection();
            out.println("<h2>Error creating shipment record.</h2>");
            out.println("<h3><a href=\"index.jsp\">Back to Main Page</a></h3>");
            return;
        }

        ResultSet shipKeys = shipStmt.getGeneratedKeys();
        int shipmentId = -1;
        if (shipKeys.next()) {
            shipmentId = shipKeys.getInt(1);
        }
        shipKeys.close();
        shipStmt.close();

        // 7. Update inventory for each item (no printing here, we already printed once)
        String sqlUpdateInv =
            "UPDATE productinventory " +
            "SET quantity = quantity - ? " +
            "WHERE productId = ? AND warehouseId = 1;";
        PreparedStatement updStmt = con.prepareStatement(sqlUpdateInv);
        for (OrderItem it : orderItems) {
            updStmt.setInt(1, it.qty);
            updStmt.setInt(2, it.productId);
            updStmt.executeUpdate();
        }
        updStmt.close();

        // 8. Commit and finish
        con.commit();
        con.setAutoCommit(true);
        closeConnection();

        out.println("<h2>Shipment successfully processed.</h2>");

    } catch (Exception e) {
        try {
            if (con != null) {
                con.rollback();
                con.setAutoCommit(true);
            }
        } catch (Exception ignore) { }
        out.println("<h2>Error processing shipment: " + e.getMessage() + "</h2>");
    }
%>

<h3><a href="index.jsp">Back to Main Page</a></h3>
</body>
</html>
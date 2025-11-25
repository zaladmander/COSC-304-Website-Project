<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<%
		String currentPage = "Order Confirmation";   
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
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

try 
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}
// Determine if valid customer id was entered (get customerId from database to verify)

try {
	getConnection();
	String custSql = "SELECT COUNT(*) AS custCount FROM customer WHERE customerId = ?;";
	PreparedStatement custPstmt = con.prepareStatement(custSql);
	// check custId is integer before setting parameter
	if (custId == null || custId.trim().isEmpty() || !custId.matches("\\d+")) {
		custId = "-1";
	}
	custPstmt.setString(1, custId);
	ResultSet custRs = custPstmt.executeQuery();
	custRs.next();
	int count = custRs.getInt("custCount");
	// Determine if there are products in the shopping cart
	// If either are not true, display an error message for each case individually
	// also if customerId is not integer display invalid customer id message
	if (count == 0)
	{
		out.println("<h2>Invalid Customer Id, return to previous page and enter a valid Customer Id.</h2>");
	}
	else if (productList == null || productList.isEmpty())
	{
		out.println("<h2>Your shopping cart is empty.</h2>");
	}
	// Both valid customer id and products in cart
	// Proceed to save order information to database
	else
	{
		// Insert order summary record and get the new orderId
		String orderSql = "INSERT INTO ordersummary (orderDate, customerId, totalAmount) VALUES (GETDATE(), ?, 0.0);";
		PreparedStatement orderPstmt = con.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
		orderPstmt.setString(1, custId);
		int rowsAffected = orderPstmt.executeUpdate();
		if (rowsAffected == 0)
		{
			out.println("<h2>Error inserting order summary record.</h2>");
		}
		else
		{
			ResultSet keys = orderPstmt.getGeneratedKeys();
			keys.next();
			int orderId = keys.getInt(1);
			
			// Insert each item into OrderProduct table using OrderId from previous INSERT
			String itemSql = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?);";
			PreparedStatement itemPstmt = con.prepareStatement(itemSql);
			
			double totalAmount = 0.0;
			// For each product in the cart
			// Here is the code to traverse through a HashMap
			// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext())
			{ 
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				String priceStr = (String) product.get(2);
				double price = Double.parseDouble(priceStr);
				int quantity = ((Integer) product.get(3)).intValue();
				
				itemPstmt.setInt(1, orderId);
				itemPstmt.setString(2, productId);
				itemPstmt.setInt(3, quantity);
				itemPstmt.setDouble(4, price);
				itemPstmt.executeUpdate();
				
				totalAmount += price * quantity;
			}
			
			// Update total amount for order record
			String updateSql = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?;";
			PreparedStatement updatePstmt = con.prepareStatement(updateSql);
			updatePstmt.setDouble(1, totalAmount);
			updatePstmt.setInt(2, orderId);
			updatePstmt.executeUpdate();
			
			// Print out order summary, list all items ordered in a table (product id, name, quantity, price, subtotal)
			NumberFormat money = NumberFormat.getCurrencyInstance();
			out.println("<h2>Order Placed Successfully!</h2>");
			out.println("<table border='1'>");
			out.println("<tr><th>Product Id</th><th>Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
			iterator = productList.entrySet().iterator();
			while (iterator.hasNext())
			{ 
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				String productName = (String) product.get(1);
				String priceStr = (String) product.get(2);
				double price = Double.parseDouble(priceStr);
				int quantity = ((Integer) product.get(3)).intValue();
				double subtotal = price * quantity;
				
				out.println("<tr>");
				out.println("<td>" + productId + "</td>");
				out.println("<td>" + productName + "</td>");
				out.println("<td>" + quantity + "</td>");
				out.println("<td>" + money.format(price) + "</td>");
				out.println("<td>" + money.format(subtotal) + "</td>");
				out.println("</tr>");
			}
			out.println("</table>");
			out.println("<p>Total Amount: " + money.format(totalAmount) + "</p>");

			out.println("<p>Order Id: " + orderId + "<br>");
			// print out customer id and name
			String custNameSql = "SELECT firstName, lastName FROM customer WHERE customerId = ?;";
			PreparedStatement custNamePstmt = con.prepareStatement(custNameSql);
			custNamePstmt.setString(1, custId);
			ResultSet custNameRs = custNamePstmt.executeQuery();
			custNameRs.next();
			String custFirstName = custNameRs.getString("firstName");
			String custLastName = custNameRs.getString("lastName");
			out.println("Customer Id: " + custId + "<br>");
			out.println("Customer Name: " + custFirstName + " " + custLastName + "</p>");

			// Clear the shopping cart
			session.removeAttribute("productList");

		} // End else order summary inserted
	} // End else valid customer id and products in cart
	custRs.close();
	custPstmt.close();
} // End try con
catch (SQLException e)
{
	out.println("SQLException: " + e);
}

%>
</BODY>
</HTML>


<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>
	<%
	String currentPage = "Order List";   
	request.setAttribute("currentPage", currentPage);
	%>

	<%= (request.getAttribute("currentPage") != null ? request.getAttribute("currentPage") : "") %> 
	<%= (request.getAttribute("currentPage") != null ? " - " : "") %>
	<%= getServletContext().getInitParameter("siteTitle") %>
</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="header.jsp" />
<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";
NumberFormat money = NumberFormat.getCurrencyInstance();

try (Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();
	// Write query to retrieve all order summary records
	ResultSet orders = stmt.executeQuery("SELECT o.orderId, o.orderDate, o.customerId, CONCAT(c.firstName, ' ', c.lastName) AS customerName, o.totalAmount" 
										+ " FROM ordersummary AS o"
										+ " JOIN customer AS c ON c.customerId = o.customerId"
										+ " ORDER BY o.orderId;");
	)
{
	PreparedStatement itemsStmt = con.prepareStatement(
        "SELECT productId, quantity, price " +
        "FROM orderproduct WHERE orderId = ? ORDER BY productId");
%>

<table border="1" cellpadding="3" cellspacing="0">
	<tr>
		<th>Order Id</th>
		<th>Order Date</th>
		<th>Customer Id</th>
		<th>Customer Name</th>
		<th>Total Amount</th>
	</tr>

<%
	// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
	// Write out product information 
	while (orders.next()) {
		int orderId     = orders.getInt("orderId");
		Timestamp odt   = orders.getTimestamp("orderDate");
		int custId      = orders.getInt("customerId");
		String custName = orders.getString("customerName");
		double total    = orders.getDouble("totalAmount");
%>

<!-- summary row -->
<tr>
	<td><%= orderId %></td>
	<td><%= odt %></td>
	<td><%= custId %></td>
	<td><%= custName %></td>
	<td><%= money.format(total) %></td>
</tr>

<!-- nested products table in a full-width row -->
<tr>
	<td colspan="5">
		<table border="1" cellpadding="3" cellspacing="0">
			<tr>
				<th>Product Id</th>
				<th>Quantity</th>
				<th>Price</th>
			</tr>
			<%
			itemsStmt.setInt(1, orderId);
			try (ResultSet items = itemsStmt.executeQuery()) {
				while (items.next()) {
			%>
			<tr>
				<td><%= items.getInt("productId") %></td>
				<td><%= items.getInt("quantity") %></td>
				<td><%= money.format(items.getDouble("price")) %></td>
			</tr>
			<%
				}
			}
			%>
		</table>
	</td>
</tr>

<%
} // end orders loop
itemsStmt.close();
%>
</table>

<%
} catch (SQLException e) {
	out.println("<pre style='color:red'>SQLException: " + e + "</pre>");
}
%>

</body>
</html>


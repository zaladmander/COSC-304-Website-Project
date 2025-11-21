<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>45's Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";
NumberFormat money = NumberFormat.getCurrencyInstance();

// Make the connection
try (Connection con = DriverManager.getConnection(url, uid, pw);)
{
	String sql;
	PreparedStatement pstmt;
	if (name == null || name.trim().isEmpty())
	{
		// Query to get all products
		sql = "SELECT productId, productName, productPrice FROM product ORDER BY productName;";
		pstmt = con.prepareStatement(sql);
		// H2 says All products
		%> <h2>All Products</h2> <%
	}
	else
	{
		// Query to get products that match search string
		sql = "SELECT productId, productName, productPrice FROM product WHERE productName LIKE ? ORDER BY productName;";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, "%" + name + "%");
		// H2 says Products matching 'name'
		%> <h2>Products matching '<%= name %>'</h2> <%
	}
	
	%> 

<table border="1" cellpadding="3" cellspacing="0">
	<tr>
		<th></th>
		<th>Product Name</th>
		<th>Price</th>
	</tr>
<%
	try (ResultSet products = pstmt.executeQuery();) 
	{
	// Print out the ResultSet

	while (products.next())
	{
		String productId   = products.getString("productId");
		String productName = products.getString("productName");
		double productPrice= products.getDouble("productPrice");

%>
	<tr>
		<td>
			<a href="addcart.jsp?
				id=<%= URLEncoder.encode(productId, "UTF-8") %> &
				name=<%= URLEncoder.encode(productName, "UTF-8") %>&
				price=<%= URLEncoder.encode(Double.toString(productPrice), "UTF-8") %>">
				Add to Cart
			</a>
		</td>
		<td><%= productName %></td>
		<td><%= money.format(productPrice) %></td>
	</tr>
<%
	} // End while
	} // End try products

} // End try con
catch (SQLException e)
{
	out.println("SQLException: " + e);
}
	// For each product create a link of the form
	// addcart.jsp?id=productId&name=productName&price=productPrice
	// Close connection

	// Useful code for formatting currency values:
	// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>
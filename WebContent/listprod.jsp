<%@ include file="/WEB-INF/jdbc.jsp" %>

<%@ page import="java.sql.*,java.net.URLEncoder" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html>
<head>
    <shop:head pageName="Products" />
</head>
<body>
	<jsp:include page="/WEB-INF/header.jsp" />

<% 
// Get product name to search for
String name = request.getParameter("productName");
String resultTitle = null;

// Note: Forces loading of SQL Server driver
try {// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
	out.println("ClassNotFoundException: " +e);
}
%>

<%
// Make the connection
try {
	getConnection();
	String sql;
	PreparedStatement pstmt;
	if (name == null || name.trim().isEmpty()) {
		// Query to get all products
		sql = "SELECT p.productId, p.productName, p.productPrice, p.productImageURL, c.categoryName " +
				"FROM Product p JOIN Category c ON p.categoryId = c.categoryId " +
				"ORDER BY p.productName;";
		pstmt = con.prepareStatement(sql);
		resultTitle = "All Products";
	} else {
		// Query to get products that match search string
		sql = "SELECT p.productId, p.productName, p.productPrice, p.productImageURL, c.categoryName " +
				"FROM Product p JOIN Category c ON p.categoryId = c.categoryId " +
				"WHERE p.productName LIKE ? " +
				"ORDER BY p.productName;";
		pstmt = con.prepareStatement(sql);	
		pstmt.setString(1, "%" + name + "%");
		resultTitle = "Products matching '" + name + "'";
	}	
%> 

<%
	try (ResultSet products = pstmt.executeQuery()) {
		if (!products.isBeforeFirst()) {
%>
			<p>No products found.</p>
<%
		} else {
%>
			<shop:displayProductGrid productResultSet="<%= products %>" title="<%= resultTitle %>" />
<%
		}
	}
%>

<%
} catch (SQLException e) {
	out.println("SQLException: " + e);
} finally {
	closeConnection();
}
%>

</body>
</html>
<%@ include file="/WEB-INF/jdbc.jsp" %>
<%@ include file="/WEB-INF/productSearch.jsp" %>

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
String resultTitle = "";

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
	String sql = buildProductSearchSQL(request);
    PreparedStatement pstmt = con.prepareStatement(sql);

    bindProductSearchSQL(pstmt, request);

    resultTitle = titleProductSearchSQL(request);
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
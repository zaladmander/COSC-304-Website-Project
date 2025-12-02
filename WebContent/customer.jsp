<%@ include file="/WEB-INF/jdbc.jsp" %>
<%@ include file="/WEB-INF/auth.jsp"%>

<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>

<%@ page import="java.text.NumberFormat" %>

<!DOCTYPE html>
<html>
<head>
    <shop:headContent pageTitle="Customer Information" />
</head>
<body>
	<jsp:include page="/WEB-INF/header.jsp" />

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// Print Customer information
try {
	getConnection();

	String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city," +
				" state, postalCode, country, userId " +
				"FROM Customer WHERE userId = ?";
	PreparedStatement ps = con.prepareStatement(sql);
	ps.setString(1, userName);
	ResultSet rs = ps.executeQuery();

	if (rs.next()) {
		out.println("<h2>Customer Information</h2>");
		out.println("<p>Id: " + rs.getString("customerId") + "</p>");
		out.println("<p>Name: " + rs.getString("firstName") + " " + rs.getString("lastName") + "</p>");
		out.println("<p>Username: " + rs.getString("userId") + "</p>");
		out.println("<p>Email: " + rs.getString("email") + "</p>");
		out.println("<p>Phone: " + rs.getString("phonenum") + "</p>");
		out.println("<p>Address: " + rs.getString("address") + ", " +
					rs.getString("city") + ", " +
					rs.getString("state") + " " +
					rs.getString("postalCode") + ", " +
					rs.getString("country") + "</p>");
	} else {
		out.println("<p>No customer information found.</p>");
	}

	rs.close();
	ps.close();
	closeConnection();
} catch (SQLException e) {
	out.println("<p>Error retrieving customer information: " + e + "</p>");
}
%>

</body>
</html>


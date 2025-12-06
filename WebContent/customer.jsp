<%@ include file="/WEB-INF/jdbc.jsp" %>
<%@ include file="/WEB-INF/auth.jsp"%>
<%@ include file="/WEB-INF/escapeHTML.jsp" %>

<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>

<%@ page import="java.text.NumberFormat" %>

<!DOCTYPE html>
<html>
<head>
    <shop:head pageName="Customer Information" />
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

	if (rs.next()) { %>
	<div class='container mt-4'>
		<div class='row'>
			<div class='col-md-8 col-lg-6 mx-auto'>

			<div class='d-flex justify-content-between align-items-center mb-3'>
				<h2 class='mb-0'>Customer Information</h2>
				<form action='editUserInfo.jsp' method='get' class='mb-0'>
					<button type='submit' class='btn btn-outline-primary btn-sm'>Edit info</button>
				</form>
			</div>

			<p><strong>Id:</strong> <%= rs.getInt("customerId") %></p>
			<p><strong>Name:</strong> <%= escapeHtml(rs.getString("firstName")) %> <%= escapeHtml(rs.getString("lastName")) %></p>
			<p><strong>Username:</strong> <%= escapeHtml(rs.getString("userId")) %></p>
			<p><strong>Email:</strong> <%= escapeHtml(rs.getString("email")) %></p>
			<p><strong>Phone:</strong> <%= escapeHtml(rs.getString("phonenum")) %></p>
			<p><strong>Address:</strong> <%= escapeHtml(rs.getString("address")) %>, <%= escapeHtml(rs.getString("city")) %>, <%= escapeHtml(rs.getString("state")) %> <%= escapeHtml(rs.getString("postalCode")) %>, <%= escapeHtml(rs.getString("country")) %></p>

			</div>
		</div>
	</div>
<% } else { %>
	<div class='container mt-4'>
		<div class='row'>
			<div class='col-md-8 col-lg-6 mx-auto'>
				<p>No customer information found.</p>
			</div>
		</div>
	</div>
<% } %>
<%
	rs.close();
	ps.close();
} catch (SQLException e) {
	out.println("<p>Error retrieving customer information: " + escapeHtml(e.getMessage()) + "</p>");
} finally {
	closeConnection();
}
%>

</body>
</html>


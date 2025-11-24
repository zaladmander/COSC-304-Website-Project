<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<%
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";

// Make the connection
try (Connection con = DriverManager.getConnection(url, uid, pw);) {
    String productName = "Product";   // fallback
    String productId = request.getParameter("id");

    if (productId != null) {
        String sql = "SELECT productName FROM Product WHERE productId = ?";
        java.sql.PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(productId));
        java.sql.ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            productName = rs.getString("productName");
        }

        rs.close();
        ps.close();
    }

    // use the product name as the “current page” label
    request.setAttribute("currentPage", productName);
} catch (SQLException e) 
{
    out.println("SQLException: " + e);
}
%>


<html>
<head>
    <title>
        <%= (request.getAttribute("currentPage") != null ? request.getAttribute("currentPage") : "") %> 
        <%= (request.getAttribute("currentPage") != null ? " - " : "") %>
        <%= getServletContext().getInitParameter("siteTitle") %>
    </title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Get product name to search for
// TODO: Retrieve and display info for the product
// String productId = request.getParameter("id");

String sql = "";

// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping
%>

</body>
</html>


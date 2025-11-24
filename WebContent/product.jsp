<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*" %>

<%
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
    String uid = "sa";
    String pw = "304#sa#pw";

    // --- Retrieve product ID from query string ---
    String productId = request.getParameter("id");

    // --- Default values (if product not found) ---
    String productName = "Product";
    Double productPrice = null;
    String productDesc = "";
    String imageUrl = null;

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {

        if (productId != null) {
            String sql =
                "SELECT productName, productPrice, productImageURL, productDesc " +
                "FROM Product WHERE productId = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(productId));
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                productName = rs.getString("productName");
                productPrice = rs.getDouble("productPrice");
                imageUrl = rs.getString("productImageURL");
                productDesc = rs.getString("productDesc");
            }

            rs.close();
            ps.close();
        }

        // Page title → use the product name
        request.setAttribute("currentPage", productName);

    } catch (SQLException e) {
        out.println("<p>Error loading product: " + e + "</p>");
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
<jsp:include page="header.jsp" />

<%
    NumberFormat money = NumberFormat.getCurrencyInstance();
%>


<div class="container mt-4">

    <h1><%= productName %></h1>

    <div class="row">

        <!-- IMAGE COLUMN -->
        <div class="col-md-6">

            <%-- URL-based product image --%>
            <% if (imageUrl != null && !imageUrl.isEmpty()) { %>
                <img src="<%= imageUrl %>" class="img-fluid mb-3">
            <% } %>

            <%-- Binary DB image using displayImage.jsp --%>
            <img src="displayImage.jsp?id=<%= productId %>" class="img-fluid">

        </div>

        <!-- INFO COLUMN -->
        <div class="col-md-6">

            <h3>Price:
                <% if (productPrice != null) { %>
                    <%= money.format(productPrice) %>
                <% } else { %>
                    (Unknown)
                <% } %>
            </h3>


            <p class="mt-3"><%= productDesc %></p>

            <a href="addcart.jsp?id=<%= productId %>" class="btn btn-primary mt-3">
                Add to Cart
            </a>

            <br><br>

            <a href="listprod.jsp">Continue Shopping</a>
        </div>
    </div>

</div>

</body>
</html>

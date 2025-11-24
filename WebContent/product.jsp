<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>

<%
    // --- Retrieve product ID from query string ---
    String productId = request.getParameter("id");

    // --- Default values (if product not found) ---
    String productName = "Product";
    Double productPrice = null;
    String productDesc = "";
    String imageUrl = null;
    byte[] productImage = null;
    boolean hasUrl = false;
    boolean hasBlob = false;
    boolean hasAnyImage = false;

    try {
		getConnection();

        if (productId != null) {
            String sql =
                "SELECT productName, productPrice, productImageURL, productImage, productDesc " +
                "FROM Product WHERE productId = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(productId));
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                productName = rs.getString("productName");
                productPrice = rs.getDouble("productPrice");
                imageUrl = rs.getString("productImageURL");
                productImage = rs.getBytes("productImage");
                productDesc = rs.getString("productDesc");
                hasUrl = (imageUrl != null && !imageUrl.trim().isEmpty());
                hasBlob = (productImage != null && productImage.length > 0);
                hasAnyImage = hasUrl || hasBlob;
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
    request.setAttribute("productId", productId);
    request.setAttribute("productName", productName);
    request.setAttribute("productPrice", productPrice);
%>


<div class="container mt-4">

    <h1><%= productName %></h1>

    <div class="row">

        <div class="col-md-6">
            <% if (!hasAnyImage) { %>
                <p class="text-muted">No image available.</p>
            <% } else if (hasUrl && hasBlob) { %>
                <div id="productCarousel" class="carousel slide" data-ride="carousel" style="width:400px;">
                
                    <ol class="carousel-indicators">
                        <li data-target="#productCarousel" data-slide-to="0" class="active"></li>
                        <li data-target="#productCarousel" data-slide-to="1"></li>
                    </ol>

                    <div class="carousel-inner">
                        <div class="item active">
                            <img src="<%= imageUrl %>" class="img-responsive">
                        </div>
                        <div class="item">
                            <img src="displayImage.jsp?id=<%= productId %>" class="img-responsive">
                        </div>
                    </div>

                    <a class="left carousel-control" href="#productCarousel" data-slide="prev">
                        <span class="glyphicon glyphicon-chevron-left"></span>
                    </a>
                    <a class="right carousel-control" href="#productCarousel" data-slide="next">
                        <span class="glyphicon glyphicon-chevron-right"></span>
                    </a>

                </div>
            <% } else if (hasUrl) { %>
                <img src="<%= imageUrl %>" class="img-responsive">
            <% } else { %>
                <img src="displayImage.jsp?id=<%= productId %>" class="img-responsive">
            <% } %>
        </div>

        <div class="col-md-6">
            <h3>Price:
                <% if (productPrice != null) { %>
                    <%= money.format(productPrice) %>
                <% } else { %>
                    (Unknown)
                <% } %>
            </h3>

            <h5 class="text-muted mb-2">
                Product ID: <%= productId %>
            </h5>

            <p class="mt-3"><%= productDesc %></p>

            <shop:addToCart
                id="${productId}"
                name="${productName}"
                price="${productPrice}" />

            <br><br>

            <a href="listprod.jsp">Continue Shopping</a>
        </div>
    </div>

</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>

</body>
</html>


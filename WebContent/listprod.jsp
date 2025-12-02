<%@ include file="/WEB-INF/jdbc.jsp" %>

<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html>
<head>
    <shop:head pageName="Products" />

	<style>
		.product-grid {
			display: flex;
			flex-wrap: wrap;
			gap: 20px;
			margin-top: 20px;
		}

		.product-card {
			border: 1px solid #ddd;
			border-radius: 6px;
			padding: 12px;
			width: 260px;          /* tweak as you like */
			background-color: #fff;
		}

		.product-card h3 {
			font-size: 1rem;
			margin: 8px 0;
		}

		.product-card .product-category {
			font-size: 0.85rem;
			color: #666;
		}

		.product-card .product-price {
			font-weight: bold;
			margin-top: 6px;
		}

		.product-card .add-to-cart {
			margin-bottom: 8px;
		}

		.product-card-title {
			font-size: 1.1rem;
			font-weight: 600;
		}

		.product-card-price {
			font-size: 1.05rem;
			font-weight: bold;
			color: black;
		}

		a {
			text-decoration: none;
			color: inherit;
		}

		.product-card-category {
			font-size: 0.9rem;
			color: #666;
		}

		.product-img-wrap {
			width: 100%;
			height: 180px;              /* adjust as needed */
			overflow: hidden;
			display: flex;
			justify-content: center;
			align-items: center;
			background: #f8f8f8;        /* optional Amazon vibes */
			border-bottom: 1px solid #eee;
		}

		.product-img {
			max-width: 100%;
			max-height: 100%;
			object-fit: contain;        /* DON'T crop */
		}

	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/header.jsp" />

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


NumberFormat money = NumberFormat.getCurrencyInstance();

// Make the connection
try {
	getConnection();
	String sql;
	PreparedStatement pstmt;
	if (name == null || name.trim().isEmpty())
	{
		// Query to get all products
		sql = "SELECT p.productId, p.productName, p.productPrice, p.productImageURL, c.categoryName " +
				"FROM Product p JOIN Category c ON p.categoryId = c.categoryId " +
				"ORDER BY p.productName;";
		pstmt = con.prepareStatement(sql);
		// H2 says All products
		%> <h2>All Products</h2> <%
	}
	else
	{
		// Query to get products that match search string
		sql = "SELECT p.productId, p.productName, p.productPrice, p.productImageURL, c.categoryName " +
				"FROM Product p JOIN Category c ON p.categoryId = c.categoryId " +
				"WHERE p.productName LIKE ? " +
				"ORDER BY p.productName;";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, "%" + name + "%");
		// H2 says Products matching 'name'
		%> <h2>Products matching '<%= name %>'</h2> <%
	}
	
	%> 

<div class="product-grid">
<%
    try (ResultSet products = pstmt.executeQuery();) {
        while (products.next()) {
            String productId    = products.getString("productId");
            String productName  = products.getString("productName");
            double productPrice = products.getDouble("productPrice");
            String productImageURL = products.getString("productImageURL");
            String categoryName = products.getString("categoryName");

            request.setAttribute("productId", productId);
            request.setAttribute("productName", productName);
            request.setAttribute("productPrice", productPrice);
%>
    <div class="product-card">
		<div class="product-card-image">
			<a href="product.jsp?id=<%= productId %>">
				<div class="product-img-wrap">
					<img src="<%= productImageURL %>" 
						alt="<%= productName %>" 
						class="product-img">
				</div>
			</a>
		</div>


        <h3 class="product-card-title">
            <a href="product.jsp?id=<%= productId %>">
                <%= productName %>
            </a>
        </h3>

        <div class="product-card-category">
            <%= categoryName %>
        </div>

        <div class="product-card-price">
			<a href="product.jsp?id=<%= productId %>">
				<%= money.format(productPrice) %>
			</a>
        </div>

		<div class="add-to-cart">
            <shop:addToCart
                id="${productId}"
                name="${productName}"
                price="${productPrice}" />
        </div>
    </div>
<%
        } // end while
    } // end try products
%>
</div>

<%
	} // End try
catch (SQLException e)
{
	out.println("SQLException: " + e);
}
%>

</body>
</html>
<%@ tag language="java" pageEncoding="UTF-8"
        import="java.text.NumberFormat" %>

<%@ attribute name="productResultSet" required="true" type="java.sql.ResultSet" %>
<%@ attribute name="title" required="false" type="java.lang.String" %>

<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>

<h2>
    <%= (title != null && !title.isEmpty()) ? title : "All Products" %>
</h2>

<div class="product-grid">
<%!
    NumberFormat money = NumberFormat.getCurrencyInstance();
%>

<%
    while (productResultSet.next()) {
        String productId    = productResultSet.getString("productId");
        String productName  = productResultSet.getString("productName");
        double productPrice = productResultSet.getDouble("productPrice");
        String productImageURL = productResultSet.getString("productImageURL");
        String categoryName = productResultSet.getString("categoryName");
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
                    id="<%= productId %>"
                    name="<%= productName %>"
                    price="<%= productPrice %>" />
            </div>
        </div>

<%
    } // end while
%>

</div>
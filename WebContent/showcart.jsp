<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>
<%@ include file="/WEB-INF/jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <shop:head pageName="Shopping Cart" />
</head>
<body>
    <jsp:include page="/WEB-INF/header.jsp" />

    <div class="container mt-4">
        <jsp:include page="/WEB-INF/loadCart.jsp" />
        <%
            @SuppressWarnings({"unchecked"})
            HashMap<String, ArrayList<Object>> productList =
                    (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

            if (productList == null || productList.isEmpty()) {
        %>
            <h1>Your shopping cart is empty!</h1>
            <p><a href="listprod.jsp">Continue Shopping</a></p>
        <%
            } else {

                NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                double orderTotal = 0.0;

                // Open DB connection for image lookups
                getConnection();
        %>

        <div class="row">
            <!-- Cart items -->
            <div class="col-md-8">
                <h1>Your Shopping Cart</h1>

                <%
                    for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
                        String id = entry.getKey();
                        ArrayList<Object> product = entry.getValue();

                        String name = (product.size() > 1 && product.get(1) != null) ? product.get(1).toString() : "";
                        double price = 0.0;
                        int qty = 0;

                        try {
                            if (product.size() > 2 && product.get(2) != null) {
                                price = Double.parseDouble(product.get(2).toString());
                            }
                        } catch (Exception e) { }

                        try {
                            if (product.size() > 3 && product.get(3) != null) {
                                qty = Integer.parseInt(product.get(3).toString());
                            }
                        } catch (Exception e) { }

                        if (qty <= 0) {
                            qty = 1;
                        }

                        double lineTotal = price * qty;
                        orderTotal += lineTotal;

                        // Figure out image source: prefer URL, otherwise blob via displayImage.jsp
                        String imageSrc = null;
                        try {
                            PreparedStatement ps = con.prepareStatement(
                                    "SELECT productImageURL, productImage FROM product WHERE productId = ?");
                            ps.setInt(1, Integer.parseInt(id));
                            ResultSet rs = ps.executeQuery();

                            if (rs.next()) {
                                String url = rs.getString("productImageURL");
                                Blob img = rs.getBlob("productImage");

                                if (url != null && url.trim().length() > 0) {
                                    imageSrc = url;
                                } else if (img != null) {
                                    imageSrc = "displayImage.jsp?id=" + id;
                                }
                            }

                            rs.close();
                            ps.close();
                        } catch (SQLException e) {
                            // image lookup failed, ignore
                        }
                %>

                <!-- Single cart item -->
				<div class="p-3 mb-3" style="background:#f5f5f5; border-radius:8px;">
                    <div class="row align-items-center" style="margin:0;">
                        <!-- Image -->
                        <div class="col-3 col-sm-2 p-3">
                            <% if (imageSrc != null) { %>
                                <img src="<%= imageSrc %>"
									alt="<%= name %>"
									style="
										width:120px;
										height:120px;
										object-fit:contain;
										background:white;
										border:1px solid #ddd;
										border-radius:4px;
										padding:4px;
									">
                            <% } else { %>
						<div style="
								width:120px;
								height:120px;
								background:white;
								border:1px solid #ddd;
								border-radius:4px;
								padding:4px;
								display:flex;
								align-items:center;
								justify-content:center;
								font-size:12px;
								color:#aaa;">
							No Image
						</div>
            				<% } %>
                        </div>

                        <!-- Details + quantity + actions -->
                        <div class="col-9 col-sm-7">
                            <div class="card-body py-3">
                                <h5 class="card-title mb-1"><%= name %></h5>
                                <p class="mb-1 text-muted">Product ID: <%= id %></p>
                                <p class="mb-1">Price: <%= currFormat.format(price) %></p>

                                <!-- Quantity form -->
                                <form id="updateForm<%= id %>" method="post" action="updatecart.jsp" class="form-inline">
                                    <input type="hidden" name="id" value="<%= id %>">
                                    <label class="mb-0 mr-2">Quantity</label>
                                    <input type="number"
                                           name="quantity"
                                           min="1"
                                           value="<%= qty %>"
                                           class="form-control form-control-sm mr-2"
                                           style="width:80px; text-align:right;">
                                </form>

                                <div class="mt-2">
                                    <!-- Update uses the quantity form above -->
                                    <button type="submit"
                                            form="updateForm<%= id %>"
                                            class="btn btn-sm btn-primary mr-2">
                                        Update
                                    </button>

                                    <!-- Remove item -->
                                    <form method="post"
                                          action="removecart.jsp"
                                          style="display:inline;">
                                        <input type="hidden" name="id" value="<%= id %>">
                                        <button type="submit" class="btn btn-sm btn-danger">
                                            Remove
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Line subtotal on the right -->
                        <div class="col-12 col-sm-3 text-right pr-4">
                            <p class="mb-1 font-weight-bold"><%= currFormat.format(lineTotal) %></p>
                            <small class="text-muted">Subtotal</small>
                        </div>
                    </div>
                </div>

                <%
                    } // end for

                    // Done with DB
                    closeConnection();
                %>
            </div>

            <!-- Order summary -->
            <div class="col-md-4">
                <div class="card mt-4 mt-md-0">
                    <div class="card-body">
                        <h5 class="card-title">Order Summary</h5>
                        <p class="d-flex justify-content-between mb-3">
                            <span>Order total</span>
                            <span><strong><%= currFormat.format(orderTotal) %></strong></span>
                        </p>

                        <a href="checkout.jsp" class="btn btn-success btn-block mb-2">
                            Check Out
                        </a>
                        <a href="listprod.jsp" class="btn btn-link btn-block">
                            Continue Shopping
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <%
            } // end non-empty-cart else
        %>
    </div>
</body>
</html>

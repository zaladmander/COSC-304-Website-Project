<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<%
request.setCharacterEncoding("UTF-8");

// Get cart from session
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList =
    (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList != null) {
    String id = request.getParameter("id");
    String qtyStr = request.getParameter("quantity");

    int qty = 1;   // default

    try {
        qty = Integer.parseInt(qtyStr);
    } catch (Exception e) {
        qty = 1;   // invalid -> clamp
    }

    // basic validation: quantity must be at least 1
    if (qty < 1) {
        qty = 1;
    }

    if (id != null && productList.containsKey(id)) {
        ArrayList<Object> product = productList.get(id);
        // index 3 is quantity (same as in addcart.jsp)
        product.set(3, Integer.valueOf(qty));
    }

    session.setAttribute("productList", productList);
    %>
    <jsp:include page="/WEB-INF/syncCart.jsp" />
    <%

}

// go back to cart
response.sendRedirect("showcart.jsp");
%>

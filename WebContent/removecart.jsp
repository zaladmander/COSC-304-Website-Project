<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<%
request.setCharacterEncoding("UTF-8");

// Get cart from session
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList =
    (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

String id = request.getParameter("id");

if (productList != null && id != null) {
    productList.remove(id);    // yeet it from the cart
    session.setAttribute("productList", productList);
    %>
    <jsp:include page="/WEB-INF/syncCart.jsp" />
    <%
}

// back to cart page no matter what
response.sendRedirect("showcart.jsp");
%>

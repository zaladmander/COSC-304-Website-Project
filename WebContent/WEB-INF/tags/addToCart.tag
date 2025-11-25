<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag import="java.net.URLEncoder" %>

<%@ attribute name="id"    required="true" type="java.lang.String" %>
<%@ attribute name="name"  required="true" type="java.lang.String" %>
<%@ attribute name="price" required="true" type="java.lang.Double" %>

<%
    String encId    = URLEncoder.encode(id, "UTF-8");
    String encName  = URLEncoder.encode(name, "UTF-8");
    String encPrice = URLEncoder.encode(String.valueOf(price), "UTF-8");
%>

<a href="addcart.jsp?id=<%= encId %>&name=<%= encName %>&price=<%= encPrice %>"
   class="btn btn-primary mt-3">
    Add to Cart
</a>

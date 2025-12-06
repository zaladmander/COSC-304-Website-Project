<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html>
<head>
	<shop:head pageName="Welcome" />
</head>
<body>
	<jsp:include page="/WEB-INF/header.jsp" />
<h1 align="center">Welcome to <%= getServletContext().getInitParameter("siteTitle") %></h1>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
	if (userName != null)
		out.println("<h3 align=\"center\">Signed in as: "+userName+"</h3>");
%>
</body>
</head>



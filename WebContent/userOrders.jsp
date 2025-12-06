<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/auth.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <shop:head pageName="User Orders" />
</head>
<body>
    <jsp:include page="/WEB-INF/header.jsp" />

    <div class="container mt-5" style="max-width: 800px;">
        <h2 class="mb-4">Your Orders</h2>

        <jsp:include page="/WEB-INF/listUserOrders.jsp">
            <jsp:param name="userId" value="${sessionScope.authenticatedUser}" />
        </jsp:include>
    </div>
</body>
</html>
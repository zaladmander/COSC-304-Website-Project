<%@ include file="/WEB-INF/jdbc.jsp" %>
<%@ include file="/WEB-INF/auth.jsp" %>

<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html>
<html>
<head>
    <shop:head pageName="Sales Report" />
</head>
<body>
    <jsp:include page="/WEB-INF/header.jsp" />

<!-- redirect if not admin -->
<%
    String username = (String) session.getAttribute("authenticatedUser");
    if (username == null || !username.equals("admin304")) {
%>
    <script>
        window.location.href = "index.jsp";
    </script>
<%
        return;
    }
%>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-6 text-center">

            <h2 class="mb-4">Admin Portal</h2>

            <div class="list-group">
                <a href="listcustomers.jsp" class="list-group-item list-group-item-action">
                    List All Customers
                </a>
                <a href="listorder.jsp" class="list-group-item list-group-item-action">
                    List All Orders
                </a>
                <a href="listsales.jsp" class="list-group-item list-group-item-action">
                    Sales Report
                </a>

                <a href="ship.jsp?orderId=1" class ="list-group-item list-group-item-action">
                    Test Ship orderId=1
                </a>

                <a href="ship.jsp?orderId=3" class ="list-group-item list-group-item-action">
                    Test Ship orderId=3
                </a>

                <a href="loaddata.jsp" class="list-group-item list-group-item-action text-danger">
                    Reset Database
                </a>

            </div>

        </div>
    </div>
</div>



</body>
</html>


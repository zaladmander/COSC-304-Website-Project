<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="shop" tagdir="/WEB-INF/tags" %>
<%@ include file="/WEB-INF/alreadyLoggedIn.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <shop:head pageName="Create Account" />
</head>
<body>
    <jsp:include page="/WEB-INF/header.jsp" />

    <div class="container my-4">
        <h2>Create Account</h2>

        <!-- 1. run logic (only does anything on POST) -->
        <jsp:include page="/WEB-INF/handleCreateAccount.jsp" />

        <!-- 2. render UI (form or success message) -->
        <jsp:include page="/WEB-INF/createAccountForm.jsp" />
    </div>
</body>
</html>

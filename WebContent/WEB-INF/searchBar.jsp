<form method="get" action="listprod.jsp"
        role="search"
        style="display: flex; width: 100%;">

    <jsp:include page="/WEB-INF/categoryDropdown.jsp" />

    <input
        type="text"
        name="productName"
        class="form-control"
        placeholder="Search products"
        style="flex: 1;"
        value="<%= request.getParameter("productName") != null ? request.getParameter("productName") : "" %>"
    />

    <button type="submit"
            class="btn btn-primary"
            style="padding: 6px 18px;">
        Search
    </button>
</form>


<%@ include file="/WEB-INF/jdbc.jsp" %>
<%@ page import="java.sql.*" %>

<%
    String selectedCat = request.getParameter("categoryId");
    if (selectedCat == null) {
        selectedCat = "";
    }

    ResultSet rs = null;
    PreparedStatement pstmt = null;

    try {
        getConnection();

        String sql = "SELECT categoryId, categoryName " +
                    "FROM Category " +
                    "ORDER BY categoryName";

        pstmt = con.prepareStatement(sql);
        rs = pstmt.executeQuery();
%>

<select name="categoryId"
        class="form-control"
        style="max-width: 160px;">

    <option value="" <%= selectedCat.isEmpty() ? "selected" : "" %>>
        All categories
    </option>

<%
        while (rs.next()) {
            int id = rs.getInt("categoryId");
            String name = rs.getString("categoryName");
            String idStr = Integer.toString(id);
            boolean isSelected = idStr.equals(selectedCat);
%>
    <option value="<%= idStr %>" <%= isSelected ? "selected" : "" %>>
        <%= name %>
    </option>
<%
        } // end while
%>
</select>

<%
    } catch (SQLException e) {
        out.println("<!-- categoryDropdown error: " + e + " -->");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        closeConnection();
    }
%>

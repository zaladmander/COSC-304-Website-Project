<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<%!

private String get(HttpServletRequest req, String key) {
    String v = req.getParameter(key);
    return (v == null) ? "" : v.trim();
}

private boolean has(HttpServletRequest req, String key) {
    String v = req.getParameter(key);
    return v != null && !v.trim().isEmpty();
}

public String buildProductSearchSQL(HttpServletRequest req) {
    boolean hasName     = has(req, "productName");
    boolean hasCategory = has(req, "categoryId");

    StringBuilder sql = new StringBuilder(
        "SELECT p.productId, p.productName, p.productPrice, " +
        "       p.productImageURL, c.categoryName " +
        "FROM Product p JOIN Category c ON p.categoryId = c.categoryId " +
        "WHERE 1=1 "
    );

    if (hasName)     sql.append(" AND p.productName LIKE ? ");
    if (hasCategory) sql.append(" AND c.categoryId = ? ");

    sql.append(" ORDER BY p.productName");
    return sql.toString();
}

public void bindProductSearchSQL(PreparedStatement pstmt, HttpServletRequest req) throws SQLException {
    int i = 1;

    if (has(req, "productName")) {
        pstmt.setString(i++, "%" + get(req, "productName") + "%");
    }
    if (has(req, "categoryId")) {
        pstmt.setInt(i++, Integer.parseInt(get(req, "categoryId")));
    }
}

public String titleProductSearchSQL(HttpServletRequest req) {
    boolean hasName     = has(req, "productName");
    boolean hasCategory = has(req, "categoryId");

    if (!hasName && !hasCategory) {
        return "All Products";
    }

    StringBuilder t = new StringBuilder("Products");

    if (hasName) {
        t.append(" matching \"").append(get(req, "productName")).append("\"");
    }
    if (hasCategory) {
        t.append(" in selected category");
    }

    return t.toString();
}
%>

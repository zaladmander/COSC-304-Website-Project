<%@ page import="java.util.*, java.sql.*" %>
<%@ include file="/WEB-INF/jdbc.jsp" %>
<%@ include file="/WEB-INF/auth.jsp" %>

<%
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        return;
    }

    request.setCharacterEncoding("UTF-8");
%>

<%
    String userName = (String) session.getAttribute("authenticatedUser");

    String address     = request.getParameter("address");
    String city        = request.getParameter("city");
    String state       = request.getParameter("state");
    String postalCode  = request.getParameter("postalCode");
    String country     = request.getParameter("country");
    String password    = request.getParameter("password");
    String confirmPass = request.getParameter("confirmPassword");

    List<String> errors = new ArrayList<String>();
    boolean updated = false;

    // BASIC REQUIRED CHECKS
    if (address == null || address.trim().isEmpty()) {
        errors.add("Address is required.");
    }
    if (city == null || city.trim().isEmpty()) {
        errors.add("City is required.");
    }
    if (state == null || state.trim().isEmpty()) {
        errors.add("State is required.");
    }
    if (postalCode == null || postalCode.trim().isEmpty()) {
        errors.add("Postal code is required.");
    }
    if (country == null || country.trim().isEmpty()) {
        errors.add("Country is required.");
    }

    // LENGTH CHECKS
    if (address != null && address.length() > 100) {
        errors.add("Address must be at most 100 characters.");
    }
    if (city != null && city.length() > 50) {
        errors.add("City must be at most 50 characters.");
    }
    if (state != null && state.length() > 50) {
        errors.add("State must be at most 50 characters.");
    }
    if (postalCode != null && postalCode.length() > 20) {
        errors.add("Postal code must be at most 20 characters.");
    }
    if (country != null && country.length() > 50) {
        errors.add("Country must be at most 50 characters.");
    }

    // PASSWORD: optional but validated if provided
    if (password != null && !password.trim().isEmpty()) {
        if (!password.equals(confirmPass)) {
            errors.add("Passwords do not match.");
        }

        if (password != null && !password.matches("^(?=.*[0-9])(?=.*[!@#$%^&*()\\[\\]{}~\\-_=+;:'\",.<>?/|\\\\]).{6,}$")) {
            errors.add("Password must be at least 6 characters long and include at least one number and one special character (e.g. !@#$%^&*()[]{}~-_=+;:'\",.<>?/|\\).");
        }
    }
    
    if (!errors.isEmpty()) {
        request.setAttribute("editErrors", errors);
        request.setAttribute("editUpdated", false);
        return;
    }

    try {
        getConnection();

        String sql;
        PreparedStatement ps;

        if (password != null && !password.trim().isEmpty()) {
            sql = "UPDATE customer SET address = ?, city = ?, state = ?, postalCode = ?, country = ?, password = ? " +
                  "WHERE userId = ?";
            ps = con.prepareStatement(sql);
            ps.setString(6, password);   // not hashed currently
            ps.setString(7, userName);
        } else {
            sql = "UPDATE customer SET address = ?, city = ?, state = ?, postalCode = ?, country = ? " +
                  "WHERE userId = ?";
            ps = con.prepareStatement(sql);
            ps.setString(6, userName);
        }
        ps.setString(1, address.trim());
        ps.setString(2, city.trim());
        ps.setString(3, state.trim());
        ps.setString(4, postalCode.trim());
        ps.setString(5, country.trim());

        ps.executeUpdate();
        ps.close();
        updated = true;
    } catch (SQLException e) {
        errors.add("Unable to update account information. Please try again.");
        System.err.println("SQL error updating account info for user " + userName + ": " + e.getMessage());
        request.setAttribute("editErrors", errors);
        closeConnection();
        request.getRequestDispatcher("editUserInfo.jsp").forward(request, response);
        return;
    }

    request.setAttribute("editErrors", errors);
    request.setAttribute("editUpdated", updated);
%>

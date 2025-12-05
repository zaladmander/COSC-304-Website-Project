<%@ page import="java.util.*, java.sql.*" %>
<%@ include file="/WEB-INF/jdbc.jsp" %>

<%
    // Only do anything on POST
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        return;
    }

    request.setCharacterEncoding("UTF-8");

    String firstName  = request.getParameter("firstName");
    String lastName   = request.getParameter("lastName");
    String email      = request.getParameter("email");
    String phonenum  = request.getParameter("phonenum");
    String address    = request.getParameter("address");
    String city       = request.getParameter("city");
    String state      = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country    = request.getParameter("country");
    String userid     = request.getParameter("userid");
    String password   = request.getParameter("password");
    // add other fields as needed

    List<String> errors = new ArrayList<String>();
    boolean created = false;

    // basic validation
    if (firstName == null || firstName.trim().isEmpty())
        errors.add("First name is required.");
    if (lastName == null || lastName.trim().isEmpty())
        errors.add("Last name is required.");
    if (email == null || email.trim().isEmpty())
        errors.add("Email is required.");
    if (phonenum == null || phonenum.trim().isEmpty())
        errors.add("Phone number is required.");
    if (address == null || address.trim().isEmpty())
        errors.add("Address is required.");
    if (city == null || city.trim().isEmpty())
        errors.add("City is required.");
    if (state == null || state.trim().isEmpty())
        errors.add("State is required.");
    if (postalCode == null || postalCode.trim().isEmpty())
        errors.add("Postal code is required.");
    if (country == null || country.trim().isEmpty())
        errors.add("Country is required.");
    if (userid == null || userid.trim().isEmpty())
        errors.add("User ID is required.");
    if (password == null || password.trim().isEmpty())
        errors.add("Password is required.");

    // extra validation for email, phonenum, password strength, etc

    // use regex for email validation
    if (email != null && !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
        errors.add("Email format is invalid.");
    }
    // use regex for phone number validation (simple US format example)
    if (phonenum != null && !phonenum.matches("^\\+?[0-9\\- ]{7,15}$")) {
        errors.add("Phone number format is invalid.");
    }
    // password strength check (at least 6 characters, 1 number, 1 special character)
    if (password != null && !password.matches("^(?=.*[0-9])(?=.*[!@#$%^&*]).{6,}$")) {
        errors.add("Password must be at least 6 characters long and include at least one number and one special character.");
    }


    if (errors.isEmpty()) {
        try {
            getConnection();   // from jdbc.jsp

            // check duplicate userid
            String checkSql = "SELECT COUNT(*) FROM customer WHERE userid = ?";
            PreparedStatement checkStmt = con.prepareStatement(checkSql);
            checkStmt.setString(1, userid);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                errors.add("That user id is already taken.");
            }
            rs.close();
            checkStmt.close();

            if (errors.isEmpty()) {
                String sql = "INSERT INTO customer " +
                            "(firstName, lastName, email, phonenum, address, " +
                            "city, state, postalCode, country, userid, password) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, email);
                ps.setString(4, phonenum);
                ps.setString(5, address);
                ps.setString(6, city);
                ps.setString(7, state);
                ps.setString(8, postalCode);
                ps.setString(9, country);
                ps.setString(10, userid);
                ps.setString(11, password); // not hashed, cause lazy

                ps.executeUpdate();
                ps.close();

                created = true;
                session.setAttribute("authenticatedUser", userid);
            }

        } catch (SQLException e) {
            errors.add("Database error: " + e.getMessage());
        } finally {
            try { closeConnection(); } catch (Exception ignore) {}
        }
    }

    // expose to JSP / other tags
    request.setAttribute("caErrors", errors);
    request.setAttribute("caCreated", created);
%>

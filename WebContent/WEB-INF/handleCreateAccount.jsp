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

    // maximum length validation
    if (firstName != null && firstName.length() > 50)
        errors.add("First name must be at most 50 characters.");
    if (lastName != null && lastName.length() > 50)
        errors.add("Last name must be at most 50 characters.");
    if (email != null && email.length() > 100)
        errors.add("Email must be at most 100 characters.");
    if (phonenum != null && phonenum.length() > 20)
        errors.add("Phone number must be at most 20 characters.");
    if (address != null && address.length() > 100)
        errors.add("Address must be at most 100 characters.");
    if (city != null && city.length() > 50)
        errors.add("City must be at most 50 characters.");
    if (state != null && state.length() > 50)
        errors.add("State must be at most 50 characters.");
    if (postalCode != null && postalCode.length() > 20)
        errors.add("Postal code must be at most 20 characters.");
    if (country != null && country.length() > 50)
        errors.add("Country must be at most 50 characters.");
    if (userid != null && userid.length() > 50)
        errors.add("User ID must be at most 50 characters.");
    if (password != null && password.length() > 100)
        errors.add("Password must be at most 100 characters.");
        
    // extra validation for email, phonenum, password strength, etc
    if (email != null && !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
        errors.add("Email format is invalid.");
    }
    // use regex for phone number validation (simple US format example)
    if (phonenum != null && !phonenum.matches("^\\+?[0-9\\- ]{7,15}$")) {
        errors.add("Phone number format is invalid.");
    }
    // password strength check (at least 6 characters, 1 number, 1 special character)
    if (password != null && !password.matches("^(?=.*[0-9])(?=.*[!@#$%^&*()\\[\\]{}~\\-_=+;:'\",.<>?/|\\\\]).{6,}$")) {
        errors.add("Password must be at least 6 characters long and include at least one number and one special character (e.g. !@#$%^&*()[]{}~-_=+;:'\",.<>?/|\\).");
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
                errors.add("Account creation failed. Please try a different username.");
            }
            rs.close();
            checkStmt.close();

            // check duplicate email
            String checkEmailSql = "SELECT COUNT(*) FROM customer WHERE email = ?";
            PreparedStatement checkEmailStmt = con.prepareStatement(checkEmailSql);
            checkEmailStmt.setString(1, email);
            ResultSet rsEmail = checkEmailStmt.executeQuery();
            if (rsEmail.next() && rsEmail.getInt(1) > 0) {
                errors.add("An account with that email address already exists.");
            }
            rsEmail.close();
            checkEmailStmt.close();

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
            // Log the detailed error server-side
            System.err.println("Database error while creating account: " + e.getMessage());
            errors.add("An error occurred while creating your account. Please try again later.");
        } finally {
            try { closeConnection(); } catch (Exception ignore) {}
        }
    }

    // expose to JSP / other tags
    request.setAttribute("caErrors", errors);
    request.setAttribute("caCreated", created);
%>

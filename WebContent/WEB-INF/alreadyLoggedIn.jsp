<%
	boolean loggedIn = session.getAttribute("authenticatedUser") != null;

	if (loggedIn) {
		String loginMessage = "You are already logged in.";
        session.setAttribute("loginMessage", loginMessage);        
		response.sendRedirect("index.jsp");
	}
%>
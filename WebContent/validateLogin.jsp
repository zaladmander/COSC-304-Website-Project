<%@ include file="/WEB-INF/jdbc.jsp" %>

<%@ page language="java" import="java.io.*,java.sql.*"%>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		try 
		{
			getConnection();
			
			String sql = "SELECT userId FROM Customer WHERE userId = ? AND password = ?";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, username);
			ps.setString(2, password);

			ResultSet rs = ps.executeQuery();
			if(rs.next()) {
				retStr = rs.getString("userId");
			}
			rs.close();
			ps.close();		
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null) {
			session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
		} else {
			session.removeAttribute("authenticatedUser");
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");
		}

		return retStr;
	}
%>


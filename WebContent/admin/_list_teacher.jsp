<%@ page language="java" contentType="text/xml; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="../config.jsp" %>

<list>
<%
Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;

try {
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
	Class.forName(DBDRIVER);
	pstat = conn.prepareStatement("select tno, tname from `tc-full` where cno=? and semester=?;");
	pstat.setString(1, request.getParameter("cno"));
	pstat.setString(2, request.getParameter("semester"));
	rs = pstat.executeQuery();
	
	while (rs.next()) {
		int tno = rs.getInt(1);
		String tname = rs.getString(2);
		%>
		<teacher>
			<tno><%=tno %></tno>
			<tname><%=tname %></tname>
		</teacher>
		<%
	}
}
catch (SQLException e) {
	e.printStackTrace();
}
finally {
	if (rs != null) rs.close();
	if (pstat != null) pstat.close();
	if (conn != null) conn.close();
}
%>

</list>
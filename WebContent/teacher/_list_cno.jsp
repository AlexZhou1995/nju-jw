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
	pstat = conn.prepareStatement("select cno, cname from `tc-full` where tno=? and semester=?;");
	pstat.setString(1, request.getParameter("tno"));
	pstat.setString(2, request.getParameter("semester"));
	rs = pstat.executeQuery();
	
	while (rs.next()) {
		int cno = rs.getInt(1);
		String cname = rs.getString(2);
		%>
		<course>
			<cno><%=cno %></cno>
			<cname><%=cname %></cname>
		</course>
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
<%@ page language="java" contentType="text/xml; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="../config.jsp" %>

<major_list>
<%
Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;

try {
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
	Class.forName(DBDRIVER);
	pstat = conn.prepareStatement("select semester from tc where cno=? order by semester;");
	pstat.setString(1, request.getParameter("cno"));
	rs = pstat.executeQuery();
	
	while (rs.next()) {
		String semester = rs.getString(1);
		%>
		<semester>
			<semno><%=semester %></semno>
		</semester>
		<%
	}
}
catch (SQLException e) {
	e.printStackTrace();
} finally {
	if (rs != null) rs.close();
	if (pstat != null) pstat.close();
	if (conn != null) conn.close();
}
%>

</major_list>
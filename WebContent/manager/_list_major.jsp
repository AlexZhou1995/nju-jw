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
	pstat = conn.prepareStatement("select mno, mname from major where dno=? order by mno;");
	pstat.setString(1, request.getParameter("dno"));
	rs = pstat.executeQuery();
	
	while (rs.next()) {
		int mno = rs.getInt(1);
		String mname = rs.getString(2);
		%>
		<major>
			<mno><%=mno %></mno>
			<mname><%=mname %></mname>
		</major>
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
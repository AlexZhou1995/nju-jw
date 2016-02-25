<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@include file="/config.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>删除成功</title>
</head>
<%
if (session.getAttribute("usertype") == null 
    || (Integer)session.getAttribute("usertype") != 3) {
	%>
	<script type="text/javascript">
	alert("请重新登录！");
	window.location.href="../index.html";
	</script>
	<%
	return;
}
%>
<%
String deleteId = request.getParameter("deleteID");

Connection conn = null;
Class.forName(DBDRIVER);
conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
Statement sqlStmt= conn.createStatement();
String sqlQuery="delete from publishment where ID='"+deleteId+"'";
sqlStmt.executeUpdate(sqlQuery);
sqlStmt.close();
conn.close();

%>
<script type="text/javascript">
alert("公告删除成功！");
window.location.href=document.referrer;
</script>
</body>
</html>
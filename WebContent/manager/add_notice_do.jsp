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
<title>发布成功</title>
</head>
<body>
<% 
request.setCharacterEncoding("utf-8");
String info = request.getParameter("publishInfo");

Connection conn = null;
Class.forName(DBDRIVER);
conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
Statement sqlStmt= conn.createStatement();
String sqlQuery="insert into publishment values(null ,'"+info+"')";
sqlStmt.executeUpdate(sqlQuery);
sqlStmt.close();
conn.close();
%>
<script type="text/javascript">
alert("公告发布成功！");
window.location.href=document.referrer;
</script>
</body>
</html>
<%@page import="java.sql.*" %>
<%@include file="/config.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<% 
request.setCharacterEncoding("utf-8");

if(session.getAttribute("usertype") == null ||
    (Integer)session.getAttribute("usertype") != 2) {
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
Connection conn = null;
PreparedStatement pstat = null;

try{
	Class.forName(DBDRIVER);
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);

	pstat = conn.prepareStatement("delete from tc where tno=? and cno=? and semester=?;");
	pstat.setString(1, request.getParameter("tno"));
	pstat.setString(2, request.getParameter("cno"));
	pstat.setString(3, request.getParameter("semester"));
	pstat.execute();
	
} catch (SQLException e) {
	e.printStackTrace();
}
finally {
	if (pstat != null) pstat.close();
	if (conn != null) conn.close();
}

%>


<body>
<script type="text/javascript">
alert("删除教师课程关系成功！");
window.location.href="teacher_course.jsp";
</script>
</body>
</html>
<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../config.jsp" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>南京大学教务系统</title>
</head>
<body>
<%
if (session.getAttribute("usertype") == null 
|| (Integer)session.getAttribute("usertype") != 2) {
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
String cno = request.getParameter("cno");
String add = request.getParameter("add");
String dno = request.getParameter("dno");
String tno = request.getParameter("tno");
String semester = request.getParameter("semester");

Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;

try {
	Class.forName(DBDRIVER);
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
} catch(Exception e) {
	e.printStackTrace();
	%>
	<script>
	alert("数据库错误!");
	location.href="control_select_course.jsp?&dno=<%=dno%>";
	</script>
	<%
} 

try {	
	pstat = conn.prepareStatement("update tc set select_control=? where cno=? and tno=? and semester=?;");
	pstat.setString(1, add);
	pstat.setString(2, cno);
	pstat.setString(3, tno);
	pstat.setString(4, semester);
	//System.out.println(add + " " +cno + " " +tno + " " +semester);
	pstat.execute();
	
	if(add.equals("1")) {
	%>
	<script>
	alert("添加成功!");
	location.href="control_select_course.jsp";
	</script>
	<%
	} else {
	%>
	<script>
	alert("删除成功!");
	location.href="control_select_course.jsp";
	</script>
	<%		
	}
} catch (Exception e) {
	e.printStackTrace();
	%>
	<script>
	alert("数据库错误!");
	location.href="control_select_course.jsp";
	</script>
	<%
} finally {
	pstat.close();
	if(rs != null) rs.close();
}

if(conn != null) conn.close();
%>

</body>
</html>
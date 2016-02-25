<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="../config.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%request.setCharacterEncoding("utf-8");%>
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
<body>
<%
Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;
boolean is_unique_dno = false;

try {
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
}
catch (SQLException e) {
	%>
	<script type="text/javascript">
	alert("数据库连接异常！");
	</script>
	<%
	e.printStackTrace();
}

try {
	Class.forName(DBDRIVER);
	pstat = conn.prepareStatement("select * from course where cno=?;");
	pstat.setString(1, request.getParameter("cno"));
	rs = pstat.executeQuery();
	
	if (!rs.next()) is_unique_dno = true;
} catch (SQLException e) {
	e.printStackTrace();
} finally {
	if (rs != null) rs.close();
	if (pstat != null) pstat.close();
}

if (!is_unique_dno) {
	%>
	<script type="text/javascript">
	alert("该课程号已被使用！");
	window.history.go(-1);
	</script>
	<%
}
else {
	try {
		pstat = conn.prepareStatement("insert into course (cno, dno, name, credit, `place_time`) values (?, ?, ?, ?, ?);");
		pstat.setString(1, request.getParameter("cno"));
		pstat.setString(2, request.getParameter("dno"));
		pstat.setString(3, request.getParameter("name"));
		pstat.setString(4, request.getParameter("credit"));
		pstat.setString(5, request.getParameter("place_time"));
		pstat.execute();
		%>
		<script type="text/javascript">
		alert("添加课程成功！");
		window.history.go(-1);
		</script>
		<%
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (pstat != null) pstat.close();
	}
	
}


if (conn != null) conn.close();

%>
</body>
</html>
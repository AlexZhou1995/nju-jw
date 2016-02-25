<%@page import="njujw.StringMD5"%>
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

try {
	Class.forName(DBDRIVER);
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

if (request.getParameter("close") != null) {
	// 操作 = 关闭课程评估系统
	try {
		pstat = conn.prepareStatement("update semester set review=0 where review=1;");
		pstat.execute();
		%>
		<script type="text/javascript">
		alert("课程评估系统已关闭！");
		window.location.href = "control_course_review.jsp";
		</script>
		<%
	}
	catch (SQLException e) {
		e.printStackTrace();
	}
	finally {
		if (pstat != null) pstat.close();
	}
	
}
else {
	// 操作 = 开启课程评估系统
	try {
		pstat = conn.prepareStatement("update semester set review=1 where semno=?;");
		String semno = request.getParameter("sem");
		if (semno==null)
			throw new Exception("Unknown Semester");
		pstat.setString(1, semno);
		pstat.execute();
		%>
		<script type="text/javascript">
		alert("<%=semno %> 学期的课程评估已开启！");
		window.location.href = "control_course_review.jsp";
		</script>
		<%
	}
	catch (SQLException e) {
		e.printStackTrace();
	}
	finally {
		if (pstat != null) pstat.close();
	}
}

if (conn != null) conn.close();

%>
</body>
</html>
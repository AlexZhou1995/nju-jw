<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="../config.jsp" %>

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
boolean is_existed = false;
String course_name = null;

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
	pstat = conn.prepareStatement("select name from course where cno=?;");
	pstat.setString(1, request.getParameter("cno"));
	rs = pstat.executeQuery();
	
	if (rs.next()) {
		is_existed = true;
		course_name = rs.getString(1);
	}
} catch (SQLException e) {
	e.printStackTrace();
} finally {
	if (rs != null) rs.close();
	if (pstat != null) pstat.close();
}

if (!is_existed) {
	%>
	<script type="text/javascript">
	alert("您输入的课程号不存在！");
	window.history.go(-1);
	</script>
	<%
}
else {
	try {
		pstat = conn.prepareStatement("delete from course where cno=?;");
		pstat.setString(1, request.getParameter("cno"));
		pstat.execute();
		%>
		<script type="text/javascript">
		alert("课程“" + "<%=course_name%>" + "”已被成功删除！");
		window.history.go(-1);
		</script>
		<%
	} catch (SQLException e) {
		%>
		<script type="text/javascript">
		alert("课程“" + "<%=course_name%>" + "”删除失败！\n\n被选择的课程不能删除。");
		window.history.go(-1);
		</script>
		<%
	} finally {
		if (pstat != null) pstat.close();
	}
	
}

if (conn != null) conn.close();
%>
</body>
</html>
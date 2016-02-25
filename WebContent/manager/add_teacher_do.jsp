<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@include file="../config.jsp" %>
<%@page import="njujw.StringMD5"%>

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
boolean is_unique_tno = false;

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
	pstat = conn.prepareStatement("select * from teacher where tno=?;");
	pstat.setString(1, request.getParameter("tno"));
	rs = pstat.executeQuery();
	
	if (!rs.next()) is_unique_tno = true;
} catch (SQLException e) {
	e.printStackTrace();
} finally {
	if (rs != null) rs.close();
	if (pstat != null) pstat.close();
}

if (!is_unique_tno) {
	%>
	<script type="text/javascript">
	alert("该教师工号已经存在！");
	window.history.go(-1);
	</script>
	<%
}
else {
	try {
		
		pstat = conn.prepareStatement("insert into teacher values (?, ?, ?, ?, ?);");
		pstat.setString(1, request.getParameter("tno"));
		pstat.setString(2, request.getParameter("name"));
		pstat.setString(3, request.getParameter("sex"));
		pstat.setString(4, request.getParameter("birthday"));
		pstat.setString(5, request.getParameter("dno"));
		
		pstat.execute();
		
		pstat = conn.prepareStatement("insert into account values (?, ?, ?, ?);");
		pstat.setString(1, request.getParameter("tno"));
		pstat.setString(2, StringMD5.MD5(request.getParameter("tno")));
		pstat.setInt(3, 1);
		pstat.setString(4, request.getParameter("tno"));
		pstat.execute();
		
		%>
		<script type="text/javascript">
		alert("添加教师成功！");
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
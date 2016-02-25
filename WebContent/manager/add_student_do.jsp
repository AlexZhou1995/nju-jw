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
boolean is_unique_sno = false;

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
	pstat = conn.prepareStatement("select * from student where sno=?;");
	pstat.setString(1, request.getParameter("sno"));
	rs = pstat.executeQuery();
	
	if (!rs.next()) is_unique_sno = true;
} catch (SQLException e) {
	e.printStackTrace();
} finally {
	if (rs != null) rs.close();
	if (pstat != null) pstat.close();
}

if (!is_unique_sno) {
	%>
	<script type="text/javascript">
	alert("该学生学号已经存在！");
	window.history.go(-1);
	</script>
	<%
}
else {
	try {
//		String birthday = request.getParameter("birthday");
//		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
//		java.util.Date date1 = format.parse(birthday);
//		java.sql.Date date2 = new java.sql.Date(date1.getTime());
		pstat = conn.prepareStatement("insert into student values (?, ?, ?, ?, ?, ?, ?);");
		pstat.setString(1, request.getParameter("sno"));
		pstat.setString(2, request.getParameter("name"));
		pstat.setString(3, request.getParameter("sex"));
		pstat.setString(4, request.getParameter("birthday"));
		pstat.setString(5, request.getParameter("dno"));
		pstat.setString(6, request.getParameter("mno"));
		pstat.setString(7, request.getParameter("grade"));
		
		
		pstat.execute();
		
		pstat = conn.prepareStatement("insert into account values (?, ?, ?, ?);");
		pstat.setString(1, request.getParameter("sno"));
		pstat.setString(2, StringMD5.MD5(request.getParameter("sno")));
		pstat.setInt(3, 0);
		pstat.setString(4, request.getParameter("sno"));
		pstat.execute();
		
		%>
		<script type="text/javascript">
		alert("添加学生成功！");
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
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
<body>
<%
Connection conn = null;
PreparedStatement pstat = null;

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
	
	// 从注销成绩请求队列中删除
	pstat = conn.prepareStatement("DELETE FROM `write-off` WHERE sno=? and cno=? and semester=?;");
	pstat.setString(1, request.getParameter("sno"));
	pstat.setString(2, request.getParameter("cno"));
	pstat.setString(3, request.getParameter("semester"));

	pstat.execute();
	pstat.close();
	
	// 从SC选课表中删除
	pstat = conn.prepareStatement("DELETE FROM sc WHERE sno=? and cno=? and semester=?;");
	pstat.setString(1, request.getParameter("sno"));
	pstat.setString(2, request.getParameter("cno"));
	pstat.setString(3, request.getParameter("semester"));

	pstat.execute();
	
} catch (SQLException e) {
	e.printStackTrace();
} finally {
	if (pstat != null) pstat.close();
}

%>
<script type="text/javascript">
	alert("注销成绩处理成功！");
	window.location.href="writeoff_proc.jsp";
</script>

</body>
</html>
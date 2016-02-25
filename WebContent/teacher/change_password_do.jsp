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

<body>
<%
Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;
boolean checked = false;

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
	pstat = conn.prepareStatement("select * from account where userno=? and password=?;");
	pstat.setString(1, session.getAttribute("userno").toString());
	String old_password = request.getParameter("old_password");
	pstat.setString(2, StringMD5.MD5(old_password));
	rs = pstat.executeQuery();
	
	if (rs.next()) checked = true;

} catch (SQLException e) {
	e.printStackTrace();
} finally {
	if (rs != null) rs.close();
	if (pstat != null) pstat.close();
}

if (!checked) {
	%>
	<script type="text/javascript">
	alert("旧密码错误！");
	window.history.go(-1);
	</script>
	<%
	return;
}

try {
	pstat = conn.prepareStatement("update account set password=? where userno=?;");
	pstat.setString(2, session.getAttribute("userno").toString());
	String new_password = request.getParameter("new_password");
	pstat.setString(1, StringMD5.MD5(new_password));
	pstat.execute();
} catch (SQLException e) {
	%>
	<script type="text/javascript">
	alert("尝试更新密码时发生错误！");
	window.history.go(-1);
	</script>
	<%
	e.printStackTrace();
	return;
} finally {
	if (pstat != null) pstat.close();
}

%>
<script type="text/javascript">
alert("修改密码成功！");
window.history.go(-1);
</script>
<%

%>
</body>
</html>
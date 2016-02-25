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
boolean noThisAccount = false;
String userno = null;

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

pstat = conn.prepareStatement("select username from account where username=?;");
pstat.setString(1, request.getParameter("Name"));
rs = pstat.executeQuery();

if (!rs.next()) noThisAccount = true;

pstat.close();
rs.close();

if (noThisAccount) {
	%>
	<script type="text/javascript">
	alert("不存在此账号");
	window.history.go(-1);
	</script>
	<%
}else{
	try{
	pstat = conn.prepareStatement("select userno from account where username=?;");
	pstat.setString(1, request.getParameter("Name"));
	rs = pstat.executeQuery();
	while(rs.next()) {
		userno = rs.getString(1);
	};
	pstat.close();
	rs.close();
	
	System.out.println(userno);
	
	pstat = conn.prepareStatement("update account set `password`=? where userno=?;");
	pstat.setString(1, StringMD5.MD5(userno));
	pstat.setString(2, userno);
	pstat.execute();
	
	%>
	<script type="text/javascript">
	alert("重置成功");
	window.history.go(-1);
	</script>
	<%
	
	}catch (SQLException e) {
		e.printStackTrace();
	} finally {
		pstat.close();
		conn.close();
	}
}

%>

</body>
</html>
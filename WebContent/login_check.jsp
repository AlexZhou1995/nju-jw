<%@page import="java.util.Scanner"%>
<%@page import="java.io.*"%>
<%@page import="java.sql.Statement"%>
<%@page import="njujw.StringMD5"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Login Check</title>
</head>
<body>
<%

String DBDRIVER = "com.mysql.jdbc.Driver";
String DBURL = "jdbc:mysql://localhost:3306/njujw";
String DBUSER = "njujw";
String DBPASS = "njujw";

//从文件读取连接信息
File file = new File("connection");
try {
	if (file.exists()) {
		Scanner scan = new Scanner(new FileInputStream(file));
		DBDRIVER = scan.next().toString();
		DBURL = scan.next().toString();
		DBUSER = scan.next().toString();
		DBPASS = scan.next().toString();
		scan.close();
	}
} catch (Exception e) {
	e.printStackTrace();
}

application.setAttribute("dbdriver", DBDRIVER);
application.setAttribute("dburl", DBURL);
application.setAttribute("dbuser", DBUSER);
application.setAttribute("dbpass", DBPASS);


//debug
System.out.println(DBDRIVER);
System.out.println(DBURL);
System.out.println(DBUSER);
System.out.println(DBPASS);

Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;
int userno = -1, usertype = -1;
String username = null;
boolean login_success = false;

try {
	Class.forName(DBDRIVER);
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
	pstat = conn.prepareStatement("select usertype, userno from account " + 
		"where username=? and password=?;");
	pstat.setString(1, request.getParameter("UserName"));
	String password = request.getParameter("Password");
	pstat.setString(2, StringMD5.MD5(password));
	rs = pstat.executeQuery();
	
	if (rs.next()) {
		userno = rs.getInt(2);
		usertype = rs.getInt(1);
		login_success = true;
	}
} catch (SQLException e) {
	e.printStackTrace();
} finally {
	if (rs != null) rs.close();
	if (pstat != null) pstat.close();
}

if (login_success) {
	session.setAttribute("userno", userno);
	session.setAttribute("usertype", usertype);
	
	String statament = null;
	String redirect = null;
	switch (usertype) {
	case 0:
		statament = "select name from student where sno=?;";
		redirect = "student/welcome.jsp";
		break;
	case 1:
		statament = "select name from teacher where tno=?;";
		redirect = "teacher/welcome.jsp";
		break;
	case 2:
		statament = "select name from admin where ano=?;";
		redirect = "admin/welcome.jsp";
		break;
	case 3:
		statament = "select name from manager where mno=?;";
		redirect = "manager/welcome.jsp";
		break;
	default:
		throw new Exception("Unknown usertype.");
	}
	pstat = conn.prepareStatement(statament);
	pstat.setInt(1, userno);
	rs = pstat.executeQuery();
	if(rs.next()){
		username = rs.getString(1);
	}
	session.setAttribute("username", username);
	response.sendRedirect(redirect);
}
else {
	%>
	<jsp:forward page="login_failure.html" />
	<%
}

if (conn != null) conn.close();
%>
</body>
</html>
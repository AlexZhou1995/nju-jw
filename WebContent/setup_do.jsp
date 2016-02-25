<%@page import="java.io.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<link href="css/bootstrap-theme.min.css" rel="stylesheet" type="text/css">
	<link href="css/dashboard.css" rel="stylesheet">
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	String path = this.getClass().getResource("/").getPath();
	//out.println(path);
	String sqlFileName = path.substring(0, path.lastIndexOf("/WEB-INF")) + "/njujw.sql";
	//out.println(sqlFileName);
	
 	File file = new File(sqlFileName);
 	FileReader fr = new FileReader(file);
 	BufferedReader br = new BufferedReader(fr);
 	StringBuffer strB = new StringBuffer();
	String str = br.readLine();
 	while (str != null) {
 		//out.println(str);
 		strB.append(str);
 		str = br.readLine();
 	}
 	br.close(); //关闭输入流
 	fr.close();
 	String sql = strB.toString();
 	
 	String DBDRIVER = "com.mysql.jdbc.Driver";
 	String DBURL = "jdbc:mysql://"+ request.getParameter("dburl") +":3306/" + request.getParameter("dbname");
 	String DBUSER = request.getParameter("dbusername");
 	String DBPASS = request.getParameter("dbpassword");
 	
 	Connection conn = null;
 	PreparedStatement pstat = null;
 	
 	try {
 		Class.forName(DBDRIVER);
 		System.out.println("SQL Executing...");
 		conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
 		pstat = conn.prepareStatement(sql);
 		pstat.execute();
 		System.out.println("SQL Executed.");
 				
 	} catch (SQLException e) {
 		e.printStackTrace();
 	} finally {
 		if (pstat != null) pstat.close();
 		if (conn != null) conn.close();
 	}
 	
 	//保存连接信息
 	try {
 		PrintStream ps =null;
 		File fout = new File("connection");
 		ps = new PrintStream(new FileOutputStream(fout));
 		ps.println(DBDRIVER);
 		ps.println(DBURL);
 		ps.println(DBUSER);
 		ps.println(DBPASS);
 		ps.close();
 		System.out.println("SQL Connection saved.");
 	}
 	catch (Exception e) {
 		e.printStackTrace();
 	}
 	
%>

<h1>安装成功！ </h1>
<p>您现在可以回到首页登录了。为了安全起见，建议您手动删除setup.jsp.</p>
<hr />
<p>初始帐号：</p>
<p>管理员：manager</p>
<p>教务员：admin</p>
<p>教师：teacher</p>
<p>学生：121242013</p>
<p>密码均为123456</p>
<hr />
<p>祝您使用愉快！</p>

</body>
</html>
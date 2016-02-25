<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>安装</title>

	<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<link href="css/bootstrap-theme.min.css" rel="stylesheet" type="text/css">
	<link href="css/dashboard.css" rel="stylesheet">
	
</head>
<body>

<h1>安装</h1>

<p>请输入数据库连接信息。</p>

<form method="post" action="setup_do.jsp">
<table>
<tbody>
<tr height="50px">
  <td>地址：</td>
  <td><input type="text" class="form-control" name="dburl" id="dburl"></td>
</tr>
<tr height="50px">
  <td>数据库名：</td>
  <td><input type="text" class="form-control" name="dbname" id="dbname"></td>
</tr>
<tr height="50px">
  <td>用户名：</td>
  <td><input type="text" class="form-control" name="dbusername" id="dbusername"></td>
</tr>
<tr height="50px">
  <td>密码：</td>
  <td><input type="text" class="form-control" name="dbpassword" id="dbpassword"></td>
</tr>

<tr>
  	<td colspan="2" height="60">
  		<input type="submit" class="btn btn-lg btn-primary" name="submit" id="submit" value="提交">
    	<input type="reset" class="btn btn-lg btn-danger" name="reset" id="reset" value="重置">
  	</td>
</tr>

</tbody>
</table>
</form>
</body>
</html>
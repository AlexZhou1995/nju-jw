<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Calendar" %>
<%@page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../config.jsp" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>南京大学教务系统</title>

	<link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<link href="../css/bootstrap-theme.min.css" rel="stylesheet" type="text/css">
	<link href="../css/dashboard.css" rel="stylesheet">
</head>
<body onload="javaScript: newPage()">

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
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a href="welcome.jsp" class="navbar-brand">南京大学教务系统</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
            <li><a href="../about.html">关于</a></li>
            <li><a href="../logoff.jsp">退出</a></li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container-fluid">
      <div class="row">
        <jsp:include page="_sidebar.jsp"></jsp:include>
        
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">添加教师课程</h1>
          
<!-- 内容页面开始 -->
		  <div align="center">
		  	<form method="post" action="teacher_course_add_do.jsp" onsubmit="JavaScript: return CheckForm();">
		  	  <table style="border: 0px">
		  	    <tr>
		  	      <td width="70" height="50"><label for="cno">选择课程</label></td>
		  	      <td width="300">
        		    <select class="form-control" name="cno" id="cno">
					<%
					Connection conn = null;
					PreparedStatement pstat = null;
					ResultSet rs = null;
					int dno = -1;
				
					try{
						Class.forName(DBDRIVER);
						conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
				
						pstat = conn.prepareStatement("select dno from admin where ano=?;");
						pstat.setString(1, session.getAttribute("userno").toString());
						rs = pstat.executeQuery();
						if (rs.next()) {
							dno = rs.getInt(1);
						}
						rs.close();
						pstat.close();
						
						pstat = conn.prepareStatement("select cno, name from course where dno=?;");
						pstat.setInt(1, dno);
						rs = pstat.executeQuery();
						while(rs.next()){
							%>
							<option value="<%=rs.getString(1) %>"><%=rs.getString(1) %> - <%=rs.getString(2) %></option>
							<%
						}
					} catch (SQLException e) {
						e.printStackTrace();
					}
					finally {
						if (rs != null) rs.close();
						if (pstat != null) pstat.close();
					}
					%>
		            </select>
		          </td>
		  	    </tr>
		  	    <tr> 
		  	      <td height="50"><label for="tno">选择教师</label></td>
		  	      <td>
        		    <select class="form-control" name="tno" id="tno">
					<%
					try{
						pstat = conn.prepareStatement("select tno, name from teacher where dno=?;");
						pstat.setInt(1, dno);
						rs = pstat.executeQuery();
						while(rs.next()){
							%>
							<option value="<%=rs.getString(1) %>"><%=rs.getString(1) %> - <%=rs.getString(2) %></option>
							<%
						}
					} catch (SQLException e) {
						e.printStackTrace();
					}
					finally {
						if (rs != null) rs.close();
						if (pstat != null) pstat.close();
					}
					%>
					</select>
		          </td>
		  	    </tr>
		  	    <tr> 
		  	      <td height="50"><label for="semester">选择学期</label></td>
		  	      <td>
        		    <select class="form-control" name="semester" id="semester">
					<%
					try{
						pstat = conn.prepareStatement("select semno from semester;");
						rs = pstat.executeQuery();
						while(rs.next()){
							%>
							<option value="<%=rs.getString(1) %>"><%=rs.getString(1) %></option>
							<%
						}
					} catch (SQLException e) {
						e.printStackTrace();
					}
					finally {
						if (rs != null) rs.close();
						if (pstat != null) pstat.close();
					}
					%>
					</select>
		          </td>
		  	    </tr>
		  	    <tr>
		  	      <td colspan="2" align="center" height="60">
		  	      	<input type="submit" class="btn btn-lg btn-primary" name="submit" id="submit" value="提交">
		  	      	<input type="reset" class="btn btn-lg btn-danger" name="reset" id="reset" value="重置">
		  	      </td>
		  	    </tr>
		  	  </table>
		  	</form>
		  </div>
		  
<!-- 内容页面结束 -->

          <h1 class="page-header">管理教师课程</h1>
          <div align="center">
<!-- 内容页面开始 -->

		<div class="table-responsive">
		  <table class="table table-striped">
		    <thead>
		      <tr>
		        <th>工号</th>
		        <th>姓名</th>
		        <th>课程号</th>
		        <th>课程名</th>
		        <th>学期</th>
		        <th>删除</th>
		      </tr>
		    </thead>
		    <tbody>
<% 
	try{
		pstat = conn.prepareStatement("select tno, tname, cno, cname, semester from `tc-full` where tno in (select tno from teacher where dno=?);");
		pstat.setInt(1, dno);
		rs = pstat.executeQuery();
		while(rs.next()) {
%>
				<tr>
		    	<td><%=rs.getString(1) %></td>
				<td><%=rs.getString(2) %></td>
		    	<td><%=rs.getString(3) %></td>
		    	<td><%=rs.getString(4) %></td>
		    	<td><%=rs.getString(5) %></td>
		    	<td>
		    	  <a href="teacher_course_del_do.jsp?tno=<%=rs.getString(1)%>&cno=<%=rs.getString(3)%>&semester=<%=rs.getString(5)%>">
		    	  <input type="button" class="btn btn-xs btn-success btn-block" value="删除">
		    	  </a>
		    	</td>
		    	</tr>
<%
		}
	} catch (SQLException e) {
		e.printStackTrace();
	}
	finally {
		if (rs != null) rs.close();
		if (pstat != null) pstat.close();
	}
%>
		    </tbody>
		  </table>
		</div>



<!-- 内容页面结束 -->
		  </div>
		<%
		if (conn != null) conn.close();
		%>
        </div>
      </div>
    </div>
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
  </body>
</html>
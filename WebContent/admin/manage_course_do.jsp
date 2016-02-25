<%@page import="java.util.HashMap"%>
<%@page import="org.apache.tomcat.jni.Directory"%>
<%@page import="java.util.Map"%>
<%@page import="java.sql.*"%>
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
	<%request.setCharacterEncoding("utf-8"); %>
</head>
<body>

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

<%
Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;
String sname = null;
boolean no_such_student = true;

try {
	Class.forName(DBDRIVER);
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);

} catch (SQLException e) {
	e.printStackTrace();
}

if (request.getParameter("sno") != "") {
	try {
		pstat = conn.prepareStatement("select name from `student` where sno=?;");
		pstat.setString(1, request.getParameter("sno"));
		rs = pstat.executeQuery();
		if (rs.next()) {
			sname = rs.getString(1);
			no_such_student = false;
		}
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (rs != null) rs.close();
		if (pstat != null) pstat.close();
	}

	if (no_such_student) {
		%>
		<script type="text/javascript">
		alert("没有这个学生！");
		window.location.href="select_course.jsp";
		</script>
		<%
		return;
	}
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
          <h1 class="page-header">查看学生课程</h1>
          
<!-- 内容页面开始 -->

          <%
          if (request.getParameter("sno") != "") {
          %>
          <p>学生 <strong><%=sname %>（<%=request.getParameter("sno") %>）</strong> 的课程：</p>
<div class="table-responsive">
  <table class="table table-striped">
    <thead>
      <tr>
        <th>学期</th>
        <th>课程号</th>
        <th>课程名</th>
        <th>类型</th>
        <th>学分数</th>
        <th>得分</th>
        <th>删除</th>
      </tr>
    </thead>
    <tbody>
    <%
	try {
		pstat = conn.prepareStatement("select semester, cno, cname, type, credit, score from `sc-full` where sno=?;");
		pstat.setString(1, request.getParameter("sno"));
		rs = pstat.executeQuery();
		while (rs.next()) {
	    %>
	      <tr>
	        <td><%=rs.getString(1) %></td>
	        <td><%=rs.getString(2) %></td>
	        <td><%=rs.getString(3) %></td>
	        <td><%=rs.getString(4) %></td>
	        <td><%=rs.getString(5) %></td>
	        <%
	        if (rs.getString(6) != null) {
	        	%>
	        	<td><%=rs.getString(6) %></td>
	        	<td></td>
	        	<%
	        } else {
	        	%>
	        	<td>无</td>
	        	<td>
	        	<a href="student_course_del_do.jsp?sno=<%=request.getParameter("sno")%>&cno=<%=rs.getString(4)%>&semester=<%=rs.getString(3)%>">
		    	  <input type="button" class="btn btn-xs btn-success btn-block" value="删除">
		    	</a>
	        	</td>
	        	<%
	        }
	        %>
	        
	      </tr>
	    <%
		}
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (rs != null) rs.close();
		if (pstat != null) pstat.close();
	}
	%>
	</tbody>
  </table>
</div>

          <%
          }
          else {
          %>

<div class="table-responsive">
  <table class="table table-striped">
    <thead>
      <tr>
        <th>学号</th>
        <th>姓名</th>
        <th>学期</th>
        <th>课程号</th>
        <th>课程名</th>
        <th>类型</th>
        <th>学分数</th>
        <th>得分</th>
        <th>删除</th>
      </tr>
    </thead>
    <tbody>
    <%
	try {
		pstat = conn.prepareStatement("select sno, sname, semester, cno, cname, type, credit, score from `sc-full`;");
		rs = pstat.executeQuery();
		while (rs.next()) {
	    %>
	      <tr>
	        <td><%=rs.getString(1) %></td>
	        <td><%=rs.getString(2) %></td>
	        <td><%=rs.getString(3) %></td>
	        <td><%=rs.getString(4) %></td>
	        <td><%=rs.getString(5) %></td>
	        <td><%=rs.getString(6) %></td>
	        <td><%=rs.getString(7) %></td>
	        <%
	        if (rs.getString(8) != null) {
	        	%>
	        	<td><%=rs.getString(8) %></td>
	        	<td></td>
	        	<%
	        } else {
	        	%>
	        	<td>无</td>
	        	<td>
	        	<a href="student_course_del_do.jsp?sno=<%=request.getParameter("sno")%>&cno=<%=rs.getString(4)%>&semester=<%=rs.getString(3)%>">
		    	  <input type="button" class="btn btn-xs btn-success btn-block" value="删除">
		    	</a>
	        	</td>
	        	<%
	        }
	        %>
	        
	      </tr>
	    <%
		}
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (rs != null) rs.close();
		if (pstat != null) pstat.close();
	}
	%>
	</tbody>
  </table>
</div>
          <%
          }
          if (conn != null) conn.close();
          %>

<!-- 内容页面结束 -->

        </div>
      </div>
    </div>
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
  </body>
</html>
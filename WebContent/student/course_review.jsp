<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@include file="/config.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
    <title>南京大学教务系统</title>

    <link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<link href="../css/bootstrap-theme.min.css" rel="stylesheet" type="text/css">
	<link href="../css/dashboard.css" rel="stylesheet">
	
	<script type="text/javascript">
	function Confirm()
	{
	    if (window.confirm('确定要评价么？评价之后不可更改！') == false) {
	        return false;
	    }
	}
	</script>
</head>
<body>
<% 
if(session.getAttribute("usertype") == null ||
    (Integer)session.getAttribute("usertype") != 0) {
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
          <h1 class="page-header">课程评估</h1>

<!-- 内容页面开始 -->

<%
Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;

boolean course_review_open = false;
String opened_semester = null;
ArrayList<String> review_list = null; 

try {
	Class.forName(DBDRIVER);
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
	pstat = conn.prepareStatement("select semno from semester where review=1;");
	rs = pstat.executeQuery();
	
	if (rs.next()) {
		// 当前有学期已经开启了课程评估
		course_review_open = true;
		opened_semester = rs.getString(1);
	}

} catch (SQLException e) {
	e.printStackTrace();
} finally {
	if (rs != null) rs.close();
	if (pstat != null) pstat.close();
}

if (!course_review_open) {
	%>
	<p><strong>课程评估系统尚未开启！</strong></p>	
	<%
}
else {
	boolean has_unreviewed = false;
	
	try {
		pstat = conn.prepareStatement("select cno, cname, review_score, review_comment from `sc-full` where semester=? and sno=?;");
		pstat.setString(1, opened_semester);
		pstat.setString(2, session.getAttribute("userno").toString());
		rs = pstat.executeQuery();
		%>
		<p>现在可以对 <strong><%=opened_semester %></strong>的课程进行评价了！</p>
		<p>注：分数为 1~10 之间的整数，1 分最低，10 分最高。</p>
		<div class="table-responsive">
		<form method="post" action="course_review_do.jsp?semno=<%=opened_semester %>"  onsubmit="JavaScript: return Confirm();">
		<table class="table table-striped">
		  <thead>
		  <tr>
		    <th>课程号</th>
		    <th>课程名</th>
		    <th>评分</th>
		    <th>评论</th>
		  </tr>
		  </thead>
		  <tbody>
		  <%
		  while (rs.next()) {
		  %>
		  <tr>
		  <td><%=rs.getString(1) %></td>
		  <td><%=rs.getString(2) %></td>
		  <%
		  if (rs.getString(3) == null) {
			  // 还未进行评价的课程
			  has_unreviewed = true;
			  %>
			  <td>
			    <select name="<%=rs.getString(1) %>_s" class="form-control">
			      <option selected="selected" value="">不评</option>
				  <option>1</option>
				  <option>2</option>
				  <option>3</option>
				  <option>4</option>
				  <option>5</option>
				  <option>6</option>
				  <option>7</option>
				  <option>8</option>
				  <option>9</option>
				  <option>10</option>
			    </select>
			  </td>
			  <td>
			    <input type="text" name="<%=rs.getString(1) %>_c" class="form-control" placeholder="对课程的评价">
			  </td>
			  <%
		  } else {
			  // 已经评价过的课程
			  %>
			  <td><%=rs.getString(3) %></td>
			  <td><%=rs.getString(4) %></td>
			  <%
		  }
		  %>
		  </tr>
		  <%
		  }
		  
		  if (has_unreviewed) {
	      // 显示提交按钮
		  %>
		  <tr>
		    <td colspan="4" align="center" height="60">
		      <input type="submit" class="btn btn-lg btn-primary" value="提交">
		      <input type="reset" class="btn btn-lg btn-danger" value="重置">
		  	</td>
		  </tr>
		  <%
		  } 
		  %>
		  </tbody>
		</table>
		</form>
		<%
		if (!has_unreviewed) {
	      // 显示提交按钮
		  %>
		  <strong>所有课程都评过啦！ </strong>
		  <%
		  }
		 %>
		</div>
		
	<%
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (rs != null) rs.close();
		if (pstat != null) pstat.close();
	}
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
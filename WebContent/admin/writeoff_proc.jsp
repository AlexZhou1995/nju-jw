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
	
	<script type="text/javascript">
	function ProcConfirm(semester, sno ,cno) {
	    window.location.href="writeoff_proc_do.jsp?semester=" + semester +
	    		"&sno=" + sno + "&cno=" + cno;
	}
	</script>
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

Connection conn = null;
PreparedStatement pstat = null;

try {
	Class.forName(DBDRIVER);
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
} catch(SQLException e) {
	%>
	<script type="text/javascript">
	alert("数据库连接异常！");
	</script>
	<%
	e.printStackTrace();
}

int ano = (Integer)session.getAttribute("userno");
int dno = -1;

try {
	pstat = conn.prepareStatement("select dno from admin where ano=?");
	pstat.setInt(1, ano);
	ResultSet rs = pstat.executeQuery();
	
	if (rs.next()) {
		dno = rs.getInt(1);
	}
	else {
		%>
		<script type="text/javascript">
		alert("账户异常！");
		</script>
		<%
		throw new Exception("Account Error");
	}
}
catch (Exception e) {
	e.printStackTrace();
}

try {
	pstat = conn.prepareStatement("SELECT semester, sno, sname, cno, cname, remark FROM `write-off-full` WHERE dno=?;");
	pstat.setInt(1, dno);
	ResultSet rs = pstat.executeQuery();
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
        
<!-- 内容页面开始 -->
<h1 class="page-header">注销成绩请求</h1>
<div class="table-responsive">
  <table class="table table-striped">
    <thead>
      <tr>
        <th>学期</th>
        <th>学号</th>
		<th>姓名</th>
		<th>课程号</th>
		<th>课程名</th>
		<th>备注</th>
		<th>处理</th>
      </tr>
    </thead>
    <tbody>
	<%
	while (rs.next()) {
		%>
		<tr>
		  <th><%=rs.getString(1) %></th>
		  <th><%=rs.getString(2) %></th>
		  <th><%=rs.getString(3) %></th>
		  <th><%=rs.getString(4) %></th>
		  <th><%=rs.getString(5) %></th>
		  <%
		  if (rs.getString(6) == null) {
			  %>
			  <th>无</th>
			  <%
			  } else {
			  %>
			  <th>rs.getString(6)</th>
			  <%
			  }
		  %>
		  <th>
		  	<form style="margin: 0; padding: 0;">
	    	  <input type="button" class="btn btn-xs btn-success btn-block" value="批准" onclick="javaScript: ProcConfirm('<%=rs.getString(1) %>','<%=rs.getString(2) %>','<%=rs.getString(4) %>');">
		    </form>
		  </th>
		</tr>
		<%
	}
	%>
    </tbody>
  </table>
</div>

<%
} catch(SQLException e) {
	e.printStackTrace();
} finally {
	pstat.close();
	if (conn != null) conn.close();
}
%>

<h1 class="page-header">手动注销</h1>

<div align="center">
<form method="post" action="writeoff_proc_do.jsp" onsubmit="JavaScript: return CheckForm();">
          
  <table style="border: 0px">
    <tr>
      <td width="71" height="50"><label for="tno">学号</label></td>
      <td width="246"><input type="text" class="form-control" name="sno" id="sno" placeholder="请输入整数，例如：121242013"></td>
    </tr>
    <tr>
      <td height="50"><label for="cno">课程号</label></td>
      <td><input type="text" name="cno" id="cno" class="form-control" placeholder="请输入整数，例如：102"></td>
    </tr>
    <tr>
      <td height="50"><label for="semester">学期</label></td>
      <td><input type="text" name="semester" id="semester" class="form-control" placeholder="请输入学期号，例如：2014A"></td>
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
			

        </div>
      </div>
    </div>
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
  </body>
</html>
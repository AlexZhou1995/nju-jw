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
          <h1 class="page-header">欢迎页</h1>
          

<!-- 内容页面开始 -->
<%
	Connection conn2 = null;
	PreparedStatement pstat2 = null;
	ResultSet rs2 = null;

	String[] notice = new String[16];
	int index = 0;

	try{
		Class.forName(DBDRIVER);
		conn2 = DriverManager.getConnection(DBURL, DBUSER, DBPASS);

		pstat2 = conn2.prepareStatement("select text from publishment;");
		rs2 = pstat2.executeQuery();
		while(rs2.next()){
			notice[index] = rs2.getString(1);
			index++;
		}
	}catch (SQLException e) {
		e.printStackTrace();
	}
	finally {
		rs2.close();
		pstat2.close();
		conn2.close();
	}
%>

<div class="table-responsive">
  <table class="table table-striped">
    <thead>
      <tr>
        <th style="width: 100px">编号</th>
        <th>公告内容</th>
      </tr>
    </thead>
    <tbody>
    <%
    for (int i=0; i<index; i++) {
    	%>
    	<tr>
    	  <td><%=i %></td>
    	  <td><%=notice[i] %></td>
    	</tr>
    	<%
    }
    %>
    </tbody>
  </table>
</div>
<!-- 内容页面结束 -->
        </div>
      </div>
    </div>
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
  </body>
</html>
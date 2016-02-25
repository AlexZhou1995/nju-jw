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
<body>

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
        <ul class="nav navbar-nav navbar-right">
        <li><a href="../about.html">关于</a></li>
        <li><a href="../logoff.jsp">退出</a></li>
      </ul>
      </div>
    </nav>

<script type="text/javascript">
function deleteNotice(notice_Id) {
    if(!confirm("确定要删除此条公告么？")) return;
    window.location.href="del_notice_do.jsp?deleteID=" + notice_Id;
}

</script>

    <div class="container-fluid">
      <div class="row">
        <jsp:include page="_sidebar.jsp"></jsp:include>

        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">公告管理</h1>
          
<!-- 内容页面开始 -->
<%
Connection conn2 = null;
PreparedStatement pstat2 = null;
ResultSet rs2 = null;

String[] notice = new String[16];
int[] id=new int[16];
int index = 0;
int deleteID = 0;

try{
	Class.forName(DBDRIVER);
	conn2 = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
	
	pstat2 = conn2.prepareStatement("select ID,text from publishment;");
	rs2 = pstat2.executeQuery();
	while(rs2.next()){
		id[index] = rs2.getInt(1);
		notice[index] = rs2.getString(2);
		//System.out.println(id[index]);
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
        <th></th>
      </tr>
    </thead>
    <tbody>
    <%
    for (int i=0; i<index; i++) {
    	%>
    	<tr>
    	  <td><%=id[i] %></td>
    	  <td><%=notice[i] %></td>
    	  <td><a href="javaScript:deleteNotice(<%=id[i] %>);">删除</a></td>
    	</tr>
    	<%
    }
    %>
    </tbody>
  </table>
</div>


<h2>发布公告</h2>
<div align="center">
<form method="post" action="add_notice_do.jsp">
  <table style="border: 0px">
    <tr>
      <td width="71" height="50"><label for="cno">公告内容</label></td>
      <td width="246"><input type="text" class="form-control" name="publishInfo" id="publishInfo" placeholder="不得超过30字"></td>
  	  <td align="center" width="100">
  		<input type="submit" class="btn btn-lg btn-primary" name="submit" id="submit" value="提交">
  	  </td>
  	</tr>
  </table>
</form>
</div>
<!-- 
<form method="post" action="add_notice_do.jsp">
    <p>公告内容：<input type="text" name="publishInfo"></p>
    <p><input type="submit" value="确定"></p>
</form>
 -->
<!-- 内容页面结束 -->

        </div>
      </div>
    </div>
</body>
</html>
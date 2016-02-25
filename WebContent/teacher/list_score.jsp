<%@page import="java.util.ArrayList"%>
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
	
	<script type="text/javascript">
	function CheckForm()
	{
		var re_int = /^20[0-9]{2}[AB]$/;
		
		var semester = document.getElementById("semester");
		if(semester.value.length == 0)
		{
			alert("学期不能为空!");
			semester.focus();
			return false;
		}
		else if(!re_int.test(semester.value))
		{
			alert("格式不正确");
			semester.focus();
			return false;
		}
		
		var cno = document.getElementById("cno");
		if(cno.value.length == 0)
		{
			alert("课程号不能为空!");
			cno.focus();
			return false;
		}
		
		return true;
	}
	</script>
</head>
<body>
<%
if (session.getAttribute("usertype") == null 
    || (Integer)session.getAttribute("usertype") != 1) {
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

    <div class="container-fluid">
      <div class="row">
        <jsp:include page="_sidebar.jsp"></jsp:include>
        
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">课程成绩查看</h1>
          
<!-- 内容页面开始 -->
	<div align="center">
          <form method="post" action="list_score_do.jsp">
          
  <table style="border: 0px">
    <tr>
      <td width="71" height="50"><label for="year">输入学期</label></td>
      <td width="246">
        <select class="form-control" name="year" id="year">
		<%
		Connection conn = null;
		PreparedStatement pstat = null;
		ResultSet rs = null;
		
		String default_semester = null;
	
		try{
			Class.forName(DBDRIVER);
			conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
	
			pstat = conn.prepareStatement("select distinct(semester) from tc where tno=?;");
			pstat.setString(1, session.getAttribute("userno").toString());
			rs = pstat.executeQuery();
			while(rs.next()){
				if (default_semester == null)
					default_semester = rs.getString(1);
				%>
				<option><%=rs.getString(1) %></option>
				<%
			}
		}catch (SQLException e) {
			e.printStackTrace();
		}
		finally {
			rs.close();
			pstat.close();
		}
		%>
        </select>
	  </td>
    </tr>
    <tr>
      <td height="50"><label for="cno">课程编号</label></td>
      <td>
		<select class="form-control" name="cno" id="cno">
		<%
		if (default_semester != null) {
		try{
			pstat = conn.prepareStatement("select cno, cname from `tc-full` where tno=? and semester=?;");
			pstat.setString(1, session.getAttribute("userno").toString());
			pstat.setString(2, default_semester);
			rs = pstat.executeQuery();
			while(rs.next()){
				%>
				<option value="<%=rs.getString(1) %>"><%=rs.getString(1)%> - <%=rs.getString(2) %></option>
				<%
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		finally {
			if (rs != null) rs.close();
			if (pstat != null) pstat.close();
		}
		}
		if (conn != null) conn.close();
		%>

		</select>
	  </td>
    </tr> 	
  	<tr>
  	<td colspan="2" align="center" height="60">
  		<input type="submit" class="btn btn-lg btn-primary" name="submit" id="submit" value="提交">
  	</td>
  	</tr>
  	
  </table>
</form>
</div>

          
<!-- 内容页面开始 -->

        </div>
      </div>
    </div>
          



</body>
</html>
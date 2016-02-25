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
		var re_int = /^[1-9]+[0-9]*]*$/;
		
		var sno = document.getElementById("sno");
		if(sno.value.length == 0)
		{
			alert("学生学号不能为空!");
			sno.focus();
			return false;
		}
		else if(!re_int.test(sno.value))
		{
			alert("学生学号必须为整数!");
			sno.focus();
			return false;
		}
		
		var name = document.getElementById("name");
		if(name.value.length == 0)
		{
			alert("学生姓名不能为空!");
			name.focus();
			return false;
		}
		else if(name.value.length > 20)
		{
			alert("学生姓名不能超过 20 字!");
			name.focus();
			return false;
		}
	
		var grade = document.getElementById("grade");
		if(grade.value.length == 0)
		{
			alert("入学年份不能为空!");
			grade.focus();
			return false;
		}
		else if(!re_int.test(grade.value))
		{
			alert("入学年份必须为整数!");
			grade.focus();
			return false;
		}
		
		var birthday = document.getElementById("birthday");
		if(birthday.value.length == 0)
		{
			alert("出生时间不能为空!");
			birthday.focus();
			return false;
		}
	}
	
	function RefreshMajorList()
	{
		var dno = document.getElementById("dno").value;
		var xmlhttp = new XMLHttpRequest();
		var major_select = document.getElementById("mno");
		major_select.innerHTML = "";
		
		xmlhttp.onreadystatechange=function()
		{
			if (xmlhttp.readyState==4 && xmlhttp.status==200) {
				var xmlDoc = xmlhttp.responseXML;
				var list = xmlDoc.getElementsByTagName("major");
				for (var i=0; i<list.length; i++) {
					var mno = list[i].getElementsByTagName("mno")[0].firstChild.nodeValue;
					var mname = list[i].getElementsByTagName("mname")[0].firstChild.nodeValue;
					
					var option = document.createElement("option");
					option.setAttribute("value", mno);
					option.appendChild(document.createTextNode(mno + " - " +mname));
					major_select.appendChild(option);
				}
			}
		}
		
		xmlhttp.open("GET", "_list_major.jsp?dno="+dno, true);
		xmlhttp.send();
	}
	</script>
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

<%
Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;
ArrayList<Integer> dpt_no = new ArrayList<Integer>();
ArrayList<String> dpt_list = new ArrayList<String>();
ArrayList<Integer> major_no = new ArrayList<Integer>();
ArrayList<String> major_list = new ArrayList<String>();
ArrayList<String> sex = new ArrayList<String>();
sex.add("男");
sex.add("女");

try {
	Class.forName(DBDRIVER);
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
	pstat = conn.prepareStatement("select dno, dname from department order by dno;");
	rs = pstat.executeQuery();
	
	while (rs.next()) {
		dpt_no.add(rs.getInt(1));
		dpt_list.add(rs.getString(2));
	}
	pstat.close();
	rs.close();
	
	pstat = conn.prepareStatement("select mno, mname from major where dno=0 order by mno;");
	rs = pstat.executeQuery();
	while (rs.next()) {
		major_no.add(rs.getInt(1));
		major_list.add(rs.getString(2));
	}
} catch (SQLException e) {
	e.printStackTrace();
} finally {
	if (rs != null) rs.close();
	if (pstat != null) pstat.close();
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
          <h1 class="page-header">添加学生账号</h1>
          
<!-- 内容页面开始 -->
	<div align="center">
          <form method="post" action="add_student_do.jsp" onsubmit="JavaScript: return CheckForm();">
          
  <table style="border: 0px">
    <tr>
      <td width="71" height="50"><label for="tno">学生学号</label></td>
      <td width="246"><input type="text" class="form-control" name="sno" id="sno" placeholder="请输入整数，例如：102"></td>
    </tr>
    <tr>
      <td height="50"><label for="name">姓名</label></td>
      <td><input type="text" name="name" id="name" class="form-control" placeholder="不超过 20 个字符"></td>
    </tr>
    <tr>
      <td height="50"><label for="dno">所属院系</label></td>
      <td>
	      <select name="dno" id="dno" class="form-control" onchange="RefreshMajorList()">
	      <%
	      for (int i=0; i<dpt_no.size(); i++) {
	    	  %>
	    	  <option value=<%=dpt_no.get(i) %>><%=dpt_no.get(i).toString()+" - "+dpt_list.get(i) %></option>
	    	  <%
	      }
	      %>
	      </select>
      </td>
    </tr>
    <tr>
      <td height="50"><label for="mno">专业</label></td>
      <td>
	      <select name="mno" id="mno" class="form-control">
	      <%
	      for (int i=0; i<major_no.size(); i++) {
	    	  %>
	    	  <option value=<%=major_no.get(i) %>><%=major_no.get(i).toString()+" - "+major_list.get(i) %></option>
	    	  <%
	      }
	      %>
	      </select>
      </td>
    </tr>
    <tr>
      <td height="50"><label for="sex">性别</label></td>
      <td>
	      <select name="sex" id="sex" class="form-control">
	      <%
	      for (int i=0; i<2; i++) {
	    	  %>
	    	  <option><%=sex.get(i) %></option>
	    	  <%
	      }
	      %>
	      </select>
      </td>
    </tr>
    <tr>
      <td height="50"><label for="grade">入学年份</label></td>
      <td><input type="text" name="grade" id="grade" class="form-control" placeholder="请输入入学年份"></td>
    </tr>
    <tr>
      <td height="50"><label for="birthday">出生日期</label></td>
      <td><input type="text" name="birthday" id="birthday" class="form-control" placeholder="例如：1965-12-14"></td>
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

          
<!-- 内容页面开始 -->

        </div>
      </div>
    </div>
          



</body>
</html>
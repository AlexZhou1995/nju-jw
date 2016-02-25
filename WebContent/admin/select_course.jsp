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
	
	<script type="text/javascript">
	function CheckForm() {
		var re_int = /^[1-9]+[0-9]*]*$/;
		var cno = document.getElementById("cno");
		if(cno.value.length == 0) {
			alert("课程编号不能为空");
			cno.focus();
			return false;
		} else if(!re_int.test(cno.value)) {
			alert("课程编号必须为整数!");
			cno.focus();
			return false;
		}
		
		var sno = document.getElementById("sno");
		if(sno != null && sno.value.length == 0) {
			alert("学号不能为空!");
			sno.focus();
			return false;
		} else if(sno != null && !re_int.test(sno.value)) {
			alert("学号必须为整数!");
			sno.focus();
			return false;
		}
		
		var tno = document.getElementById("tno");
		if(tno != null && tno.value.length == 0) {
			alert("教师不能为空!");
			tno.focus();
			return false;
		} 
		
		var semester = document.getElementById("semester");
		if(semester != null && semester.value.length == 0) {
			alert("学期不能为空!");
			semester.focus();
			return false;
		} 
		
		return true;
	}
	
	function changeType() {
		var type = document.getElementById("type");
		var typeText = type.options[type.selectedIndex].value;
		document.cookie = "typeText=" + typeText;
		location.href="select_course.jsp?type="+typeText;
	}

	function delCoo(name) {
		var date = new Date();
		date.setTime(date.getTime() - 10000);
		document.cookie = name + "=a; expires=" + date.toGMTString();
	}
	
	
	function newPage() {
		var typeText = -1;
		var coosStr = document.cookie;
		var coos = coosStr.split("; ");
		for(var i = 0; i < coos.length; i ++) {
			var coo = coos[i].split("=");
			if("typeText"==coo[0]) {
				typeText = coo[1];
				delCoo("typeText");
				break;
			}
		}
		
		var type = document.getElementById("type");
		if(typeText == -1) {
			type.selectedIndex = 0;
		} else {
			for(var i = 0; i < type.options.length; i ++) {
				if(type.options[i].value == typeText) {
					type.selectedIndex = i;
					break;
				}
			}
		}
		if(<%=request.getParameter("type") %> != null && 
				type.selectedIndex != <%=request.getParameter("type") %>) {
			location.href="select_course.jsp?type=" + type.selectedIndex;
		}
	}
	
	function RefreshSemesterList()
	{
		var cno = document.getElementById("cno").value;
		var xmlhttp = new XMLHttpRequest();
		var selector = document.getElementById("semester");
		selector.innerHTML = "";
		
		xmlhttp.onreadystatechange=function()
		{
			if (xmlhttp.readyState==4 && xmlhttp.status==200) {
				var xmlDoc = xmlhttp.responseXML;
				var list = xmlDoc.getElementsByTagName("semester");
				for (var i=0; i<list.length; i++) {
					var semno = list[i].getElementsByTagName("semno")[0].firstChild.nodeValue;
					
					var option = document.createElement("option");
					option.setAttribute("value", semno);
					option.appendChild(document.createTextNode(semno));
					selector.appendChild(option);
				}
				if (list.length>0) {
					RefreshTeacherList();
				}
				else {
					document.getElementById("tno").innerHTML = "";
				}
			}
		}
		
		xmlhttp.open("GET", "_list_semester.jsp?cno="+cno, true);
		xmlhttp.send();
	}

	function RefreshTeacherList()
	{
		var cno = document.getElementById("cno").value;
		var semester = document.getElementById("semester").value;
		var xmlhttp = new XMLHttpRequest();
		var selector = document.getElementById("tno");
		selector.innerHTML = "";
		
		xmlhttp.onreadystatechange=function()
		{
			if (xmlhttp.readyState==4 && xmlhttp.status==200) {
				var xmlDoc = xmlhttp.responseXML;
				var list = xmlDoc.getElementsByTagName("teacher");
				for (var i=0; i<list.length; i++) {
					var tno = list[i].getElementsByTagName("tno")[0].firstChild.nodeValue;
					var tname = list[i].getElementsByTagName("tname")[0].firstChild.nodeValue;
					
					var option = document.createElement("option");
					option.setAttribute("value", tno);
					option.appendChild(document.createTextNode(tno + " - "+ tname));
					selector.appendChild(option);
				}
			}
		}
		
		xmlhttp.open("GET", "_list_teacher.jsp?cno="+cno+"&semester="+semester, true);
		xmlhttp.send();
	}
	</script>
	
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
          <h1 class="page-header">指选课程</h1>
          
          <p>只有添加了教师——课程关系的课程才能指选。</p>
<!-- 内容页面开始 -->
<%
Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;
ArrayList<Integer> dpt_no = new ArrayList<Integer>();
ArrayList<String> dpt_list = new ArrayList<String>();
int dno = -1;
int default_cno = -1;
String default_semester = null;

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
	
	int ano = (Integer)session.getAttribute("userno");
	pstat = conn.prepareStatement("select dno from admin where ano=?;");
	pstat.setInt(1, ano);
	rs = pstat.executeQuery();
	rs.next();
	dno = rs.getInt(1);
} catch (SQLException e) {
	e.printStackTrace();
} finally {
	if (rs != null) rs.close();
	if (pstat != null) pstat.close();
}
%>


		  <div align="center">
		  	<form method="post" action="select_course_do.jsp" onsubmit="JavaScript: return CheckForm();">
		  	  <table style="border: 0px">
		  	    
		  	    <tr> 
		  	      <td height="50"><label for="type">类型</label></td>
		  	      <td>
		  	      	<select name="type" id="type" class="form-control" onchange="javaScript: changeType()">
		  	      		<option value=0>院系</option>
		  	      		<option value=1>专业</option>
		  	      		<option value=2>学生</option>
		  	      	</select>
		  	      </td>
		  	    </tr>
		  	    <%
		  	      String type = request.getParameter("type");
		  	      if(type == null || type.equals("0") || type.equals("1")) {
		  	    	  %>
		  	    	  <tr>
		  	    	  	<td height="50"><label for="grade">年级</label>
		  	      		<td>
		  	      		<select name="grade" id="grade" class="form-control">
		  	      	  	<%
		  	      	  		Calendar cal = Calendar.getInstance();
		  	    			int month = cal.get(Calendar.MONTH) + 1;
		  	    			int year = cal.get(Calendar.YEAR);
		  	    			if(month >= 9 || month <= 3) {
			  	    			for(int i = year - 3; i <= year; i ++) {
			  	    			%>
				  	     		<option value=<%=i%>><%=i%> </option>
				  	     		<%	
			  	    			}
		  	    			} else {
			  	    			for(int i = year - 4; i < year; i ++) {
			  	    			%>
				  	     		<option value=<%=i%>><%=i%> </option>
				  	     		<%	
			  	    			}
		  	    			}
		  	      	  	%>
		  	      	  	</select>
		  	      	  	</td>
		  	    	  </tr>
		  	    	  <%	  
		  	      } 
		  	      
		  	      if(type != null && type.equals("1")){		  	    	  
		  	    	  %>
		  	    <tr>
		  	      <td height="50"><label for="major">专业</label></td>
		  	      <td>
		  	        <select name="major" id="major" class="form-control">
		  	          <%
			  	        ArrayList<Integer> major_no = new ArrayList<Integer>();
			  	        ArrayList<String> major_list = new ArrayList<String>();
		  	    		
				  	    try {
				  	        Class.forName(DBDRIVER);
				  	        conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
				  	        pstat = conn.prepareStatement("select mno, mname from major where dno = ? order by mno;");
				  	        pstat.setInt(1, dno);
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
		  	     	<%
		  	     	for(int i = 0; i < major_no.size(); i ++) {
		  	     		%>
		  	     		<option value=<%=major_no.get(i)%>><%=major_no.get(i).toString() + " - " + major_list.get(i) %> </option>
		  	     		<%
		  	     	}
		  	     	%>		  	          
		  	        </select>
		  	      </td>
		  	    </tr>
		  	    	  
		  	    	  <%
		  	      } else if(type != null && type.equals("2")) {
		  	    	  %>
		  	    <tr>
		  	      <td height="50"><label for="sno">学号</label></td>
		  	      <td><input type="text" class="form-control" name="sno" id="sno" placeholder="请输入整数，例如：121220101"></td>
		  	    </tr>
		  	    		  	    	  
		  	    	  <%
		  	      }
		  	    %>
		  	    
		  	    <tr>
		  	      <td width="71" height="50"><label for="cno">课程编号</label></td>
		  	      <td>
        		    <select class="form-control" name="cno" id="cno" onchange="RefreshSemesterList()">
					<%
					try{
						pstat = conn.prepareStatement("select cno, name from course where dno=?;");
						pstat.setInt(1, dno);
						rs = pstat.executeQuery();
						while(rs.next()){
							if (default_cno == -1)
								default_cno = rs.getInt(1);
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
		  	      <td width="71" height="50"><label for="semester">课程学期</label></td>
		  	      <td>
        		    <select class="form-control" name="semester" id="semester" onchange="RefreshTeacherList()">
					<%
					try{
						pstat = conn.prepareStatement("select distinct(semester) from tc where cno=?;");
						pstat.setInt(1, default_cno);
						rs = pstat.executeQuery();
						while(rs.next()){
							if (default_semester == null)
								default_semester = rs.getString(1);
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
		  	      <td width="71" height="50"><label for="tno">课程教师</label></td>
		  	      <td>
        		    <select class="form-control" name="tno" id="tno">
					<%
					try{
						pstat = conn.prepareStatement("select tno, tname from `tc-full` where cno=? and semester=?;");
						pstat.setInt(1, default_cno);
						pstat.setString(2, default_semester);
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
		  	      <td colspan="2" align="center" height="60">
		  	        <input type="hidden" name="dno" id="dno" value=<%=dno%>>
		  	      	<input type="submit" class="btn btn-lg btn-primary" name="submit" id="submit" value="提交">
		  	      	<input type="reset" class="btn btn-lg btn-danger" name="reset" id="reset" value="重置">
		  	      </td>
		  	    </tr>
		  	  </table>
		  	</form>
		  </div>
<!-- 内容页面结束 -->

		<h1 class="page-header">管理学生课程</h1>
		<div align="center">
		  <form method="post" action="manage_course_do.jsp">
		  	<table style="border: 0px">
		  	  <tr>
		  	    <td width="71" height="50"><label for="sno">学号:</label></td>
		  	    <td width="246"><input type="text" class="form-control" name="sno" id="sno_query" placeholder="留空则列出所有学生选课"></td>
	  	  		<td width="80" align="right">
	  	      	<input type="submit" class="btn btn-lg btn-primary" name="submit" id="submit" value="提交">
	  	        </td>
	  	    </tr>
		    </table>
		  </form>
		</div>

        </div>
      </div>
    </div>
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
  </body>
</html>
<%@page import="java.sql.*"%>
<%@page import="java.util.*" %>
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
	function addCookie(name) {
		var p = document.getElementById(name);
		var pText = p.options[p.selectedIndex].value;
		document.cookie = name + "Text=" + pText;
	}

	function delCookie(name) {
		var date = new Date();
		date.setTime(date.getTime() - 10000);
		document.cookie = name + "=a; expires=" + date.toGMTString();
	}
	
	function selectChange() {
		addCookie("dno");
		var p = document.getElementById("dno")
		location.href="select_course.jsp?dno=" + p.options[p.selectedIndex].value;
	}
	
	function newPage() {
		var dnoText = -1;
		var coosStr = document.cookie;
		var coos = coosStr.split("; ");
		for(var i = 0; i < coos.length; i ++) {
			var coo = coos[i].split("=");
			if("dnoText"==coo[0]) {
				dnoText = coo[1];
				delCookie("dnoText");
				break;
			}
		}
		
		var dno = document.getElementById("dno");
		if(<%=request.getParameter("dno") %> != null && dnoText == -1)
			dnoText = <%=request.getParameter("dno") %>;
		if(dnoText == -1) {
			dno.selectedIndex = 0;
		} else {
			for(var i = 0; i < dno.options.length; i ++) {
				if(dno.options[i].value == dnoText) {
					dno.selectedIndex = i;
					break;
				}
			}
		}
		if(<%=request.getParameter("dno") %> != null && 
				dno.options[dno.selectedIndex].value != <%=request.getParameter("dno") %>) {
			location.href="select_course.jsp";
		}
	}
	</script>
</head>
<body onload="javaScript: newPage()">
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
          <h1 class="page-header">学期选课</h1>

<!-- 内容页面开始 -->
	<table style="border: 0px">
	 <tr>
	 <td height="50" width="40" align="left" valign="middle"><label for="dno">院系</label> </td>
	 <td width="200">
	 <select name="dno" id="dno" class="form-control" onchange="javaScript: selectChange()">
	 <option value=-1></option>
	 <%
	 Connection conn = null;
	 PreparedStatement pstat = null;
	 ResultSet rs = null;

	 ArrayList<Integer> dpt_no = new ArrayList<Integer>();
	 ArrayList<String> dpt_list = new ArrayList<String>();
		  	    		
	 try {
	 	Class.forName(DBDRIVER);
		conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
	 	pstat = conn.prepareStatement("select dno, dname from department order by dno;");
		rs = pstat.executeQuery();
				  	        	
		while (rs.next()) {
			dpt_no.add(rs.getInt(1));
			dpt_list.add(rs.getString(2));
		}
	 } catch (SQLException e) {
		e.printStackTrace();
	 } finally {
		if (rs != null) rs.close();
		if (pstat != null) pstat.close();
		}		  					
	 %>
	 <%
	 for(int i = 0; i < dpt_no.size(); i ++) {
	 %>
	 <option value=<%=dpt_no.get(i)%>><%=dpt_no.get(i).toString() + " - " + dpt_list.get(i) %> </option>
	 <%
	 }
	 %>		  	          
	 </select>
	 </td>
	 </tr>
	</table>
		<table class="table table-striped">
	  <thead>
      <tr>
        <th>课程号</th>
        <th>课程名</th>
		<th>学分数</th>
		<th>教师</th>
		<th>上课地点</th>
		<th></th>
      </tr>
      </thead>
      <tbody>
      <%
      int sno = (Integer)session.getAttribute("userno");
      PreparedStatement pstat_sel = null;
      ResultSet rs_sel = null;
      String dno = request.getParameter("dno");
      
  	  Calendar cal = Calendar.getInstance();
  	  int month = cal.get(Calendar.MONTH) + 1;
  	  int year = cal.get(Calendar.YEAR);
  	  String semester = null;
  	  if(month >= 9 || month <=3) semester = year + "A";
  	  else semester = year + "B";
      int i = 0;
      if(dno != null && !dno.equals("-1")) {
    	  try {
    		  pstat = conn.prepareStatement("select cno, cname, credit, place_time, tname, tno from `tc-full` where dno=? and select_control=1;");
    		  pstat.setString(1, dno);
    		  rs = pstat.executeQuery();
    		  
    		  while(rs.next()) {
    			  boolean course_exist = false;
    			  i ++;
				  try {
					  pstat_sel = conn.prepareStatement("select * from `sc` where sno=? and cno=? and semester=?");
					  pstat_sel.setInt(1, sno);
					  pstat_sel.setInt(2, rs.getInt(1));
					  pstat_sel.setString(3, semester);
					  rs_sel = pstat_sel.executeQuery();
					  if(rs_sel.next()) course_exist = true;
				  } catch (Exception e) {
					  e.printStackTrace();
				  } finally {
					  pstat_sel.close();
					  rs_sel.close();
				  }
    			  %>
    			  <tr>
    			  <td><%=rs.getInt(1)%></td>
    			  <td><%=rs.getString(2)%></td>
    			  <td><%=rs.getInt(3)%></td>
    			  <td><%=rs.getString(5)%></td>
    			  <td><%=rs.getString(4)%></td>
    			  <td>

	    		  		<%
	    		  		if(!course_exist) {
	    		  		%>
	    		  		<form method="post" action="select_course_do.jsp?idx=<%=i%>&add=1&dno=<%=dno%>>&semester=<%=semester %>&tno=<%=rs.getString(6)%>"  style="margin: 0; padding: 0;">
	    		  		<input type="hidden" name="cno" value=<%=rs.getInt(1)%>>
	    		  		<input type="submit" class="btn btn-xs btn-success btn-block" id="submit<%=i%>" value="选择">
	    		  		</form>  
	    		  		<%
	    		  		} else {
	    		  			%>
	    		  		<form method="post" action="select_course_do.jsp?idx=<%=i%>&add=0&dno=<%=dno%>&semester=<%=semester %>&tno=<%=rs.getString(6)%>"  style="margin: 0; padding: 0;">
	    		  		<input type="hidden" name="cno" value=<%=rs.getInt(1)%>>
	    		  		<input type="submit" class="btn btn-xs btn-warning btn-block" id="submit<%=i%>" value="退选">
	    		  		</form>
	    		  			<%
	    		  		}
	    		  		%>	    		  			
  			  
    			  </td>
    			  </tr>
    			  <%
    		  }
    	  } catch(Exception e) {
    		  e.printStackTrace();
    	  } finally {
    		  pstat.close();
    		  rs.close();
    	  }
      }
      %>
      </tbody>
	</table>
<!-- 内容页面结束 -->

	</div>
  </div>
</div>
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
  </body>
</html>
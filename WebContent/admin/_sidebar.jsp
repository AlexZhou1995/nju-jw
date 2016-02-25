<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
  <!-- 侧边栏 -->
  <div class="col-sm-3 col-md-2 sidebar">
    <p>欢迎您，<%=session.getAttribute("username") %>！</p>
    <p>当前身份：教务员 </p>
    <ul class="nav nav-sidebar" id="sidebar">
      <li><a href="welcome.jsp">欢迎页</a></li>
      <li><a href="list_course.jsp">查看课程</a></li>
      <li><a href="list_student.jsp">查看学生信息</a></li>
      <li><a href="select_course.jsp">学生课程管理</a>
      <li><a href="teacher_course.jsp">教师课程管理</a>
      <li><a href="control_select_course.jsp">选课系统</a>
      <li><a href="input_grade.jsp">成绩录入</a>
      <li><a href="writeoff_proc.jsp">注销成绩</a></li>
      <li><a href="change_password.jsp">修改密码</a></li>
    </ul>
  </div>
  
  <!-- 设置当前页面高亮 -->
  <script type="text/javascript">
  
	var strHref = window.location.href;
	var pageName = strHref.slice(strHref.lastIndexOf("/")+1);
	
	var sidebar = document.getElementById("sidebar");
	var lis = sidebar.getElementsByTagName("li");
	for (var i=0; i<lis.length; i++) {
		var href = lis[i].firstChild.getAttribute("href");
		if (href == pageName) {
			lis[i].setAttribute("class", "active");
			break;
		}
	}
  </script>
</body>
</html>
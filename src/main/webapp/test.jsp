<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<% pageContext.setAttribute("PATH",request.getContextPath()); %>
<script type="text/javascript" src="${PATH }/static/js/jquery-3.3.1.js" ></script>
<script type="text/javascript">
	$(function(){
		$("button").click(function(){
			$("select").removeAttr("ava");
			alert($("select").attr("ava")=="ss")
		})
	
	})
</script>
</head>
<body>
	<select ava="ss">
	<option></option>
	<option></option>
	<option></option>
	</select>
	<button value="tianjia"></button>
</body>
</html>
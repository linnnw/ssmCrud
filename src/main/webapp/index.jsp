<!--<%@page import="java.sql.Date"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>员工管理</title>
<!-- 定位 -->
<% pageContext.setAttribute("PATH",request.getContextPath()); %>
<!-- 引入样式 -->
<!-- 因为Bootstrap JS 依赖于jQuery，所以引入顺序要先jQuery -->
 <script type="text/javascript" src="${PATH }/static/js/jquery-3.3.1.js" ></script>
 <link href="${PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
 <script src="${PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<script type="text/javascript">
	//页面刷新之后执行
	$(function(){
		//记录总记录数
		var getTotal;
		//记录当前页面
		var getPageNum;
		//第一次进入访问第一页
		PageNum(1);
		//显示用户数据
		function userData(data){
			//清除数据后再查找
			$("tbody").empty();
			//获取json中的用户数据
			var users = data.extend.empAll.list;
			$.each(users,function(){
				var checkbox = $("<td><input type='checkbox' class='checkdel'/></td>");
				var empId = $("<td></td>").append(this.empId);
				var empName = $("<td></td>").append(this.empName);
				var gender = $("<td></td>").append(this.gender=='f'?'男':'女');
				var email = $("<td></td>").append(this.email);
				var deptName = $("<td></td>").append(this.department.deptName);
				/*编辑:edit class="btn btn-success btn-sm">
				<span class="glyphicon glyphicon-pencil">*/
				var edit = $("<button></button>").attr("mockId",this.empId).addClass("btn btn-success btn-sm")
				.append("<span></span>").addClass("glyphicon glyphicon-pencil update_btn").append("编辑");
				/*删除：del <button class="btn btn-danger btn-sm">
				<span class="glyphicon glyphicon-trash">*/
				var del = $("<button></button>").attr("mockId",this.empId).addClass("btn btn-danger btn-sm")
				.append("<span></span>").addClass("glyphicon glyphicon-trash delete_btn").append("删除");
				//操作：operating 里面放编辑和删除
				var operating = $("<td></td>").append(edit).append(" ").append(del);
				$("<tr></tr>").append(checkbox).append(empId).append(empName).append(gender)
				.append(email).append(deptName).append(operating).appendTo("tbody");
			})
			
		}
		
		//显示要修改的信息
		$(document).on("click",".update_btn",function(){
			//显示部门信息
			getDeptName("#emp_update select");
			//弹出模态框
			$('#emp_update').modal({
	 			backdrop:"static"
	 		});
			//清楚样式
			$("#emp_add form")[0].reset();
			$("#emp_add form").find(".help-block").text("");
			$("*").removeClass("has-error has-success");
			
			//查询要修改的员工的信息
			$.ajax({
				url:"${PATH }/emp/selEmpById/"+$(this).attr("mockId"),
				type:"POST",
				success:function(date){
					$("#updateName").val(date.extend.empaById.empName);
	 				$("#updateEmail").val(date.extend.empaById.email);
	 				$("#emp_update input[name=gender]").val([date.extend.empaById.gender]);
	 				$("#emp_update select").val([date.extend.empaById.dId]);
	 				$("#saveTo").attr("saveId",date.extend.empaById.empId);
				}
			})
		})
		//修改信息
		$("#saveTo").click(function(){
			$.ajax({
				url:"${PATH }/emp/updateEmp/"+$(this).attr("saveId"),
				type:"POST",
				//form表单的数据转成json
				data:$("#emp_update form").serialize()+"&_method=PUT",
				success:function(date){
					//关闭模态框
					$('#emp_update').modal('hide');
					//跳转到修改页面
					if($("body").attr("quer")=="section"){
						PageNum1(getPageNum);
					}else{
						PageNum(getPageNum);
					}
				}
			})
		})
		
		//显示数据记录
		function dataRecord(data){
			//清除数据后再查找
			$("#dataRecord_div").empty();
			//获取empAll
			var empAll = data.extend.empAll;
			$("#dataRecord_div").append("当前页："+empAll.pageNum+",一共"
										+empAll.pages+"页,一共"
										+empAll.total+"条记录");
			getTotal = empAll.total;
			getPageNum = empAll.pageNum;
		}
		//显示分页信息
		function pageInfo(data){
			//清除数据后再查找
			$("nav ul").empty();
			//获取分页信息
			var nums = data.extend.empAll.navigatepageNums
			//首页
			var frist = $("<li></li>").append($("<a></a>").append("首页")).appendTo("nav ul");
			frist.click(function(){
				//跳到尾页设置 页数大于总页数会跳转到尾页
				if($("body").attr("quer")=="section"){
					PageNum1(1);
				}else{
					PageNum(1);
				}
				
			})
			//前一页
			var prePage = $("<li></li>").append($("<a></a>").append("&laquo;")).appendTo("nav ul");
			prePage.click(function(){
				if(data.extend.empAll.pageNum>1){
					if($("body").attr("quer")=="section"){
						PageNum1(data.extend.empAll.pageNum-1);
					}else{
						PageNum(data.extend.empAll.pageNum-1);
					}
				}
			})
			//当前页等于第一页禁用上一页和首页按钮
			if(data.extend.empAll.pageNum==1){
				frist.addClass("disabled")
				prePage.addClass("disabled");
			}
				
			//循环获取的页数
			$.each(nums,function(index,item){
				
				var num = $("<li></li>").append($("<a></a>").append(this));
				$("nav ul").append(num);
				num.click(function(){
					if($("body").attr("quer")=="section"){
						PageNum1(item);
					}else{
						PageNum(item);
					}
				})
				//当前页蓝色表示
				if(this==data.extend.empAll.pageNum){
					num.addClass("active");
				}
			
			})
			//后一页
			var nextPage = $("<li></li>").append($("<a></a>").append("&raquo;")).appendTo("nav ul");
			nextPage.click(function(){
				if(data.extend.empAll.pageNum<data.extend.empAll.pages){
					if($("body").attr("quer")=="section"){
						PageNum1(data.extend.empAll.pageNum+1);
					}else{
						PageNum(data.extend.empAll.pageNum+1);
					}
				}
			})
			//尾页
			var last = $("<li></li>").append($("<a></a>").append("尾页")).appendTo("nav ul");
			last.click(function(){
				//跳到尾页设置 页数大于总页数会跳转到尾页
				if($("body").attr("quer")=="section"){
					PageNum1(getTotal);
				}else{
					PageNum(getTotal);
				}
			})
			
			//当前页等于最后一页禁用下一页和尾页按钮
			if(data.extend.empAll.pageNum==data.extend.empAll.pages){
				nextPage.addClass("disabled")
				last.addClass("disabled");
			}
		}
		//跳转页数
		function PageNum(pn){
			$.ajax({
				url:"${PATH }/emp/emps/"+pn,
				type:"GET",
				success:function(data){
					//显示用户数据
					userData(data);
					//显示数据记录
					dataRecord(data);
					//显示分页信息
					pageInfo(data);
				}
			})
		}
		
		/*点击新增弹出模态框*/
		$("#added_emp").click(function(){
			//弹出模态框
			$('#emp_add').modal({
	 			backdrop:"static"
	 		});
			//清楚样式
			$("#emp_add form")[0].reset();
			$("#emp_add form").find(".help-block").text("");
			$("*").removeClass("has-error has-success");
			//获取部门信息
			getDeptName("#emp_add select");
		})
		
		//点击保存校验用户名邮箱
		$("#addTo").click(function(){
			$.ajax({
				url:"${PATH }/emp/addEmp",
				type:"POST",
				data:$("#emp_add form").serialize(),
				success:function(date){
					if(date.code==100){
						//弹出成功
						alert(date.message)
						//关闭模态框
						$('#emp_add').modal('hide');
						//跳转到尾页
						PageNum(getTotal);
						
					}else{
						if(undefined!=date.extend.result.empName){
							checks("#inputName",date.code,date.extend.result.empName)
						}
						if(undefined!=date.extend.result.email){
							checks("#inputEmail",date.code,date.extend.result.email)
						}
					}
				}
			})
		})
		//校验用户名
		$("#inputName").change(function(){
			$.ajax({
				url:"${PATH }/emp/addEmpJudgment",
				type:"POST",
				data:$("#emp_add form").serialize(),
				success:function(date){
					checks("#inputName",date.code,date.extend.msv);
				}
			})
		})
		//校验邮箱
		function checkEmail(ele,form){
			$(ele).change(function(){
				$.ajax({
					url:"${PATH }/emp/addEmpJudgment_email",
					type:"POST",
					data:$(form).serialize(),
					success:function(date){
						checks(ele,date.code,date.extend.msc);
					}
				})
			})
		}
		//调用方法
		checkEmail("#inputEmail","#emp_add form");
		checkEmail("#updateEmail","#emp_update form");
		
		//校验用户名密码方法
		function checks(ele,code,result){
			$(ele).parent("div").removeClass("has-success has-error")
			$(ele).next("span").text("");
			if(code==100){
				$(ele).parent("div").addClass("has-success");
				$(ele).parent("div").find("span").text(result);
			}else if(code==200){
				$(ele).parent("div").addClass("has-error");
				$(ele).parent("div").find("span").text(result);
			
			}
		}
		//获取部门信息
		function getDeptName(ele){
			$(ele).empty();
			$.ajax({
				url:"${PATH }/dept/getDeptName",
				type:"GET",
				success:function(date){
					$.each(date.extend.deptData,function(index,item){
						$("<option></option>").attr("value",item.deptId).append(item.deptName).appendTo(ele);
					})
				}
			})
		}
		//删除单个用户
		$(document).on("click",".delete_btn",function(){
			var empName = $(this).parents("tr").find("td:eq(2)").text();
			if(confirm("确认删除["+empName+"]吗？")){
				$.ajax({
					url:"${PATH }/emp/singleDelete/"+$(this).attr("mockId"),
					type:"DELETE",
					success:function(date){
						alert(date.message);
						//跳转到删除页面
						if($("body").attr("quer")=="section"){
							PageNum1(getPageNum);
						}else{
							PageNum(getPageNum);
						}
						
					}
					
				})
			}
			
		})
		//全选反选
		$("#checks").click(function(){
			//attr获取自定义属性值 prop获取dom原生属性值
			$(".checkdel").prop("checked",$(this).prop("checked"));
			$(document).on("click",".checkdel",function(){
				var flag = $(".checkdel:checked").length==$(".checkdel").length;
				$("#checks").prop("checked",flag);
			})
			
		})	
		//批量删除
		$("#delete_emp").click(function(){
			var empNames="";
			var ints = "";
			$.each($(".checkdel:checked"),function(){
				//取值 员工名
				empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
				//取值员工id
				ints += $(this).parents("tr").find("td:eq(1)").text()+"-";
			})
			empNames = empNames.substring(0,empNames.length-1);
			ints = ints.substring(0,ints.length-1);
			if(confirm("确认删除["+empNames+"]吗？")){
				$.ajax({
					url:"${PATH }/emp/singleDelete/"+ints,
					type:"DELETE",
					success:function(date){
						alert(date.message);
						//跳转到删除页面
						PageNum(getPageNum);
					}
					
				})
			}
		})
		getDeptName("#geteEmpId");
		
		//按条件跳查询转页数
		function PageNum1(pn){
			var dId;
			var gender;
			$.each($("#geteEmpId"),function(){
				dId = $(this).val();
			})
			
			$.each($("#Gender"),function(){
				gender = $(this).val();
			})
			
			$.ajax({
				url:"${PATH }/emp/empByDeptName/"+pn,
				type:"POST",
				data:{"dId":dId,"gender":gender},
				success:function(data){
					//显示用户数据
					userData(data);
					//显示数据记录
					dataRecord(data);
					//显示分页信息
					pageInfo(data);
				}
			})
		}
		
		//按条件查询员工
		$("#btn_section").click(function(){
			//自定义变量
			$("body").attr("quer","section");
			PageNum1(1);
		})
		//查询全部员工
		$("#btn_all").click(function(){
			$("body").removeAttr("quer");
			PageNum(1);
		})
	})
	
</script>
</head>
<body>
	
<div class="container">
	<!-- 标题 -->
	<div class="row">
		<div class="col-md-12"><h1>SSM-CRUD</h1></div>
	</div>
		
		<!-- 搜索栏 -->
		<div class="form-group" id="deptNameData">
		    <label class="col-sm-1 control-label">部门查询</label>
		    <div class="col-sm-2">
		     <select class="form-control" name="dId" id="geteEmpId">
		     	
		     </select>
		    </div>
		    <div class="col-sm-1">
		     <select class="form-control" name="gender" id="Gender">
		     	<option value="">all</option>
		     	<option value="f">男</option>
		     	<option value="m">女</option>
		     </select>
		    </div>
		    <button class="btn btn-default" id="btn_section">查询</button>
		    <button class="btn btn-default" id="btn_all">全部员工</button>
		  </div>
	
	
	<!-- 新增 删除 -->
	<div class="row">
		<div class="col-md-5 col-md-offset-8"><button class="btn btn-primary" id="added_emp">新增</button>&nbsp;<button class="btn btn-danger" id="delete_emp">删除</button></div>
	</div>
	<!-- 表格 -->
	<div class="row">
		<div class="col-md-11">
		<table class="table table-hover" id="tb">
			<thead><tr><th><input type="checkbox" id="checks"></th><th>empId</th><th>empName</th><th>gender</th><th>email</th><th>deptName</th><th>操作</th></tr></thead>
			<tbody>
				<!-- 显示用户数据 -->
			</tbody>
		</table>
		</div>
	</div>
	<!-- 分页栏 -->
	<div class="row">
	<div class="col-md-6" id="dataRecord_div">
		<!--当前页：<span>${pageInfo.getPageNum() }, </span>
		一共<span>${pageInfo.getPages() }, </span>页
		一共<span>${pageInfo.getTotal() }</span>条记录-->
	</div>
	<div class="col-md-6">
	<nav aria-label="Page navigation">
	  <ul class="pagination">
	 	
	  </ul>
	</nav>
	</div>
	</div>
</div>

 
<!-- 新增模态框 -->
<div class="modal fade" id="emp_add" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
      </div>
      <div class="modal-body">
        <!-- from表单 -->
        <form class="form-horizontal">
		  <div class="form-group">
		    <label class="col-sm-2 control-label">empName</label>
		    <div class="col-sm-10">
		      <input type="text" name="empName" class="form-control" id="inputName" placeholder="empName">
		     <span class="help-block"></span>
		    </div>
		  </div>
		  <div class="form-group">
		    <label class="col-sm-2 control-label">email</label>
		    <div class="col-sm-10">
		      <input type="email" name="email" class="form-control" id="inputEmail" placeholder="123@wy.com">
		   	  <span class="help-block"></span>
		    </div>
		  </div>
		  
		  <div class="form-group">
		    <label class="col-sm-2 control-label">gender</label>
		    <div class="col-sm-10">
		    	<label class="radio-inline">
				  <input type="radio" name="gender" id="gender1" value="f" checked="checked"> 男
				</label>
				<label class="radio-inline">
				  <input type="radio" name="gender" id="gender2" value="m"> 女
				</label>
		    </div>
		  </div>
		  
		 <div class="form-group" id="emptNameData">
		    <label class="col-sm-2 control-label">deptName</label>
		    <div class="col-sm-3">
		     <select class="form-control" name="dId"></select>
		    </div>
		  </div>
		
		</form>

      </div>
      <div class="modal-footer" >
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" id="addTo">保存</button>
      </div>
    </div>
  </div>
</div>


<!-- 修改模态框 -->
<div class="modal fade" id="emp_update" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
      </div>
      <div class="modal-body">
        <!-- from表单 -->
        <form class="form-horizontal">
		  <div class="form-group">
		    <label class="col-sm-2 control-label">empName</label>
		    <div class="col-sm-10">
		      <input type="text" name="empName" class="form-control" id="updateName" placeholder="empName" readonly>
		     <span class="help-block"></span>
		    </div>
		  </div>
		  <div class="form-group">
		    <label class="col-sm-2 control-label">email</label>
		    <div class="col-sm-10">
		      <input type="email" name="email" class="form-control" id="updateEmail" placeholder="123@wy.com">
		   	  <span class="help-block"></span>
		    </div>
		  </div>
		  
		  <div class="form-group">
		    <label class="col-sm-2 control-label">gender</label>
		    <div class="col-sm-10">
		    	<label class="radio-inline">
				  <input type="radio" name="gender" id="gender1" value="f" checked="checked"> 男
				</label>
				<label class="radio-inline">
				  <input type="radio" name="gender" id="gender2" value="m"> 女
				</label>
		    </div>
		  </div>
		  
		 <div class="form-group" id="emptNameData">
		    <label class="col-sm-2 control-label">deptName</label>
		    <div class="col-sm-3">
		     <select class="form-control" name="dId"></select>
		    </div>
		  </div>
		
		</form>

      </div>
      <div class="modal-footer" >
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" id="saveTo">保存</button>
      </div>
    </div>
  </div>
</div>

</body>
</html>
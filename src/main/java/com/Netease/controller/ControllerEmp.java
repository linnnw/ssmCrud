package com.Netease.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.Netease.bean.Employee;
import com.Netease.bean.Msg;
import com.Netease.service.ServiceEmp;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

/**
 * 使用@ResponseBody需要jackson-databind的jar
 * @return
 */
@Controller
@RequestMapping("/emp")
public class ControllerEmp {
	
	@Autowired
	ServiceEmp serviceEmp;

	
	//rest风格
	@ResponseBody
	@RequestMapping(value = "/emps/{pn}",method = RequestMethod.GET)
	public Msg empAll(@PathVariable(value="pn") Integer pn){
		//pn是页数，5是每页5条
		PageHelper.startPage(pn, 5);
		//分页插件后面跟着的是查询要分页的数据
		List<Employee> list = serviceEmp.empAll();
		//数据存放在pageInfo，把list存放进去，5代表每次显示5页
		PageInfo<Employee> page = new PageInfo<Employee>(list,5);
		//page存入msg的map里
		return Msg.success().add("empAll", page);
	}
	@ResponseBody
	@RequestMapping(value = "/addEmp",method = RequestMethod.POST)
	public Msg addEmp(@Valid Employee record,BindingResult result) {
		//判断添加是否符合
		if(result.hasErrors()) {
			//获取错误信息
			List<FieldError> fieldErrors = result.getFieldErrors();
			Map<String, Object> map = new HashMap<String, Object>();
			for (FieldError fieldError : fieldErrors) {
				//把信息存入map中
				map.put(fieldError.getField(),fieldError.getDefaultMessage());
			}
			return Msg.fail().add("result", map);
		}else {
			//如果信息符合就添加用户
			serviceEmp.addEmp(record);
			return Msg.success();
		}
		
	}
	@ResponseBody
	@RequestMapping(value = "/addEmpJudgment",method = RequestMethod.POST)
	public Msg addEmpJudgment(String empName) {
	   
		// 验证规则    2-6位中文和email验证
	    String regEx[] = {"^[\u4E00-\u9FA5]{2,6}$","^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$"};
	    //判断用户名是否存在
    	boolean b = serviceEmp.addEmpJudgment(empName);
		if(b) {
			//如果用户名可用，判断是否是2-6位中文，比邮箱多判断了一个用户名是否已存在
			if(!empName.matches(regEx[0])) {
		    	return Msg.fail().add("msv", "用户名必须为2-6位中文");
		    }else {
		    	return Msg.success().add("msv", "用户名可用");
		    }
		}else {
			return Msg.fail().add("msv", "用户已存在");
		}
	    
	}
	@ResponseBody
	@RequestMapping(value = "/addEmpJudgment_email",method = RequestMethod.POST)
	public Msg addEmpJudgmentEmail(String email) {
		// 验证规则    2-6位中文和email验证
		String regEx[] = {"^[\u4E00-\u9FA5]{2,6}$","^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$"};
		//判断是否为合法邮箱
		if(!email.matches(regEx[1])) {
			//不是返回的信息
	    	return Msg.fail().add("msc", "邮箱格式不正确");
	    }else {
	    	return Msg.success().add("msc", "邮箱可用");
	    }
			
	}
	
	@ResponseBody
	@RequestMapping(value = "/selEmpById/{empId}",method = RequestMethod.POST)
	public Msg selEmpById(@PathVariable(value="empId") Integer empId) {
		Employee empaById = serviceEmp.selEmpaById(empId);
		return Msg.success().add("empaById", empaById);
	}
	
	@ResponseBody
	@RequestMapping(value = "/updateEmp/{empId}",method = RequestMethod.PUT)
	//没有empId不用加注解@PathVariable
	public Msg updateEmp(Employee record) {
		serviceEmp.updateEmp(record);
		return Msg.success();
	}
	@ResponseBody
	@RequestMapping(value = "/singleDelete/{empIds}",method = RequestMethod.DELETE)
	public Msg singleDelete(@PathVariable(value="empIds")String empIds) {
		if(empIds.contains("-")) {
			List<Integer> ints = new ArrayList<Integer>();
			String empIdss[] = empIds.split("-");
			for (String string : empIdss) {
				ints.add(Integer.parseInt(string));
			}
			serviceEmp.batchDeletion(ints);
			return Msg.success();
		}else {
			Integer empId = Integer.parseInt(empIds);
			serviceEmp.singleDelete(empId);
			return Msg.success();
		}
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/empByDeptName/{pn}",method = RequestMethod.POST)
	public Msg empByDeptName(@PathVariable(value="pn")Integer pn,Employee employee) {
		//pn是页数，5是每页5条
		PageHelper.startPage(pn, 5);
		//分页插件后面跟着的是查询要分页的数据
		List<Employee> list = serviceEmp.queryByCondition(employee);
		//数据存放在pageInfo，把list存放进去，5代表每次显示5页
		PageInfo<Employee> page = new PageInfo<Employee>(list,5);
		//page存入msg的map里
		return Msg.success().add("empAll", page);
	}
	
}

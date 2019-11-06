package com.Netease.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.Netease.bean.Department;
import com.Netease.bean.Msg;
import com.Netease.service.ServiceDept;
@Controller
@RequestMapping("/dept")
public class ControllerDept {
	
	@Autowired
	ServiceDept serviceDept;
	
	@ResponseBody
	@RequestMapping(value = "/getDeptName",method = RequestMethod.GET)
	public Msg getDeptName() {
		List<Department> deptName = serviceDept.getDeptName();
		return Msg.success().add("deptData", deptName);
	}
}

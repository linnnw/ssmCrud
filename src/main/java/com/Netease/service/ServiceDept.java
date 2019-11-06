package com.Netease.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.Netease.bean.Department;
import com.Netease.dao.DepartmentMapper;

@Service
public class ServiceDept {
	
	@Autowired
	DepartmentMapper dMapper;
	
	/**
	 * 获取部门信息
	 */
	public List<Department> getDeptName() {
		return dMapper.selectByExample(null);
	}
}

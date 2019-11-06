package com.Netease.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.Netease.bean.Employee;
import com.Netease.bean.EmployeeExample;
import com.Netease.bean.EmployeeExample.Criteria;
import com.Netease.dao.EmployeeMapper;
@Service
public class ServiceEmp {

	@Autowired
	EmployeeMapper employeeMapper;
	
	/**
	 * 查询所有用户
	 * @return 
	 */
	public List<Employee> empAll() {
		// TODO Auto-generated method stub
		return employeeMapper.selectByExampleWithDept(null);
	}
	/**
	 * 添加用户
	 */
	public void addEmp(Employee record) {
		employeeMapper.insertSelective(record);
	}
	/**
	 * 判断用户名是否重复
	 */
	public boolean addEmpJudgment(String empName) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpNameEqualTo(empName);
		long l = employeeMapper.countByExample(example);
		return l==0;
	}
	/**
	 * 修改用户信息
	 */
	public void updateEmp(Employee record) {
		employeeMapper.updateByPrimaryKeySelective(record);
	}
	/**
	 * 根据id查询用户
	 */
	public Employee selEmpaById(Integer empId) {
		return employeeMapper.selectByPrimaryKeyWithDept(empId);
	}
	/**
	 * 删除单个用户
	 */
	public void singleDelete(Integer empId) {
		employeeMapper.deleteByPrimaryKey(empId);
	}
	/**
	 * 批量删除用户
	 */
	public void batchDeletion(List<Integer> ints) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpIdIn(ints);
		employeeMapper.deleteByExample(example);
	}
	/**
	 * 根据部门id查询员工信息
	 */
	public List<Employee> empByDeptName(Employee employee) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andDIdEqualTo(employee.getdId());
		//criteria.andEmpNameEqualTo(employee.getEmpName());
		List<Employee> list = employeeMapper.selectByExampleWithDept(example);
		return list;
	}
	/**
	 * 按条件查询
	 */
	public List<Employee> queryByCondition(Employee employee){
		EmployeeExample employeeExample = new EmployeeExample();
		Criteria createCriteria = employeeExample.createCriteria();
		createCriteria.andDIdEqualTo(employee.getdId());
		if(!"".equals(employee.getGender())&&employee.getGender()!=null) {
			createCriteria.andGenderEqualTo(employee.getGender());
		}
		List<Employee> selectByExampleWithDept = employeeMapper.selectByExampleWithDept(employeeExample);
		return selectByExampleWithDept;
	}
	
}

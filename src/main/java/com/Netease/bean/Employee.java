package com.Netease.bean;

import javax.validation.constraints.Pattern;
import java.io.Serializable;
//继承Serializable接口才能使用redis
public class Employee implements Serializable{
    private Integer empId;
    
    @Pattern(regexp="^[\\u4E00-\\u9FA5]{2,6}$",message="用户名必须为2-6位中文")
    private String empName;

    private String gender;
    @Pattern(regexp="^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$",message="email格式错误")
    private String email;

    private Integer dId;
    
    private Department department;

    @Override
	public String toString() {
		return "Employee [empId=" + empId + ", empName=" + empName + ", gender=" + gender + ", email=" + email
				+ ", dId=" + dId + ", department=" + department + "]";
	}

	public Department getDepartment() {
		return department;
	}

	public void setDepartment(Department department) {
		this.department = department;
	}

	public Integer getEmpId() {
        return empId;
    }

    public void setEmpId(Integer empId) {
        this.empId = empId;
    }

    public String getEmpName() {
        return empName;
    }

    public void setEmpName(String empName) {
        this.empName = empName == null ? null : empName.trim();
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender == null ? null : gender.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim();
    }

    public Integer getdId() {
        return dId;
    }

    public void setdId(Integer dId) {
        this.dId = dId;
    }
}
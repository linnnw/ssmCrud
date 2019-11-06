package com.Netease.bean;

import java.io.Serializable;
//继承Serializable接口才能使用redis
public class Department implements Serializable{
    private Integer deptId;

    private String deptName;

    @Override
	public String toString() {
		return "Department [deptId=" + deptId + ", deptName=" + deptName + "]";
	}

	public Integer getDeptId() {
        return deptId;
    }

    public void setDeptId(Integer deptId) {
        this.deptId = deptId;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName == null ? null : deptName.trim();
    }
}
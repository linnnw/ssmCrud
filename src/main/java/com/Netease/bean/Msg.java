package com.Netease.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * 存放json数据
 * @author lenovo
 *
 */
public class Msg {
	//成功时为100，失败为200
	private String code;
	//结果
	private String message;
	//把返回值存入这里
	private Map<String, Object> extend = new HashMap<String, Object>();
	
	public Map<String, Object> getExtend() {
		return extend;
	}
	public void setExtend(Map<String, Object> extend) {
		this.extend = extend;
	}
	//成功时调用的方法
	public static Msg success() {
		Msg msg = new Msg();
		msg.setCode("100");
		msg.setMessage("成功");
		return msg;
	}
	//失败时调用的方法
	public static Msg fail() {
		Msg msg = new Msg();
		msg.setCode("200");
		msg.setMessage("失败");
		return msg;
	}
	//添加一个链式的add方法
	public Msg add(String key,Object value) {
		//获取map添加集合
		this.getExtend().put(key, value);
		return this;
	}
	
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
}

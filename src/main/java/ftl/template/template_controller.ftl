<#ftl encoding="utf-8"/>
package com.fwtai.controller.module;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.liangdun.yxf.${className}Service;
import com.liangdun.common.utils.ToolClient;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * ${tableComment}控制层|路由层
 * @作者 田应平
 * @版本 v1.0
 * @QQ号码 444141300
 * @创建日期 ${createDate}
 * @官网 <url>http://www.yinlz.com</url>
*/
@RestController
@RequestMapping("/${nameSpace}")
public final class ${className}Controller{

	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private ${className}Service service;
	
	/**跳转到目标页面*/
	@RequestMapping("/page")
	public final String page(){
		return "module/${nameSpace}";
	}
	
	/**添加*/
	@RequestMapping("/add")
	public final void add(final HttpServletRequest request,final HttpServletResponse response){
		try {
			ToolClient.responseJson(service.add(request),response);
		} catch (Exception e){
            if(e instanceof DuplicateKeyException){
                ToolClient.responseException(response,"所添加的数据已存在");
                return;
            }
			ToolClient.responseException(response);
		}
	}
	
	/**编辑*/
	@RequestMapping("/edit")
	public final void edit(final HttpServletRequest request,final HttpServletResponse response){
		try {
			ToolClient.responseJson(service.edit(request),response);
		} catch (Exception e){
			logger.error(e.getMessage());
            if(e instanceof DuplicateKeyException){
                ToolClient.responseException(response,"所编辑的数据已存在");
                return;
            }
			ToolClient.responseException(response);
		}
	}
	
	/**行删除*/
	@RequestMapping("/delById")
	public final void delById(final HttpServletRequest request,final HttpServletResponse response){
		try {
			ToolClient.responseJson(service.delById(ToolClient.getFormData(request)),response);
		} catch (Exception e){
			logger.error(e.getMessage());
			ToolClient.responseException(response);
		}
	}
	
	/**删除|批量删除*/
	@RequestMapping("/delIds")
	public final void delIds(final HttpServletRequest request,final HttpServletResponse response){
		try {
			ToolClient.responseJson(service.delIds(ToolClient.getFormData(request)),response);
		} catch (Exception e){
			logger.error(e.getMessage());
			ToolClient.responseException(response);
		}
	}
	
	/**数据列表 */
	@RequestMapping("/listData")
	public final void listData(final HttpServletRequest request,final HttpServletResponse response){
		ToolClient.responseJson(service.listData(request),response);
	}
	
	/**根据id获取全字段数据 */
	@RequestMapping("/queryById")
	public final void queryById(final HttpServletRequest request,final HttpServletResponse response){
		ToolClient.responseJson(service.queryById(ToolClient.getFormData(request)),response);
	}
}
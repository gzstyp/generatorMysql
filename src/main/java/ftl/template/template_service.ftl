<#ftl encoding="utf-8"/>
package com.fwtai.service.module;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.liangdun.common.bean.PageFormData;
import com.liangdun.common.config.ConfigFile;
import com.liangdun.common.utils.ToolClient;
import com.liangdun.common.utils.ToolString;
import com.liangdun.dao.DaoBase;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * ${tableComment}业务层
 * @作者 田应平
 * @版本 v1.0
 * @QQ号码 444141300
 * @创建日期 ${createDate}
 * @官网 <url>http://www.yinlz.com</url>
*/
@Service
public class ${className}Service{

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	private DaoBase dao;
	
	/**添加*/
	public String add(final HttpServletRequest request)throws Exception{
		final PageFormData pageFormData = ToolClient.getFormData(request);
		pageFormData.put("${keyId}",ToolString.getIdsChar32());
        pageFormData.put("enterprise_id",ToolClient.enterpriseKey(request));
		return ToolClient.executeRows(dao.execute("${nameSpace}.add",pageFormData));
	}
	
	/**编辑*/
	public String edit(final HttpServletRequest request)throws Exception{
		final PageFormData pageFormData = ToolClient.getFormData(request);
		if(!ToolClient.validateField(pageFormData,new String[]{"${keyId}"}))return ToolClient.jsonValidateField();
		return ToolClient.executeRows(dao.execute("${nameSpace}.edit",pageFormData));
	}
	
	/**行删除*/
	public String delById(final PageFormData pageFormData)throws Exception{
		if(!ToolClient.validateField(pageFormData,new String[]{"${keyId}"}))return ToolClient.jsonValidateField();
		return ToolClient.executeRows(dao.execute("${nameSpace}.delById",pageFormData.getString("${keyId}")));
	}
	
	/**删除[含批量删除]*/
	public String delIds(final PageFormData pageFormData)throws Exception{
		if(!ToolClient.validateField(pageFormData,new String[]{"ids"}))return ToolClient.jsonValidateField();
		final String ids = pageFormData.getString("ids");
		final ArrayList<String> listIds = ToolString.keysToList(ids,",");
		int rows = 0 ;
		if(listIds != null && listIds.size() > 0){
			rows = dao.executeBatch("${nameSpace}.delIds",listIds);//批量删除
		}
		return ToolClient.executeRows(rows);
	}
	
	/**数据列表*/
	public String listData(final HttpServletRequest request){
		try{
            final PageFormData pageFormData = ToolClient.datagridPagingMysql(ToolClient.getFormData(request));
            pageFormData.put("enterprise_id",ToolClient.enterpriseKey(request));
			final HashMap<String, Object> map = dao.queryForPage(pageFormData,"${nameSpace}.listData","${nameSpace}.listTotal");
			return ToolClient.jsonDatagrid(map.get(ConfigFile.listData),map.get(ConfigFile.total));
		} catch (Exception e){
			logger.error("${className}Service的方法listData(出现异常:",e);
			return ToolClient.exceptionJson();
		}
	}
	
	/**根据id获取全字段数据*/
	public String queryById(final PageFormData pageFormData){
		final String json = ToolClient.validateFields(pageFormData,new String[]{"id"});
		if(!ToolString.isBlank(json))return json;
		try {
			return ToolClient.queryJson(dao.queryForHashMap("${nameSpace}.queryById",pageFormData.getString("id")));
		} catch (Exception e){
			logger.error("${className}Service的queryById出现异常",e);
			return ToolClient.exceptionJson();
		}
	}
}
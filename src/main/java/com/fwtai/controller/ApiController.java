package com.fwtai.controller;

import com.fwtai.tool.ToolClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 远程调用接口,IE8正常
 * @作者 田应平
 * @版本 v1.0
 * @创建时间 2020-02-02 23:02
 * @QQ号码 444141300
 * @Email service@yinlz.com
 * @官网 <url>http://www.yinlz.com</url>
 */
@RestController
@RequestMapping("/api")
public final class ApiController{

    @Resource
    private HttpServletRequest request;

    @GetMapping("/list")
    public final void list(final HttpServletResponse response){
        final String json = ToolClient.createJsonSuccess("操作成功");
        ToolClient.responseJson(json,response);
    }

    @GetMapping("/get")
    public final void get(final HttpServletResponse response){
        final String json = ToolClient.createJsonSuccess("操作成功");
        ToolClient.responseJson(json,response);
    }

    @GetMapping("{value}")// http://127.0.0.1/api/100
    public final void value(@PathVariable("value") String value,final HttpServletResponse response){
        final String json = ToolClient.createJsonSuccess(value);
        ToolClient.responseJson(json,response);
    }
}
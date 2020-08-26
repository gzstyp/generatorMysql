<#ftl encoding="utf-8"/>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%
final String path = request.getContextPath();
final String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html lang="cn">
<head>
    <meta charset="utf-8"/>
    <base href="<%=basePath%>">
    <title>${tableComment}</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <jsp:include page="/WEB-INF/view/conn_css.jsp"/>
    <style type="text/css">
        a:link,a:visited,a:active{
            color:#000;
            text-decoration: none;
            outline:none;
        }
        a:hover{
            color:#1e9fff;
        }
    </style>
</head>
<body style="padding-top:8px;padding-left:6px;">
<div fit="true" class="easyui-panel" border="false" style="padding:0px;">
    <div id="toolbar_${nameSpace}" class="authClassToolbar" style="padding-top:2px; padding-bottom:2px;height:auto;">
        <form id='search_${nameSpace}'>
            <table border="0">
                <tr>
                    <td><input type="text" id='key_word' class="h24px w160px" style="width:150px;height:26px;line-height:26px;" placeholder="关键字" title="输入搜索关键字"/></td>
                    <td><button type="button" class="btnBlue" onclick="thisPage.search();">搜索</button></td>
                    <td><button type="button" class="btnBlue" onclick="thisPage.edit(2);">添加</button></td>
                    <td><button type="button" class="btnWarn" onclick="thisPage.delByIds();">删除</button></td>
                </tr>
            </table>
        </form>
    </div>
    <table id="datagrid_${nameSpace}" style="width:99%;height:760px;border:0px"
           data-options="singleSelect:false,pagination:true,collapsible:true,url:'/${nameSpace}/listData',method:'get',idField:'${keyId}',checkOnSelect:false,toolbar:'#toolbar_${nameSpace}',pageSize:21,pageList:[21,50,100,200]">
        <thead>
        <tr>
            <th field="${keyId}" checkbox="true"></th>
        <#list listData as ld>
            <#if "${keyId}" != "${ld.column_name}">
            <th data-options="field:'${ld.column_name}',width:'10%',"><#if ld.column_comment ?? && ld.column_comment != ''>${ld.column_comment}<#else>字段注释</#if></th>
            </#if>
        </#list>
            <th data-options="field:'_${keyId}_',width:'17%',formatter:thisPage.formatOper,">操作</th>
        </tr>
        </thead>
    </table>
</div>
<input type="hidden" id="${nameSpace}_edit_keyId"/>
<!-- 添加|编辑 -->
<div id='${nameSpace}_edit_dialog' style="display:none;">
    <table cellspacing="4" cellpadding="0" width="100%" class="view" border="0" style="margin-top:6px;">
		<#list listData as ld>
		<#if "${keyId}" == "${ld.column_name}">
        <#else>
		<tr>
            <td style="text-align:right;padding-right:4px;"><#if ld.column_comment ?? && ld.column_comment != ''>${ld.column_comment}<#else>字段注释</#if></td>
            <td style="text-align:left;"><input type="text" id='${ld.column_name}' name='${ld.column_name}' class="h24px w160px" placeholder="输入${ld.column_comment !'数据'}" title="请输入${ld.column_comment !'数据'}"/><span class="required">*</span></td>
        </tr>
        </#if>
        </#list>
    </table>
</div>
<jsp:include page="/WEB-INF/view/conn_js.jsp"/>
<script type="text/javascript">
    var dataGrid;
    (function ($){
        var uri = '/${nameSpace}/';/*请求controller层的url*/
        thisPage = {
            datagrid : '#datagrid_${nameSpace}',/*datagrid的id标识*/
            toolbar : '#toolbar_${nameSpace}',/*toolbar的id标识*/
            edit_keyId : '#${nameSpace}_edit_keyId',/*修改时的keyId标识*/
            dialog_edit : '#${nameSpace}_edit_dialog',/*编辑或添加容器id标识*/
            urlList : uri+'listData',/*获取datagrid数据的url*/
            urlAdd : uri+'add?',/*添加时提交的url*/
            urlEdit : uri+'edit?',/*编辑时提交的url*/
            urlQueryById : uri+'queryById',/*根据id查询全字段数据的url*/
            urlDelById : uri+'delById',/*单条删除的url*/
            urlDelIds : uri+'delIds',/*批量删除的url*/
            init : function(){
                dataGrid = $('#datagrid_${nameSpace}').datagrid({});
            },
            formatSex : function(value,rowData,index){
                if(value == 1){
                    return '男';
                }else if(value == 2){
                    return '女';
                }else{
                    return '';
                }
            },
            formatOper : function(value,rowData,index){
                return '<a onclick="thisPage.edit(1,\''+rowData.${keyId}+'\');" href="javascript:;">编辑</a><span style="margin:0 8px;">|</span><a style="color:#ff8080;" onclick="thisPage.delById(\''+rowData.${keyId}+'\');" href="javascript:;">删除</a>';
            },
            /**搜索*/
            search : function(){
                var params = {
                    <#list listData as ld>
                    <#if "${keyId}" != "${ld.column_name}">
                    ${ld.column_name} : winFn.getDomValue('#key_${ld.column_name}'),
                    </#if>
                    </#list>
                };
                this.reloadData(params);
            },
            /**type=1编辑;2添加;其他未知;*/
            edit : function(type,${keyId}){
                var title = type === 1 ?"编辑":"添加";
                type = type === 1 ? 1 : 2;//1编辑;2添加;其他未知
                if (type === 1){
                    winFn.setDomValue(thisPage.edit_keyId,${keyId});
                    euiFn.queryRowDataById(thisPage.urlQueryById,${keyId},function(map){
                        thisPage.openDialog(type,title,map);
                    });
                } else {
                    winFn.setDomValue(thisPage.edit_keyId,'');
                    thisPage.openDialog(type,title,null);
                }
            },
            /**打开提交对话框,含编辑及添加*/
            openDialog : function(type,title,map){
                layerFn.addOrEdit(title,thisPage.dialog_edit,['500px','400px'],function(index){
					<#list listData as ld>
                    <#if "${keyId}" == "${ld.column_name}">
                    <#else>
                    if(verifyFn.inputRequired('#${ld.column_name}')){
                        layerFn.center(AppKey.code.code199,'${ld.column_comment !'数据'}不能为空');
                        return;
                    }
                    </#if>
                    </#list>
                    var params = {
                        editType : type,
                        ${keyId} : winFn.getDomValue(thisPage.edit_keyId),
						<#list listData as ld>
                        <#if "${keyId}" == "${ld.column_name}">
                        <#else>
                        ${ld.column_name} : winFn.getDomValue('#${ld.column_name}'),
                        </#if>
                        </#list>
                    };
                    thisPage.commit(type,index,params);
                });
                winFn.clearFormData(thisPage.dialog_edit);
                if(map != null && map !=''){
				<#list listData as ld>
                    <#if "${keyId}" == "${ld.column_name}">
                    <#else>
					winFn.setDomValue('#${ld.column_name}',map.${ld.column_name}+'');
                    </#if>
                </#list>
                }
            },
            /**删除行*/
            delById : function(${keyId}){
                layerFn.confirm('删除后将无法恢复,确定吗?',function(){
                    layerFn.submit(thisPage.urlDelById,{${keyId}:${keyId}},function(data){
                        euiFn.showRb(data.code,data.msg);
                        euiFn.refreshDatagrid(thisPage.datagrid,{},1);
                    })
                });
            },
            /**批量删除*/
            delByIds : function(){
                var ids = winFn.checkboxBatch('${keyId}');
                if (verifyFn.isEmpty(ids)){
                    layerFn.center(AppKey.code.code201,'请选择要删除的数据!');
                    return;
                }
                layerFn.confirm('所选[ '+(ids.split(',').length)+" ]条数据删除之后将无法恢复,确定吗?",function(){
                    layerFn.delBatchHint(thisPage.urlDelIds,ids,'删除中,请稍候……',function(data){
                        euiFn.showRb(data.code,data.msg);
                        euiFn.refreshDatagrid(thisPage.datagrid,{},1);
                    });
                });
            },
            /**1编辑或2添加的提交*/
            commit : function(type,index,params){
                var url = thisPage.urlAdd;
                if(type === 1){
                    url = thisPage.urlEdit;
                }
                layerFn.submit(url,params,function(data){
                    layer.closeAll();
                    thisPage.reloadData();
                    euiFn.showRb(data.code,data.msg);
                });
            },
            reloadData(params){
                dataGrid.datagrid('clearSelections');
                if(params != null && params != ''){
                    dataGrid.datagrid('load',params);
                }else{
                    dataGrid.datagrid('load');
                }
            }
        };
        thisPage.init();
    })(jQuery);
</script>
</body>
</html>
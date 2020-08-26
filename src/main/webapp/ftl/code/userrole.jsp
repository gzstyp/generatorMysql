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
    <title>用户角色</title>
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
    <div id="toolbar_sys_user_role" class="authClassToolbar" style="padding-top:2px; padding-bottom:2px;height:auto;">
        <form id='search_sys_user_role'>
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
    <table id="datagrid_sys_user_role" style="width:99%;height:760px;border:0px"
           data-options="singleSelect:false,pagination:true,collapsible:true,url:'/sys_user_role/listData',method:'get',idField:'KID',checkOnSelect:false,toolbar:'#toolbar_sys_user_role',pageSize:21,pageList:[21,50,100,200]">
        <thead>
        <tr>
            <th field="KID" checkbox="true"></th>
            <th data-options="field:'kid',width:'10%',">id主键</th>
            <th data-options="field:'role_id',width:'10%',">角色的id(sys_role.kid)</th>
            <th data-options="field:'user_id',width:'10%',">用户名|账号的id(sys_user.kid)</th>
            <th data-options="field:'_KID_',width:'17%',formatter:thisPage.formatOper,">操作</th>
        </tr>
        </thead>
    </table>
</div>
<input type="hidden" id="sys_user_role_edit_keyId"/>
<!-- 添加|编辑 -->
<div id='sys_user_role_edit_dialog' style="display:none;">
    <table cellspacing="4" cellpadding="0" width="100%" class="view" border="0" style="margin-top:6px;">
		<tr>
            <td style="text-align:right;padding-right:4px;">id主键</td>
            <td style="text-align:left;"><input type="text" id='kid' name='kid' class="h24px w160px" placeholder="输入id主键" title="请输入id主键"/><span class="required">*</span></td>
        </tr>
		<tr>
            <td style="text-align:right;padding-right:4px;">角色的id(sys_role.kid)</td>
            <td style="text-align:left;"><input type="text" id='role_id' name='role_id' class="h24px w160px" placeholder="输入角色的id(sys_role.kid)" title="请输入角色的id(sys_role.kid)"/><span class="required">*</span></td>
        </tr>
		<tr>
            <td style="text-align:right;padding-right:4px;">用户名|账号的id(sys_user.kid)</td>
            <td style="text-align:left;"><input type="text" id='user_id' name='user_id' class="h24px w160px" placeholder="输入用户名|账号的id(sys_user.kid)" title="请输入用户名|账号的id(sys_user.kid)"/><span class="required">*</span></td>
        </tr>
    </table>
</div>
<jsp:include page="/WEB-INF/view/conn_js.jsp"/>
<script type="text/javascript">
    var dataGrid;
    (function ($){
        var uri = '/sys_user_role/';/*请求controller层的url*/
        thisPage = {
            datagrid : '#datagrid_sys_user_role',/*datagrid的id标识*/
            toolbar : '#toolbar_sys_user_role',/*toolbar的id标识*/
            edit_keyId : '#sys_user_role_edit_keyId',/*修改时的keyId标识*/
            dialog_edit : '#sys_user_role_edit_dialog',/*编辑或添加容器id标识*/
            urlList : uri+'listData',/*获取datagrid数据的url*/
            urlAdd : uri+'add?',/*添加时提交的url*/
            urlEdit : uri+'edit?',/*编辑时提交的url*/
            urlQueryById : uri+'queryById',/*根据id查询全字段数据的url*/
            urlDelById : uri+'delById',/*单条删除的url*/
            urlDelIds : uri+'delIds',/*批量删除的url*/
            init : function(){
                dataGrid = $('#datagrid_sys_user_role').datagrid({});
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
                return '<a onclick="thisPage.edit(1,\''+rowData.KID+'\');" href="javascript:;">编辑</a><span style="margin:0 8px;">|</span><a style="color:#ff8080;" onclick="thisPage.delById(\''+rowData.KID+'\');" href="javascript:;">删除</a>';
            },
            /**搜索*/
            search : function(){
                var params = {
                    kid : winFn.getDomValue('#key_kid'),
                    role_id : winFn.getDomValue('#key_role_id'),
                    user_id : winFn.getDomValue('#key_user_id'),
                };
                this.reloadData(params);
            },
            /**type=1编辑;2添加;其他未知;*/
            edit : function(type,KID){
                var title = type === 1 ?"编辑":"添加";
                type = type === 1 ? 1 : 2;//1编辑;2添加;其他未知
                if (type === 1){
                    winFn.setDomValue(thisPage.edit_keyId,KID);
                    euiFn.queryRowDataById(thisPage.urlQueryById,KID,function(map){
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
                    if(verifyFn.inputRequired('#kid')){
                        layerFn.center(AppKey.code.code199,'id主键不能为空');
                        return;
                    }
                    if(verifyFn.inputRequired('#role_id')){
                        layerFn.center(AppKey.code.code199,'角色的id(sys_role.kid)不能为空');
                        return;
                    }
                    if(verifyFn.inputRequired('#user_id')){
                        layerFn.center(AppKey.code.code199,'用户名|账号的id(sys_user.kid)不能为空');
                        return;
                    }
                    var params = {
                        editType : type,
                        KID : winFn.getDomValue(thisPage.edit_keyId),
                        kid : winFn.getDomValue('#kid'),
                        role_id : winFn.getDomValue('#role_id'),
                        user_id : winFn.getDomValue('#user_id'),
                    };
                    thisPage.commit(type,index,params);
                });
                winFn.clearFormData(thisPage.dialog_edit);
                if(map != null && map !=''){
					winFn.setDomValue('#kid',map.kid+'');
					winFn.setDomValue('#role_id',map.role_id+'');
					winFn.setDomValue('#user_id',map.user_id+'');
                }
            },
            /**删除行*/
            delById : function(KID){
                layerFn.confirm('删除后将无法恢复,确定吗?',function(){
                    layerFn.submit(thisPage.urlDelById,{KID:KID},function(data){
                        euiFn.showRb(data.code,data.msg);
                        euiFn.refreshDatagrid(thisPage.datagrid,{},1);
                    })
                });
            },
            /**批量删除*/
            delByIds : function(){
                var ids = winFn.checkboxBatch('KID');
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="easyui-panel" title="Nested Panel" data-options="width:'100%',minHeight:500,noheader:true,border:false" style="padding:10px;">
    <div class="easyui-layout" data-options="fit:true">
        <div data-options="region:'west',split:false" style="width:250px;padding:5px">
            <ul id="contentCategoryTree" class="easyui-tree" data-options="url:'/content/category',animate: true,method : 'GET'">
            </ul>
        </div>
        <div data-options="region:'center'" style="padding:5px">
            <table class="easyui-datagrid" id="contentList" data-options="toolbar:contentListToolbar,singleSelect:false,collapsible:true,pagination:true,method:'get',pageSize:20,url:'/content/list',queryParams:{categoryId:0}">
		    <thead>
		        <tr>
		            <th data-options="field:'id',width:30">ID</th>
		            <th data-options="field:'title',width:120,formatter:TAOTAO.formatText">内容标题</th>
		            <th data-options="field:'subTitle',width:100,formatter:TAOTAO.formatText">内容子标题</th>
		            <th data-options="field:'titleDesc',width:120,formatter:TAOTAO.formatText">内容描述</th>
		            <th data-options="field:'url',width:60,align:'center',formatter:TAOTAO.formatUrl">内容连接</th>
		            <th data-options="field:'pic',width:50,align:'center',formatter:TAOTAO.formatUrl">图片</th>
		            <th data-options="field:'pic2',width:50,align:'center',formatter:TAOTAO.formatUrl">图片2</th>
		            <th data-options="field:'created',width:130,align:'center',formatter:TAOTAO.formatDateTime">创建日期</th>
		            <th data-options="field:'updated',width:130,align:'center',formatter:TAOTAO.formatDateTime">更新日期</th>
		        </tr>
		    </thead>
		</table>
        </div>
    </div>
</div>
<script type="text/javascript">
$(function(){
	//获取树组件
	var tree = $("#contentCategoryTree");
	//获取datagrid组件
	var datagrid = $("#contentList");
	tree.tree({
		//给树上所有节点绑定点击事件
		onClick : function(node){
			//如果当前选中节点为叶子节点
			if(tree.tree("isLeaf",node.target)){
				//刷新datagrid组件，其实就是重新请求后台，获取数据
				datagrid.datagrid('reload', {
					categoryId :node.id
		        });
			}
		}
	});
});

//datagrid组件按钮参数初始化
var contentListToolbar = [{
    text:'新增',
    iconCls:'icon-add',
    handler:function(){
    	//获取树的选中节点
    	var node = $("#contentCategoryTree").tree("getSelected");
    	//判断有没有选中节点，或者选中的节点不是叶子节点
    	if(!node || !$("#contentCategoryTree").tree("isLeaf",node.target)){
    		$.messager.alert('提示','新增内容必须选择一个内容分类!');
    		//结束操作
    		return ;
    	}
    	//如果选中叶子节点
    	//创建新窗口，新窗口的地址为：/page/content-add
    	createWindow({
			url : "/page/content-add"
		}); 
    }
},{
    text:'编辑',
    iconCls:'icon-edit',
    handler:function(){
    	var ids = TT.getSelectionsIds("#contentList");
    	if(ids.length == 0){
    		$.messager.alert('提示','必须选择一个内容才能编辑!');
    		return ;
    	}
    	if(ids.indexOf(',') > 0){
    		$.messager.alert('提示','只能选择一个内容!');
    		return ;
    	}
		TT.createWindow({
			url : "/page/content-edit",
			onLoad : function(){
				var data = $("#contentList").datagrid("getSelections")[0];
				$("#contentEditForm").form("load",data);
				
				// 实现图片
				if(data.pic){
					$("#contentEditForm [name=pic]").after("<a href='"+data.pic+"' target='_blank'><img src='"+data.pic+"' width='80' height='50'/></a>");	
				}
				if(data.pic2){
					$("#contentEditForm [name=pic2]").after("<a href='"+data.pic2+"' target='_blank'><img src='"+data.pic2+"' width='80' height='50'/></a>");					
				}
				
				contentEditEditor.html(data.content);
			}
		});    	
    }
},{
    text:'删除',
    iconCls:'icon-cancel',
    handler:function(){
    	var ids = TT.getSelectionsIds("#contentList");
    	if(ids.length == 0){
    		$.messager.alert('提示','未选中商品!');
    		return ;
    	}
    	$.messager.confirm('确认','确定删除ID为 '+ids+' 的内容吗？',function(r){
    	    if (r){
    	    	var params = {"ids":ids};
            	$.post("/content/delete",params, function(data){
        			if(data.status == 200){
        				$.messager.alert('提示','删除内容成功!',undefined,function(){
        					$("#contentList").datagrid("reload");
        				});
        			}
        		});
    	    }
    	});
    }
}];

	function createWindow(params){
		$("<div>").css({padding:"5px"}).window({
			width : params.width?params.width:"80%",
			height : params.height?params.height:"80%",
			modal:true,
			title : params.title?params.title:" ",
			href : params.url,
			onClose : function(){
				$(this).window("destroy");
			},
			onLoad : function(){
				if(params.onLoad){
					params.onLoad.call(this);
				}
			}
		}).window("open");
	}

</script>
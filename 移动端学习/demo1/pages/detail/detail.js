
var api =require('../../utils/api.js');

Page({
	data:{
		list:{}
	},
	onLoad:function(options){
		var id = options.id;
		api.getDetail(id)
			.then(res=>{
				this.setData({
					list:res
				})
			})
	},
	onReady:function(){
		
	},
	onShow:function(){
		
	},
	onHide:function(){
		
	},
	onUnload:function(){
		
	},
	onPullDownRefresh:function(){
		
	},
	onReachBottom:function(){
		
	}
})		
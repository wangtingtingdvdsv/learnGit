var api = require('../../utils/api.js');

Page({
	data:{
		pn:0,
		list:[],
		showMore:true,
		showLoading:true

	},
	redirect:function(e){
		var id = e.currentTarget.dataset.id;

		wx.navigateTo({
			url:'../detail/detail?id='+id
		})
	},
	scrolltolower:function(e){
		if(!this.data.showMore)return;
		this.loadData(this.data.pn);
	},
	loadData:function(pn){
		api.getList('in_theaters',pn)
			.then(res=>{
				if(res.subjects.length>0){
					this.setData({
						list:this.data.list.concat(res.subjects),
						showLoading:false,
						pn:pn+1
					})
				}else{
					this.setData({
						showMore:false
					})
				}
			})
	},
	onLoad:function(options){
		this.loadData(this.data.pn)
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
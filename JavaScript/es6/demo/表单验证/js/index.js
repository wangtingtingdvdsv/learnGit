$("#idNum").on('input', function() {
	alert(2);
})
$("#pawo").on('input', function() {
	alert(2);
})
$("#sub").on('click', function() {
	$.ajax({
		url: 'https://data.com',
		type: 'GET',
		dataType: "jsonp",
		success:function(data) {
			console.log("数据请求成功");
			
		},
		error:function(er){
			console.log("数据请求失败");
		}
	});
})
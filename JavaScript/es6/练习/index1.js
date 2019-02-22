function parentFun() {
	var storage = localStorage.getItem("key");
	if (storage) {
		alert("已获取");
	}
}

setInterval("parentFun()", 1000);

window.onstorage = evt => {
	alert(2);
	console.log(evt);
  // evt.key, evt.oldValue, evt.newValue
}
$(".openSon").on('click', function() {
	
	var son = window.open('son.html', '_blank', "width=500, height=500")
	
})

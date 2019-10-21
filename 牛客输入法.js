

//var json = {"k3845":{"name":"name3012","price":2715,"rank":1},"k3489":{"name":"name2855","price":3105,"rank":1},"k3847":{"name":"name3012","price":2715,"rank":2}};
var json = readline();
var obj = JSON.parse(JSON.stringify(json));
console.log(obj);
var arr = [];
for(var item in obj) {
	arr.push({
		key: item,
		value: obj[item]
	})
}
arr.sort(function(a, b) {
	if(a.value.price-b.value.price == 0 ) {
		return b.value.rank-a.value.rank
	} else {
		return a.value.price-b.value.price
	}
})
arr.forEach(function(item) {
	console.log(item.value.name+":"+item.value.rank+":"+item.key+":"+item.value.price)
})


// var n = parseInt(readline());
// var ans = 0;
// for(var i = 0;i < n; i++){
//     lines = readline().split(" ")
//     for(var j = 0;j < lines.length; j++){
//         ans += parseInt(lines[j]);
//     }
// }
// print(ans);
// ------------
// var n = parseInt(readline());
// var ans = 0;
// for(var i = 0;i < n; i++){
//     lines = readline().split(" ")
//     for(var j = 0;j < lines.length; j++){
//         ans += parseInt(lines[j]);
//     }
// }
// print(ans);
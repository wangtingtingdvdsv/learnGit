var express = require('express'); //引入express模块
var app = express();

var bodyParser = require('body-parser');  //这两个是为了使用req.body获取post的数据
var urlencodedParser = bodyParser.urlencoded({ extended: false })

// app.all('*', function(req, res, next) {
//     res.header("Access-Control-Allow-Origin", "*");
//     res.header("Access-Control-Allow-Headers", "X-Requested-With");
//     res.header("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS");
//     res.header("X-Powered-By",' 3.2.1')
//     res.header("Content-Type", "application/json;charset=utf-8");
//     next();
// });

app.get('/info',  function(req, res){
  var obj={
    name: 'wa', 
    sex:'nv'
  }  
  res.send("obj", obj)
});
app.listen(3333);

function urlParse(url) {  
  // 得到url问号后面拼接的参数  ?id=12345&a=b  
  let obj = {};// 创建一个Object  
  let reg = /[?&][^?&]+=[^?&]+/g;// 正则匹配 ?&开始 =拼接  非?&结束  的参数  
  let arr = url.match(reg);// match() 方法可在字符串内检索指定的值，或找到一个或多个正则表达式的匹配。  
  // arr数组形式 ['?id=12345','&a=b']  
  if (arr) {  
    arr.forEach((item) => {  
      /** 
       * tempArr数组    ['id','12345']和['a','b'] 
      * 第一个是key，第二个是value 
      * */  
      let tempArr = item.substring(1).split('=');  
      let key = decodeURIComponent(tempArr[0]);  
      let val = decodeURIComponent(tempArr[1]);  
      obj[key] = val;  
    });  
  }  
  return obj;  
};  
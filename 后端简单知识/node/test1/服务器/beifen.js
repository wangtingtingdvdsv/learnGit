// var express = require('express'); //引入express模块
// var app = express();  //express对象
// var bodyParser = require('body-parser');
// var urlencodedParser = bodyParser.urlencoded({ extended: false })

const koaBody = require('koa-body')  //使得可以通过ctx.request.body获取用户传给后台的值
const sha1 = require('sha1') 
const Koa = require('koa')
const Router = require('koa-router')
const axios = require('axios')
const koaSession = require('koa-session')

const app = new Koa()


const createError = (code, resp) => {
    const err = new Error(resp.message)
    err.code = code
    return err
  }

const handleRequest = ({ status, data, ...rest }) => {
    if (status === 200) {
      return data
    } else {
      throw createError(status, rest)
    }
  }

app.keys = ['vue ssr tech']
app.use(koaSession({          //这个是必须的操作，只有这样，用户才真正的登录成功
  key: 'v-ssr-id',
  maxAge: 2 * 60 * 60 * 1000  //过期时间
}, app))

const db = {
    appId: 'A6080003742490',
    appKey: '3122A704-87DA-D8FE-ADB7-32F13576097B'
}

const request = axios.create({
    baseURL: 'https://d.apicloud.com/mcm/api'
  })

const apiRouter = new Router({ prefix: '/api' })
const userRouter = new Router({ prefix: '/user' })

userRouter.post('/login', async ctx => {
    const user = ctx.request.body
    console.log('user', user);
    // if (user.username === 'jokcy' && user.password === 'jokcy111') {
    //     ctx.session.user = {
    //       username: 'jokcy'
    //     }
    //     ctx.body = {
    //       success: true,
    //       data: {
    //         username: 'jokcy'
    //       }
    //     }
    //   } else {
    //     ctx.status = 400
    //     ctx.body = {
    //       success: false,
    //       message: 'username or password error'
    //     }
    //   }
})

const getHeaders = () => {
    const now = Date.now()
    return {
      'X-APICloud-AppId': db.appId,
      'X-APICloud-AppKey': `${sha1(`${db.appId}UZ${db.appKey}UZ${now}`)}.${now}`
    }
  }


const successResponse = (data) => {
    return {
      success: true,
      data
    }
  }

  apiRouter
  .get('/todos', async (ctx) => {
    const todos = await getAllTodos()   //这里必须用异步操作
    ctx.body = successResponse(todos)
  })


app.use(koaBody())
app.use(userRouter.routes()).use(userRouter.allowedMethods())
app.use(apiRouter.routes()).use(apiRouter.allowedMethods())


app.listen(3333, function() {
    console.log('server now listening at port 3333');
});
// var reportArr = [
//     {
//        reportTime:"2018-5-5",
//        reportName:"麻辣烫",
//        reportServerName:"价钱太高",
//        reportInfringementReason:"无",
//        reportInfringementCaption:"无",
//        reportPicLink:"http://seopic.699pic.com/photo/00013/6254.jpg_wh1200.jpg",
//        reportPeopleName:"庄三",
//        reportPeopleId:"12237645",
//        reportPeopleNum:"567452235687"
//     },{
//        reportTime:"2018-3-6",
//        reportName:"木桶饭",
//        reportServerName:"菜太少了，没肉",
//        reportInfringementReason:"无",
//        reportInfringementCaption:"无",
//        reportPicLink:"http://seopic.699pic.com/photo/00013/6254.jpg_wh1200.jpg",
//        reportPeopleName:"李素",
//        reportPeopleId:"12237645",
//        reportPeopleNum:"567452235687"
//     },{
//        reportTime:"2018-2-5",
//        reportName:"粗粮面",
//        reportServerName:"面太生了",
//        reportInfringementReason:"无",
//        reportInfringementCaption:"无",
//        reportPicLink:"http://seopic.699pic.com/photo/00013/6254.jpg_wh1200.jpg",
//        reportPeopleName:"王都",
//        reportPeopleId:"12237645",
//        reportPeopleNum:"567452235687"
//     },{
//        reportTime:"2018-3-26",
//        reportName:"裤带面",
//        reportServerName:"面太长了",
//        reportInfringementReason:"无",
//        reportInfringementCaption:"无",
//        reportPicLink:"http://seopic.699pic.com/photo/00013/6254.jpg_wh1200.jpg",
//        reportPeopleName:"王月",
//        reportPeopleId:"12237645",
//        reportPeopleNum:"567452235687"
//     }];

// var businessDetail = [{
//     busiName:"麻辣烫",
//     sort:"吃/校园服务-位置-品类",
//     picLink:"http://seopic.699pic.com/photo/00013/6254.jpg_wh1200.jpg",
//     star:"345",
//     longitude:"23.333333",
//     latitude:"60.222222",
//     summary:"“夏天，夏天，悄悄过去留下小秘密，压心底，压心底，不能告诉你”"
// },{

//     busiName:"木桶饭",
//     sort:"吃/校园服务-位置-品类",
//     picLink:"http://seopic.699pic.com/photo/00013/6254.jpg_wh1200.jpg",
//     star:"344",
//     longitude:"23.333333",
//     latitude:"60.222222",
//     summary:"“夏天，夏天，悄悄过去留下小秘密，压心底，压心底，不能告诉你”"
// }, {
//   busiName:"粗粮面",
//   sort:"吃/校园服务-位置-品类",
//   picLink:"http://seopic.699pic.com/photo/00013/6254.jpg_wh1200.jpg",
//   star:"342",
//   longitude:"23.333333",
//   latitude:"60.222222",
//   summary:"“夏天，夏天，悄悄过去留下小秘密，压心底，压心底，不能告诉你”"
// }];
// var articleArr = [{
//     article:"“每实”爱情感动瞬间征文 | 一百三十九次吻",
//     pic:'http://seopic.699pic.com/photo/00013/6254.jpg_wh1200.jpg',
//     summary: "“夏天，夏天，悄悄过去留下小秘密，压心底，压心底，不能告诉你”",
//     link:'https://www.jianshu.com/p/d5a8130dc6c1'
//  },{
//     article:"从全职妈妈到简书签约作者，说说我的写作故事",
//     pic:'http://seopic.699pic.com/photo/00013/6254.jpg_wh1200.jpg',
//     summary: "“夏天，夏天，悄悄过去留下小秘密，压心底，压心底，不能告诉你”",
//     link:'https://www.jianshu.com/p/11046c89367d'
//  },{
//     article:"从全职妈妈到简书签约作者，说说我的写作故事",
//     pic:'http://seopic.699pic.com/photo/00013/6254.jpg_wh1200.jpg',
//     summary: "“夏天，夏天，悄悄过去留下小秘密，压心底，压心底，不能告诉你”",
//     link:'https://www.jianshu.com/p/11046c89367d'
//  },{
//     article:"从全职妈妈到简书签约作者，说说我的写作故事",
//     pic:'http://seopic.699pic.com/photo/00013/6254.jpg_wh1200.jpg',
//     summary: "“夏天，夏天，悄悄过去留下小秘密，压心底，压心底，不能告诉你”",
//     link:'https://www.jianshu.com/p/11046c89367d'
//  }];

//  var houseArr = 
// [{
//    houseName: "B楼",
//    sort: "住",
//    longitude:"34.566666", 
//    latitude:"67.878999"
// },{
//    houseName: "A楼",
//    sort: "学",
//    longitude:"34.566666", 
//    latitude:"67.878999"
// },{
//    houseName: "C楼",
//    sort: "住",
//    longitude:"34.566666", 
//    latitude:"67.878999"
// },{
//    houseName: "D楼",
//    sort: "学",
//    longitude:"34.566666", 
//    latitude:"67.878999"
// }];

// app.post('/newBusiInfo', urlencodedParser,  function(req, res){ //版本检查接口
//     res.header('Access-Control-Allow-Origin', '*');
//     businessDetail.push(req.body)
//     console.log(req.body);
// });



// app.get('/businessDetail',  function(req, res){ //版本检查接口
//     res.header('Access-Control-Allow-Origin', '*');
//     res.send(businessDetail);
    
// });

// app.get('/articleDetail',  function(req, res){ //版本检查接口
//     res.header('Access-Control-Allow-Origin', '*');
//     res.send(articleArr);
    
// });

// app.get('/houseInfo',  function(req, res){ //版本检查接口
//     res.header('Access-Control-Allow-Origin', '*');
//     res.send(houseArr);
    
// });

// app.get('/reportInfo',  function(req, res){ //版本检查接口
//     res.header('Access-Control-Allow-Origin', '*');
//     res.send(reportArr); 
// });
// app.listen(3000, function(){  //服务端口监听
//   console.log('server now listening at port 3000');
// });


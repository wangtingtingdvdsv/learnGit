// pages/home/home.js
Page({
  data: {
    parInfo:[{
      id: 'tea1',
      name:'老师一'
    },{
      id: 'tea2',
      name: '老师二'
    },{
       id: 3,
      name: '家长一'
    },{
      id: 4,
      name: '家长二'
    },{
      id: 5,
      name: '家长三'
    },{
      id: 6,
      name: '家长四'
    },{
      id: 7,
      name: '家长五'
    },{
      id: 8,
      name: '家长六'
    },{
      id: 9,
      name: '家长七'
    },{
      id: 10,
      name: '家长八'
    }, {
      id: 11,
      name: '家长九'
    }, {
      id: 12,
      name: '家长十'
    }]
  },
  //用户点击了家长或老师
  homeworkInfo: function(e) {
    console.log(e);
    wx.navigateTo({
      url: '../teacher/teacher'
    })
  }
})
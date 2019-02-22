var outJs = require('../../utils/util.js');
Page({
  data: {
    srcs:[],
    flag:'show',
    dateTimeArray1: null,
    dateTime1: null,
    dateTimeArray: [['w', 'e', 'r']],
    dateTime: 0,
    startYear: 2000,
    endYear: 2050
  },
  onLoad: function () {
    // 获取完整的年月日 时分秒，以及默认显示的数组

    var obj1 = outJs.dateTimePicker(this.data.startYear, this.data.endYear);
    //console.log(obj1);
    // 精确到分的处理，将数组的秒去掉
    var lastArray = obj1.dateTimeArray.pop(); //从数组中去掉秒
    var lastTime = obj1.dateTime.pop(); //去掉当前的秒
    //console.log(obj1.dateTimeArray);  // [Array(51), Array(12), Array(30), Array(24), Array(60)]
    //console.log(obj1.dateTime);  //[18, 5, 6, 13, 32]
    this.setData({
      dateTimeArray1: obj1.dateTimeArray,
      dateTime1: obj1.dateTime
    });
  },

  changeDateTime1(e) {
    var t = `${this.data.dateTimeArray1[0][this.data.dateTime1[0]]}-${this.data.dateTimeArray1[1][this.data.dateTime1[1]]}-${this.data.dateTimeArray1[2][this.data.dateTime1[2]]} ${this.data.dateTimeArray1[3][this.data.dateTime1[3]]}:${this.data.dateTimeArray1[4][this.data.dateTime1[4]]}`;

    this.setData({ dateTime1: e.detail.value });
    this.setData({ showTime: t });
  },

  changeDateTimeColumn1(e) {
    var arr = this.data.dateTime1, dateArr = this.data.dateTimeArray1;

    arr[e.detail.column] = e.detail.value;
    dateArr[2] = outJs.getMonthDay(dateArr[0][arr[0]], dateArr[1][arr[1]]);

    this.setData({
      dateTimeArray1: dateArr,
      dateTime1: arr
    });
  },
  onloadPic(){
    var _this = this;
    var src = _this.data.srcs;
    wx.chooseImage({
      count: 1, // 默认9
      success: function (res) {
        // 返回选定照片的本地文件路径列表，tempFilePath可以作为img标签的src属性显示图片
        for (var i = 0; i < res.tempFilePaths.length; i++) {
          src.push(res.tempFilePaths[i]);
        }
        _this.setData({
          srcs: src
        });
        if (_this.data.srcs.length === 3) {
          _this.setData({
            flag: 'hide'
          });
        }
      }
    })
   
  },
  deletePic(event) {
    var that = this;
    var id = event.target.id;
    wx.showModal({
      content: '确定删除这张图片吗？',
      success: function (res) {
        if (res.confirm) {
          that.setData({
            srcs: outJs.removeArr(that.data.srcs, id)
          });
        }
      }
    })
  },
  publisHomework(event){
    //if(有没填的) {
      //return；
    //}
    //获取内容交给服务器
    wx.showToast({
      title: '成功',
      icon: 'success',
      duration: 2000
    })
    //清空用户之前填写的内容
    //这里先把数据放到app.js中
    //页面返回到主页面
    wx.navigateTo({
      url: '../home/home'
    })
  }

})
// pages/teacher/teacher.js
Page({
  data: {
    array: ['江山幼儿园大一班', '江山幼儿园大二班'],
    index: 0
  },
  back: function(e) {
    wx.navigateTo({
      url: '../home/home'
    })
  },
  bindPickerChange: function (e) {
    this.setData({
      index: e.detail.value
    })
  },
  publishHomework: function() {
    wx.navigateTo({
      url: '../publish/publish'
    })
  }
})
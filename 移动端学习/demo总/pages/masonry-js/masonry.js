const mockData = () => {
  return Array.from(Array(50).keys()).map(item => {
    if (item < 10) {
      return '00' + item
    } else {
      return '0' + item
    }
  })

}

const createGroup = () => {
  let group = []
  let list = mockData()
  list.forEach(item => {
    group.push({ 
      name: item,
      top: '',
      left: '',
      desc: '照片',
      date:'2018/11/21'
    })
  })
  return group
}

Page({
  data: {
    width: '',
    group: createGroup(),   
    height: [],
    cols:3,
    flag: true,   //当left,和top没设置时，此时隐藏图片的显示
  },

  onLoad () {
    wx.getSystemInfo({
      success: (res) => {
        console.log(res.screenWidth);
        this.setData({
          width: (res.screenWidth/this.data.cols)
        })
      },
    })

  },
  load(e) {
    this.setData({
      height: [...this.data.height, e.detail.height]
    })
    this.showImg()
  },
  showImg() {
    let height = this.data.height
    if (height.length != this.data.group.length) {
      return
    }
    const descRects = new Promise(res => {
      wx.createSelectorQuery().selectAll('.desc').boundingClientRect(rect => {
        res(rect);
      }).exec()
    });
    const dateRects = new Promise(res => {
      wx.createSelectorQuery().selectAll('.date').boundingClientRect(rect => {
        res(rect);
      }).exec()
    })
    const imageRects = new Promise(res => {
      wx.createSelectorQuery().selectAll('.image').boundingClientRect(rect => {
        res(rect);
      }).exec()
    })
    Promise.all([imageRects, descRects, dateRects])
      .then(res => {
        console.log(res);
        const [images, descs, dates] = res;
        let cols = this.data.cols;
        var group = this.data.group
        var heightArr = [];
        for (var i = 0; i < images.length; i++) {
          const imageHeight = images[i].height;
          const descHeight = descs[i].height;
          const dateHeight = dates[i].height;
          var boxHeight = imageHeight + descHeight + dateHeight;
          if (i < cols) {
            heightArr.push(boxHeight + 20)
            group[i].top = 0
            group[i].left = 0
            group[i].left = i * this.data.width + 'px'
          } else {
            var minBoxHeight = Math.min.apply(null, heightArr);
            var minBoxIndex = getMinBoxIndex(minBoxHeight, heightArr);
            group[i].top = `${minBoxHeight}px`
            group[i].left = minBoxIndex * this.data.width + 'px'
            heightArr[minBoxIndex] += (boxHeight + 20)
          }
        }

        this.setData({
          group,
          flag: false
        })
        wx.hideLoading()
      })
  }
})

function getMinBoxIndex(val, arr) {
  for (var i in arr) {
    if (val == arr[i]) {
      return i;
    }
  }
}
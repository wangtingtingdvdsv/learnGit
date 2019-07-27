import * as pro from './action-type';



export const getProData = () => {
    let data =[{"product_id":1,"product_name":"PaiBot（2G/32G)","product_price":2999,"commission":200},{"product_id":2,"product_name":"PaiPad（2G/32G)","product_price":1999,"commission":100},{"product_id":3,"product_name":"PaiBand","product_price":299,"commission":30},{"product_id":4,"product_name":"奇妙发现","product_price":599,"commission":50},{"product_id":5,"product_name":"奇妙电路","product_price":599,"commission":50},{"product_id":6,"product_name":"七彩世界","product_price":499,"commission":40},{"product_id":7,"product_name":"七彩海洋","product_price":499,"commission":40},{"product_id":8,"product_name":"魔法数学","product_price":499,"commission":40},{"product_id":9,"product_name":"魔幻解谜","product_price":499,"commission":40},{"product_id":10,"product_name":"麦斯丝","product_price":299,"commission":20},{"product_id":11,"product_name":"hello 编程","product_price":299,"commission":20},{"product_id":12,"product_name":"涂涂世界","product_price":299,"commission":20},{"product_id":13,"product_name":"哈泥海洋","product_price":299,"commission":20},{"product_id":14,"product_name":"淘淘向右走","product_price":159,"commission":10}];
    data.map(item => {
        item.selectStatus = true;
        item.selectNum = 0;
        return item;
    })
    return {
        type: pro.GETPRODUCTION,
        dataList: data,
    }
}

//选择商品
export const togSelectPro = index => {
    return {
        type:pro.TOGGLESELECT,
        index
    }
}

//编辑商品
export const editPro = (index, selectNum) => {
    return {
        type: pro.EDITPRODUCTION,
        index,
        selectNum
    }
}

// 清空选择
export const clearSelected = () => {
    return {
      type: pro.CLEARSELECTED,
    }
  }

import React, { Component } from 'react';
import './home.less';
import Header from '@/components/header/header';
import { Link } from 'react-router-dom';
import { saveFormData, saveImg, clearData } from '@/store/home/action';
import { clearSelected } from '@/store/production/action';
import {connect} from "react-redux"
import TouchableOpacity from '@/components/TouchableOpacity/TouchableOpacity';
import PublicAlert from '@/components/alert/alert';
import { bindActionCreators } from 'redux'

class Home extends Component{
  state = {
    alertStatus: false, //弹框状态
    alertTip: '', //弹框提示文字
  }

  selectedProList = [];

  handleInput = (type, event) => {
    let value = event.target.value;
    switch(type) {
      case 'orderSum':
        value = value.replace(/\D/g, '');
        break;
      case 'name':
        break;
      case 'phoneNo':
        value = value.replace(/\D/g, '');
        break;
      default:;
    }
    this.props.actions.saveFormData(value, type)
  }
  sumitForm = () => {
    const {orderSum, name, phoneNo} = this.props.formData;
    let alertTip = '';
    if(!orderSum.toString().length){
      alertTip = '请填写金额';
    }else if(!name.toString().length){
      alertTip = '请填写姓名';
    }else if(!phoneNo.toString().length){
      alertTip = '请填写正确的手机号';
    }else{
      alertTip = '添加数据成功';
      this.props.actions.clearData();
      this.props.actions.clearSelected();
    }
    this.setState({
      alertStatus: true,
      alertTip,
    })
  }

    // 关闭弹款
    closeAlert = () => {
      this.setState({
        alertStatus: false,
        alertTip: '',
      })
    }

  render(){
   return (
      <main className="home-container"> 
        <Header title='首页' record></Header>
        <p className="common-title">请录入您的信息</p>
        <form className="home-form">
          <div className="home-form-tiem">
            <span>销售金额：</span>
            <input placeholder="请输入订单金额" value={this.props.formData.orderSum} onChange={this.handleInput.bind(this, 'orderSum')}/>
          </div>
          <div className="home-form-tiem">
            <span>客户姓名：</span>
            <input placeholder="请输入姓名" value={this.props.formData.name} onChange={this.handleInput.bind(this, 'name')}/>
          </div>
          <div className="home-form-tiem">
            <span>客户电话：</span>
            <input placeholder="请输入电话" maxLength="13"  value={this.props.formData.phoneNo} onChange={this.handleInput.bind(this, 'phoneNo')}/>
          </div>
        </form>
        <div>
          <p className="common-title"> 请选择销售的产品</p>
          <Link to='/production' className="common-select-btn">
          {
              this.selectedProList.length ? <ul className="selected-pro-list">
                {
                  this.selectedProList.map((item, index) => {
                    return <li key={index} className="selected-pro-item ellipsis">{item.product_name}x{item.selectNum}</li>
                  })
                }
              </ul>:'选择产品'
            }
          </Link>
        </div>
        <div className="upload-img-con">
          <p className="common-title"> 请上传发票凭证</p>
          <div className="file-lable">
            <span className="common-select-btn">上传图片</span>
            <input type="file" />
          </div>
          <img className='select-img' alt=""/>
        </div>
        <TouchableOpacity className="submit-btn" clickCallBack={this.sumitForm} text="提交" />
        <PublicAlert closeAlert={this.closeAlert} alertTip={this.state.alertTip} alertStatus={this.state.alertStatus} />
      </main>
   ) 
  }
}

function mapStateToProps(state) {
   return {
      formData: state.formData
   }
}
function mapDispatchToProps(dispatch){
   return {
     actions: bindActionCreators({
        saveFormData,
        saveImg,
        clearData,
        clearSelected
     }, dispatch)
   }
}
export default connect(mapStateToProps, mapDispatchToProps)(Home)

import React, { Component } from 'react';
import './production.less';
import { connect } from 'react-redux';
import PublicHeader from '@/components/header/header';
import { bindActionCreators } from 'redux'
import { getProData, togSelectPro, editPro } from '@/store/production/action';

class Production extends Component{
    state = {

    }
    handleEdit(index, num){
        let currentNum = this.props.proData.dataList[index].selectNum + num;
        if(currentNum < 0){
          return
        }
        this.props.actions.editPro(index, currentNum);
    }
    componentDidMount(){
       
        if(!this.props.proData.dataList.length) {
            this.props.actions.getProData();
        }
    }
    togSelect=index => {
        this.props.actions.togSelectPro(index)
    }
    render(){
        return (
            <main className="common-con-top">
                <PublicHeader title="首页" confirm></PublicHeader>
                <section className="pro-list-con">
                    <ul className="pro-list-ul">
                        {
                            this.props.proData.dataList.map((item, index)=> {
                                return <li className="pro-item" key={index}>
                                    <div className="pro-item-select"  onClick={this.togSelect.bind(this, index)}>
                                        <span className={`icon-xuanze1 pro-select-status ${item.selectStatus? 'pro-selected': ''}`}></span>
                                        <span className="pro-name">{item.product_name}</span>
                                    </div>
                                    <div className="pro-item-edit">
                                        <span className={`icon-jian ${item.selectNum > 0 ? 'edit-active': ''}`} onClick={this.handleEdit.bind(this, index, -1)}></span>
                                        <span className='pro-num'>{item.selectNum}</span>
                                        <span className='icon-jia' onClick={this.handleEdit.bind(this, index, +1)}></span>
                                    </div>
                                </li>
                            })
                        }
                    </ul>
                </section>
            </main>
        )
    }
}
function mapStateToProps(state){
    return {
        proData:state.proData
    }
}
function mapDispatchToProps(dispatch){
    return { 
        actions: bindActionCreators({
            getProData,
            togSelectPro,
            editPro
        }, dispatch) 
    }
}
export default connect(mapStateToProps, mapDispatchToProps)(Production)
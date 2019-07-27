
import React, { Component} from 'react';
import { NavLink } from 'react-router-dom';
import './header.less'

export default class PublicHeader extends Component{
    state = {
        navState: false
    };
    showCatalog = () => {
        this.setState({
            navState:!this.state.navState
        })
    };
    render(){
        return(
            <header className="header-container">
                <span className="header-slide-icon icon-catalog" onClick={this.showCatalog}></span>
                <span className="header-title">{this.props.title}</span>
                {
                    this.props.record && <NavLink to='/record' exact className="header-link icon-jilu"></NavLink>
                }
                {
                    this.props.confirm && <NavLink to="/" exact className="header-link header-link-confim">确定</NavLink>
                }
                {
                    this.state.navState && <aside style={{width:"40%", boxShadow: "0px 0px 0px 2px #c8c8c8"}} className="nav-slide-list" onClick={this.showCatalog}>
                        <NavLink to='helpcenter' exact className="nav-link icon-jiantou-copy-copy">登录退出</NavLink>
                        <NavLink to='/myInfo' exact className="nav-link icon-jiantou-copy-copy">个人信息</NavLink>
                        <NavLink to='/' exact className="nav-link icon-jiantou-copy-copy">商品出售</NavLink>
                        <NavLink to='helpcenter' exact className="nav-link icon-jiantou-copy-copy">商品展示</NavLink>
                        <NavLink to='helpcenter' exact className="nav-link icon-jiantou-copy-copy">帮助中心</NavLink>
                        <NavLink to='helpcenter' exact className="nav-link icon-jiantou-copy-copy">校园趣事</NavLink>
                    </aside>
                }
            </header>
        )
    }
}
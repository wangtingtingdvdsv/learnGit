
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
                <span className="header-title">首页</span>
                <span className="header-link icon-jilu"></span>
                {
                    this.state.navState && <aside style={{width: '40%'}} className="nav-slide-list" onClick={this.showCatalog}>
                        <NavLink to='/' exact className="nav-link icon-jiantou-copy-copy">首页</NavLink>
                        <NavLink to='/balance' exact className="nav-link icon-jiantou-copy-copy">提现</NavLink>
                        <NavLink to='helpcenter' exact className="nav-link icon-jiantou-copy-copy">帮助中心</NavLink>
                    </aside>
                }
            </header>
        )
    }
}

import React, { Component} from 'react';
import { NavLink } from 'react-router-dom';
import './header.less'

export default class PublicHeader extends Component{
    
    render(){
        return(
        
            <header className="header-container">
                <span className="header-link icon-jilu">目录</span>
                <span></span>
                <span></span>
                <NavLink to=''></NavLink>
            </header>
        )
    }
}
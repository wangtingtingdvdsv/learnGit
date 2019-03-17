
import { Component, React} from 'react';
import { NavLink } from 'react-router-dom';
import './header.less'

export default class PublicHeader extends Component{
    
    render(){
        return(
            <header>
                <span></span>
                <span></span>
                <span></span>
                <NavLink></NavLink>
                <NavLink></NavLink>
                <Navlink></Navlink>
            </header>
        )
    }
}
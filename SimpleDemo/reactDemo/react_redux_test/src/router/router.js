import React,{ Component} from 'react'
import {HashRouter, Switch, Route, Redirect} from 'react-router-dom';

import Header from '../components/header/header';
export default class RouteConfig extends Component {
    render() {
        return(
            <HashRouter>
                <Switch>
                    <Route path='/' component={Header}></Route>
                    <Redirect to='/'></Redirect>
                </Switch>
            </HashRouter>
        )
    }
}
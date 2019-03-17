import { React, Component } from 'react';
import { HashRouter, Switch, Route, Redirect } from 'react-router-dom';
import header from '@/component/header/header';

export default class RouteConfig extends Component{
    render(){
        return(
            <HashRouter>
                <Switch>
                    <Route path='/header' component={header}></Route>
                    <Route></Route>
                    <Route></Route>
                    <Route></Route>
                    <Route></Route>
                </Switch>
            </HashRouter>
        )
    }
}
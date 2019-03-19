import React,{ Component} from 'react'
import {HashRouter, Switch, Route, Redirect} from 'react-router-dom';


import helpcenter from '@/pages/helpcenter/helpcenter';
import balance from '@/pages/balance/balance';
import home from "@/pages/home/home";

export default class RouteConfig extends Component {
    render() {
        return(
            <HashRouter>
                <Switch>
                    <Route path='/' exact component={home}></Route>
                    <Route path='/helpcenter' component={helpcenter}></Route>
                    <Route path='/balance' component={balance}></Route>
                    <Redirect to='/' ></Redirect>
                </Switch>
            </HashRouter>
        )
    }
}
import React,{ Component} from 'react'
import {HashRouter, Switch, Route, Redirect} from 'react-router-dom';
import asyncComponent from '@/utils/asyncComponent';

import helpcenter from '@/pages/helpcenter/helpcenter';
import myInfo from '@/pages/myInfo/myInfo';
import Home from "@/pages/home/home";
const production = asyncComponent(() => import('@/pages/production/production'))

export default class RouteConfig extends Component {
    render() {
        return(
            <HashRouter>
                <Switch>
                    <Route path='/' exact component={Home}></Route>
                    <Route path='/helpcenter' component={helpcenter}></Route>
                    <Route path='/myInfo' component={myInfo}></Route>
                    <Route path='/production' component={production}></Route>
                    <Redirect to='/' ></Redirect>
                </Switch>
            </HashRouter>
        )
    }
}
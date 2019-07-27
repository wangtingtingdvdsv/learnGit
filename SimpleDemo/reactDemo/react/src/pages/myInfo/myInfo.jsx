import React, { Component } from 'react';
import Header from '@/components/header/header';

export default class myInfo extends Component{
    render(){
        return (
            <main className="home-container">
                <Header title='提现' record></Header>
                <div>个人信息</div>
            </main>
        )
    }
}
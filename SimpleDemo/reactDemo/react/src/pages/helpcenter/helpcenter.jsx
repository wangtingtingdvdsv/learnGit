import React, { Component } from 'react';
import Header from '@/components/header/header';

export default class helpCenter extends Component{
    render(){
        return (
            <main className="home-container">
                <Header title='帮助中心' record></Header>
                <div>
                    这是一个二手商品买卖平台
                </div>
            </main>
        )
    }
}
import React, { Component } from 'react';
import Header from '@/components/header/header';

export default class Balance extends Component{
    render(){
        return (
            <main className="home-container">
                <Header></Header>
                <div>提现</div>
            </main>
        )
    }
}
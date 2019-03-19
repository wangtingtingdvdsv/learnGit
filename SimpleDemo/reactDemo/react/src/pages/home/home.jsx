
import React, { Component } from 'react';
import './home.less';
import Header from '@/components/header/header';

export default class Home extends Component{
  render(){
   return (
      <main className="home-container"> 
        <Header></Header>
        <div>首页</div>
      </main>
   ) 
  }
}

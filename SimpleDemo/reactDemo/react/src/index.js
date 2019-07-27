import React from 'react';
import ReactDOM from 'react-dom';
import Route from './router/router';
import { Provider } from 'react-redux'
import { AppContainer } from 'react-hot-loader';
import store from '@/store/store'

import './utils/setRem';
import './style/base.css';

ReactDOM.render(
    <Provider store={store}>
    <AppContainer>
        <Route />
    </AppContainer>
    </Provider>,
    document.getElementById('root'),)

if (module.hot) {
    // 实现热更新
    module.hot.accept();
}




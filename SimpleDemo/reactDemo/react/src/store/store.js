import { createStore, combineReducers, applyMiddleware, compose} from 'redux'
import * as home from './home/reducer';
import * as production from './production/reducer'
import thunk from 'redux-thunk';

let store = createStore(
    combineReducers({...home, ...production}),
    compose(applyMiddleware(thunk), window.devToolsExtension ? window.devToolsExtension() : f => f)
)

export default store;

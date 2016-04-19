import {browserHistory} from 'react-router';
import {createStore, applyMiddleware} from 'redux';
// Middlware related
import createLogger from 'redux-logger';
import thunkMiddleware from 'redux-thunk';
import {routerMiddleware} from 'react-router-redux';
// Reducers
import reducers from '../reducers';

const loggerMiddleware = createLogger({
  level: 'info',
  collapsed: true
});

const middlewares = applyMiddleware(
  thunkMiddleware, loggerMiddleware, routerMiddleware(browserHistory)
);

let store = createStore(
  reducers,
  middlewares
);

export default store;

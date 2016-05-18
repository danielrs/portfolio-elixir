import {combineReducers} from 'redux';
import {routerReducer} from 'react-router-redux';
import sessionReducer from './session';
import projectReducer from './project';

const reducers = combineReducers({
  routing: routerReducer,
  session: sessionReducer,

  project: projectReducer
});

export default reducers;

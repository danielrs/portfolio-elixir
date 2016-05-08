import {combineReducers} from 'redux';
import {routerReducer} from 'react-router-redux';
import sessionReducer from './session';
import projectReducer from './project';
import postReducer from './post';

const reducers = combineReducers({
  routing: routerReducer,
  session: sessionReducer,
  project: projectReducer,
  post: postReducer
});

export default reducers;

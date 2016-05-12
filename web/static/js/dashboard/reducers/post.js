import Constants from '../constants';
import {zipIndex} from '../utils';

const initialState = {
  posts: [],
  loaded: false,
  focused: {},
  deleted: {},
  errors: []
}

export default function postReducer(state = initialState, action) {
  switch (action.type) {
    case Constants.POSTS_FETCHING:
      return {...state, loaded: false};
    case Constants.POSTS_RECEIVED:
      return {...state, posts: zipIndex(action.posts), loaded: true};
    case Constants.POSTS_POST_FETCHING:
      return {...state, loaded: false};
    case Constants.POSTS_POST_RECEIVED:
      return {...state, focused: action.post, loaded: true};
    case Constants.POSTS_POST_DELETED:
      return {...state, deleted: action.post};
    case Constants.POSTS_POST_UNDO:
      return {...state, deleted: {}};
    case Constants.POSTS_POST_ERROR:
      return {...state, errors: action.errors};
    case Constants.POSTS_POST_FORM_RESET:
      return {...state, errors: []};
    default:
      return state;
  }
}

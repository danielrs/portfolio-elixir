import Constants from '../constants';

const initialState = {
  posts: [],

  filter: {
    sort_by: 'date',
    order: 'desc',
    search: ''
  },

  loaded: false,
  submiting: false,

  current: {
    post: {},
    loaded: false
  },

  deleted: {},
  errors: {}
}

export default function postReducer(state = initialState, action) {
  switch (action.type) {
    case Constants.POSTS_FETCHING:
      return {...state, loaded: false};
    case Constants.POSTS_RECEIVED:
      return {...state, posts: action.posts, loaded: true};
    case Constants.POSTS_SUBMITING:
      return {...state, submiting: true};
    case Constants.POSTS_NEW:
      return {...state, posts: state.posts.concat(action.post), submiting: false};
    case Constants.POSTS_DELETE:
      return {...state, deleted: action.post};
    case Constants.POSTS_DELETE_RESET:
      return {...state, deleted: initialState.deleted};
    case Constants.POSTS_FILTER:
      return {...state, filter: action.filter};

    case Constants.CURRENT_POST_FETCHING:
      return {...state, current: {post: initialState.current.post, loaded: false}};
    case Constants.CURRENT_POST_RECEIVED:
      return {...state, current: {post: action.post, loaded: true}};
    case Constants.CURRENT_POST_UPDATED:
      return {...state, submiting: false, current: {post: action.post, loaded: true}};

    case Constants.POSTS_ERROR:
      return {...state, errors: action.errors, submiting: false};
    case Constants.POSTS_ERROR_RESET:
      return {...state, errors: initialState.errors};

    default:
      return state;
  }
}

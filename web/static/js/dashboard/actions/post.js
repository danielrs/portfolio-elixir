import Constants from '../constants';
import Request from '../utils/http-request';
import {replace} from 'react-router-redux';
import moment from 'moment';

const PostActions = {
  fetchPosts: function() {
    return dispatch => {
      dispatch({type: Constants.POSTS_FETCHING});
      setTimeout(() => {
        Request.get('/api/v1/posts')
        .then(function(response) {
          dispatch({type: Constants.POSTS_RECEIVED, posts: response.data});
        })
        .catch(function(error) {});
      }, 1000);
    };
  },

  newPost: function(data) {
    return dispatch => {
      Request.post('/api/v1/posts', data)
      .then(response => {
        dispatch(this.fetchPosts());
        dispatch(replace('/dashboard/posts'));
      })
      .catch(error => {
        error.response.json()
        .then(function(errorJSON) {
          dispatch({
            type: Constants.POSTS_POST_ERROR,
            errors: errorJSON.errors
          });
        });
      });
    };
  },

  fetchPost: function(id) {
    return dispatch => {
      dispatch({type: Constants.POSTS_POST_FETCHING});
      Request.get(`/api/v1/posts/${id}`)
      .then(function(response) {
        dispatch({
          type: Constants.POSTS_POST_RECEIVED,
          post: {...response.data, date: moment(response.data.date)}
        });
      })
      .catch(function(error) {});
    };
  },

  editPost: function(id, data) {
    return dispatch => {
      Request.patch(`/api/v1/posts/${id}`, data)
      .then(response => {
        dispatch(this.fetchPosts());
        dispatch({
          type: Constants.POSTS_POST_RECEIVED,
          post: {...response.data, date: moment(response.data.date)}
        });
      })
      .catch(error => {
        error.response.json()
        .then(errorJSON => {
          dispatch({
            type: Constants.POSTS_POST_ERROR,
            errors: errorJSON.errors
          });
        });
      });
    };
  },

  deletePost: function(id, data) {
    return dispatch => {
      Request.delete(`/api/v1/posts/${id}`)
      .then(response => {
        dispatch({
          type: Constants.POSTS_POST_DELETED,
          post: data
        });
        dispatch(this.fetchPosts());
      })
      .catch(error => {
        console.log(error);
      });
    };
  },

  undoDelete: function(data) {
    return dispatch => {
      dispatch(this.newPost({post: data}));
      dispatch({type: Constants.POSTS_POST_UNDO});
    };
  },

  formReset: function() {
    return dispatch => {
      dispatch({type: Constants.POSTS_POST_FORM_RESET});
    };
  }
};

export default PostActions;

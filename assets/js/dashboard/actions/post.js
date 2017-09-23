import Constants from '../constants';
import Request from '../utils/http-request';
import {push} from 'react-router-redux';

const PostActions = {
  fetchPosts: function() {
    return (dispatch, getState) => {
      const {user} = getState().session;
      dispatch({type: Constants.POSTS_FETCHING});
      Request.get(`/api/v1/users/${user.id}/posts`, getState().post.filter)
      .then(function(response) {
        dispatch({type: Constants.POSTS_RECEIVED, posts: response.data});
      })
      .catch(function(error) {
        console.log(error);
      });
    };
  },

  newPost: function() {
    return dispatch => {
      dispatch(push(`/dashboard/posts/new`));
    };
  },

  createPost: function(data) {
    return (dispatch, getState) => {
      const {user} = getState().session;
      dispatch({type: Constants.POSTS_SUBMITING});
      Request.post(`/api/v1/users/${user.id}/posts`, data)
      .then(response => {
        dispatch({
          type: Constants.POSTS_NEW,
          post: response.data
        });
        dispatch(this.fetchPosts());
        dispatch(push(`/dashboard/posts`));
      })
      .catch(error => {
        error.response.json()
        .then(function(errorJSON) {
          dispatch({
            type: Constants.POSTS_ERROR,
            errors: errorJSON.errors
          });
        });
      });
    };
  },

  deletePost: function(id, data) {
    return (dispatch, getState) => {
      const {user} = getState
      Request.delete(`/api/v1/users/${user.id}/posts/${id}`)
      .then(response => {
        dispatch({
          type: Constants.POSTS_DELETE,
          post: data
        });
        dispatch(this.fetchPosts());
      })
    };
  },

  filterPosts: function(filter) {
    return dispatch => {
      dispatch({type: Constants.POSTS_FILTER, filter: filter});
      dispatch(this.fetchPosts());
    };
  },

  fetchPost: function(id) {
    return (dispatch, getState) => {
      const {user} = getState().session;
      dispatch({type: Constants.CURRENT_POST_FETCHING});
      Request.get(`/api/v1/users/${user.id}/posts/${id}`)
      .then(function(response) {
        dispatch({
          type: Constants.CURRENT_POST_RECEIVED,
          post: response.data
        });
      })
      .catch(function(error) {});
    };
  },

  showPost: function(id) {
    return dispatch => {
      dispatch(push(`/dashboard/posts/${id}`));
    };
  },

  editPost: function(id) {
    return dispatch => {
      dispatch(this.errorReset());
      dispatch(push(`/dashboard/posts/${id}/edit`));
    };
  },

  updatePost: function(id, data) {
    return (dispatch, getState) => {
      const {user} = getState().session;
      dispatch({type: Constants.POSTS_SUBMITING});
      Request.patch(`/api/v1/users/${user.id}/posts/${id}`, data)
      .then(response => {
        dispatch({
          type: Constants.CURRENT_POST_UPDATED,
          post: response.data
        });
        dispatch(this.fetchPosts());
        dispatch(push(`/dashboard/posts/${id}`));
      })
      .catch(error => {
        error.response.json()
        .then(errorJSON => {
          dispatch({
            type: Constants.POSTS_ERROR,
            errors: errorJSON.errors
          });
        });
      });
    };
  },

  errorReset: function() {
    return dispatch => {
      dispatch({type: Constants.POSTS_ERROR_RESET});
    };
  }
};

export default PostActions;

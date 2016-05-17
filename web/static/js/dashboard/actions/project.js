import Constants from '../constants';
import Request from '../utils/http-request';
import {push} from 'react-router-redux';

const ProjecActions = {
  fetchProjects: function() {
    return dispatch => {
      dispatch({type: Constants.PROJECTS_FETCHING});
      setTimeout(() => {
        Request.get('/api/v1/projects')
        .then(function(response) {
          dispatch({type: Constants.PROJECTS_RECEIVED, projects: response.data});
        })
        .catch(function(error) {});
      }, 0);
    };
  },

  fetchProject: function(id) {
    return dispatch => {
      dispatch({type: Constants.PROJECTS_PROJECT_FETCHING});
      Request.get(`/api/v1/projects/${id}`)
      .then(function(response) {
        dispatch({
          type: Constants.PROJECTS_PROJECT_RECEIVED,
          project: response.data
        });
      })
      .catch(function(error) {});
    };
  },

  newProject: function(data) {
    return dispatch => {
      Request.post('/api/v1/projects', data)
      .then(response => {
        dispatch({
          type: Constants.PROJECTS_PROJECT_NEW,
          project: response.data
        });
        dispatch(this.fetchProjects());
        dispatch(push(`/dashboard/projects/${response.data.id}`));
      })
      .catch(error => {
        error.response.json()
        .then(function(errorJSON) {
          dispatch({
            type: Constants.PROJECTS_PROJECT_ERROR,
            errors: errorJSON.errors
          });
        });
      });
    };
  },

  editProject: function(id, data) {
    return dispatch => {
      Request.patch(`/api/v1/projects/${id}`, data)
      .then(response => {
        dispatch(this.fetchProjects());
        dispatch({
          type: Constants.PROJECTS_PROJECT_RECEIVED,
          project: response.data
        });
        dispatch({
          type: Constants.PROJECTS_PROJECT_ERROR_RESET
        });
        dispatch(push(`/dashboard/projects/${id}`));
      })
      .catch(error => {
        error.response.json()
        .then(errorJSON => {
          dispatch({
            type: Constants.PROJECTS_PROJECT_ERROR,
            errors: errorJSON.errors
          });
        });
      });
    };
  },

  deleteProject: function(id, data) {
    return dispatch => {
      Request.delete(`/api/v1/projects/${id}`)
      .then(response => {
        dispatch({
          type: Constants.PROJECTS_PROJECT_DELETED,
          project: data
        });
        // dispatch(this.fetchProjects());
      })
      .catch(error => {
        console.log(error);
      });
    };
  },

  errorReset: function() {
    return dispatch => {
      dispatch({type: Constants.PROJECTS_PROJECT_ERROR_RESET});
    };
  }
};

export default ProjecActions;

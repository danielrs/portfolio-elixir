import Constants from '../constants';
import Request from '../utils/http-request';
import {push} from 'react-router-redux';

const ProjecActions = {
  fetchProjects: function() {
    return (dispatch, getState) => {
      dispatch({type: Constants.PROJECTS_FETCHING});
      Request.get('/api/v1/projects', getState().project.filter)
      .then(function(response) {
        dispatch({type: Constants.PROJECTS_RECEIVED, projects: response.data});
      })
      .catch(function(error) {
        console.log(error);
      });
    };
  },

  newProject: function() {
    return dispatch => {
      dispatch(push('/dashboard/projects/new'));
    };
  },

  createProject: function(data) {
    return dispatch => {
      dispatch({type: Constants.PROJECTS_SUBMITING});
      Request.post('/api/v1/projects', data)
      .then(response => {
        dispatch({
          type: Constants.PROJECTS_NEW,
          project: response.data
        });
        dispatch(this.fetchProjects());
        dispatch(push('/dashboard/projects'));
      })
      .catch(error => {
        error.response.json()
        .then(function(errorJSON) {
          dispatch({
            type: Constants.PROJECTS_ERROR,
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
          type: Constants.PROJECTS_DELETE,
          project: data
        });
        dispatch(this.fetchProjects());
      })
      .catch(error => {
        console.log(error);
      });
    };
  },

  undoDelete: function(data) {
    return dispatch => {
      dispatch({type: Constants.PROJECTS_DELETE_RESET});
      dispatch(this.createProject(data));
    };
  },

  undoReset: function() {
    return dispatch => {
      dispatch({type: Constants.PROJECTS_DELETE_RESET});
    };
  },

  filterProjects: function(filter) {
    return dispatch => {
      dispatch({type: Constants.PROJECTS_FILTER, filter: filter});
      dispatch(this.fetchProjects());
    };
  },

  fetchProject: function(id) {
    return dispatch => {
      dispatch({type: Constants.CURRENT_PROJECT_FETCHING});
      Request.get(`/api/v1/projects/${id}`)
      .then(function(response) {
        dispatch({
          type: Constants.CURRENT_PROJECT_RECEIVED,
          project: response.data
        });
      })
      .catch(function(error) {});
    };
  },

  showProject: function(id) {
    return dispatch => {
      dispatch(push(`/dashboard/projects/${id}`));
    };
  },

  editProject: function(id) {
    return dispatch => {
      dispatch(this.errorReset());
      dispatch(push(`/dashboard/projects/${id}/edit`));
    };
  },

  updateProject: function(id, data) {
    return dispatch => {
      dispatch({type: Constants.PROJECTS_SUBMITING});
      Request.patch(`/api/v1/projects/${id}`, data)
      .then(response => {
        dispatch({
          type: Constants.CURRENT_PROJECT_UPDATED,
          project: response.data
        });
        dispatch(this.fetchProjects());
        dispatch(push(`/dashboard/projects/${id}`));
      })
      .catch(error => {
        error.response.json()
        .then(errorJSON => {
          dispatch({
            type: Constants.PROJECTS_ERROR,
            errors: errorJSON.errors
          });
        });
      });
    };
  },

  errorReset: function() {
    return dispatch => {
      dispatch({type: Constants.PROJECTS_ERROR_RESET});
    };
  }
};

export default ProjecActions;

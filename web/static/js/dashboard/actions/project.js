import Constants from '../constants';
import Request from '../utils/http-request';
import {replace} from 'react-router-redux';
import moment from 'moment';

const ProjecActions = {
  fetchProjects: function() {
    return dispatch => {
      dispatch({type: Constants.PROJECTS_FETCHING});
      Request.get('/api/v1/projects')
      .then(function(response) {
        dispatch({type: Constants.PROJECTS_RECEIVED, projects: response.data});
      })
      .catch(function(error) {});
    };
  },

  newProject: function(data) {
    return dispatch => {
      Request.post('/api/v1/projects', data)
      .then(response => {
        dispatch(this.fetchProjects());
        dispatch(replace('/dashboard/projects'));
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

  fetchProject: function(id) {
    return dispatch => {
      dispatch({type: Constants.PROJECTS_PROJECT_FETCHING});
      Request.get(`/api/v1/projects/${id}`)
      .then(function(response) {
        dispatch({
          type: Constants.PROJECTS_PROJECT_RECEIVED,
          project: {...response.data, date: moment(response.data.date)}
        });
      })
      .catch(function(error) {});
    };
  },

  editProject: function(id, data) {
    return dispatch => {
      Request.patch(`/api/v1/projects/${id}`, data)
      .then(response => {
        dispatch(this.fetchProjects());
        dispatch({
          type: Constants.PROJECTS_PROJECT_RECEIVED,
          project: {...response.data, date: moment(response.data.date)}
        });
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

  deleteProject: function(id) {
    return dispatch => {
      Request.delete(`/api/v1/projects/${id}`)
      .then(response => {
        dispatch(this.fetchProjects());
      })
      .catch(error => {
        console.log(error);
      });
    };
  },

  formReset: function() {
    return dispatch => {
      dispatch({type: Constants.PROJECTS_PROJECT_FORM_RESET});
    };
  }
};

export default ProjecActions;

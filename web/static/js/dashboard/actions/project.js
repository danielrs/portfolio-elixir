import Constants from '../constants';
import Request from '../utils/http-request';


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
  }
};

export default ProjecActions;

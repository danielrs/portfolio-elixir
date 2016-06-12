import {push} from 'react-router-redux';
import Constants from '../constants';
import Request from '../utils/http-request';

const SessionActions = {
  signIn: function(email, password) {
    return dispatch => {
      Request.post('/api/v1/session', {session: {email: email, password: password}})
      .then(response => {
        localStorage.setItem('auth-token', response.data.jwt);
        dispatch({type: Constants.USER_SIGNED_IN, user: response.data.user});
        dispatch(push('/dashboard'));
      })
      .catch(error => {
        error.response.json()
        .then(errorJSON => {
          dispatch({
            type: Constants.USER_ERROR,
            error: errorJSON.error
          });
        });
      });
    };
  },

  signOut: function() {
    return dispatch => {
      localStorage.removeItem('auth-token');
      dispatch({type: Constants.USER_SIGNED_OUT});
      dispatch(push('/dashboard/sign_in'));
    };
  },

  currentUser: function(callback) {
    return dispatch => {
      Request.get('/api/v1/session')
      .then(response => {
        dispatch({type: Constants.USER_CURRENT_USER, user: response.data.user});
        callback();
      })
      .catch(error => {
        dispatch(this.signOut());
        callback();
      });
    };
  }
};

export default SessionActions;

import Constants from '../constants';

const initialState = {
  user: null,
  error: null
}

export default function sessionReducer(state = initialState, action) {
  switch (action.type) {
    case Constants.USER_SIGNED_IN:
      return {...state, user: action.user};
    case Constants.USER_SIGNED_OUT:
      return initialState;
    case Constants.USER_CURRENT_USER:
      return {...state, user: action.user};
    case Constants.USER_ERROR:
      return {...state, error: action.error};
    default:
      return state;
  }
}

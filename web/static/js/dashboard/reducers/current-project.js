import Constants from '../constants';

const initialState = {
  project: {},
  loaded: false
}

export default function currentProjectReducer(state = initialState, action) {
  switch (action.type) {
    case Constants.CURRENT_PROJECT_FETCHING:
      return {...state, project: {}, loaded: false};
    case Constants.CURRENT_PROJECT_RECEIVED:
      return {...state, project: action.project, loaded: true};
    case Constants.CURRENT_PROJECT_EDIT:
      return state;
    case Constants.CURRENT_PROJECT_UPDATE:
      return {...state, project: action.project, loaded: true};
    default:
      return state;
  }
}

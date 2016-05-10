import Constants from '../constants';

const initialState = {
  projects: [],
  fetching: false,
  focused: {},
  deleted: {},
  errors: []
}

export default function projectReducer(state = initialState, action) {
  switch (action.type) {
    case Constants.PROJECTS_FETCHING:
      return {...state, fetching: true};
    case Constants.PROJECTS_RECEIVED:
      return {...state, projects: action.projects, fetching: false};
    case Constants.PROJECTS_PROJECT_FETCHING:
      return {...state, fetching: true};
    case Constants.PROJECTS_PROJECT_RECEIVED:
      return {...state, focused: action.project, fetching: false};
    case Constants.PROJECTS_PROJECT_DELETED:
      return {...state, deleted: action.project};
    case Constants.PROJECTS_PROJECT_UNDO:
      return {...state, deleted: {}};
    case Constants.PROJECTS_PROJECT_ERROR:
      return {...state, errors: action.errors};
    case Constants.PROJECTS_PROJECT_FORM_RESET:
      return {...state, errors: []};
    default:
      return state;
  }
}

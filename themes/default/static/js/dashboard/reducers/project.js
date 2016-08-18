import Constants from '../constants';

const initialState = {
  projects: [],

  filter: {
    sort_by: 'date',
    order: 'desc',
    search: ''
  },

  loaded: false,
  submiting: false,

  current: {
    project: {},
    loaded: false
  },

  deleted: {},
  errors: {}
}

export default function projectReducer(state = initialState, action) {
  switch (action.type) {
    case Constants.PROJECTS_FETCHING:
      return {...state, loaded: false};
    case Constants.PROJECTS_RECEIVED:
      return {...state, projects: action.projects, loaded: true};
    case Constants.PROJECTS_SUBMITING:
      return {...state, submiting: true};
    case Constants.PROJECTS_NEW:
      return {...state, projects: state.projects.concat(action.project), submiting: false};
    case Constants.PROJECTS_DELETE:
      return {...state, deleted: action.project};
    case Constants.PROJECTS_DELETE_RESET:
      return {...state, deleted: initialState.deleted};
    case Constants.PROJECTS_FILTER:
      return {...state, filter: action.filter};

    case Constants.CURRENT_PROJECT_FETCHING:
      return {...state, current: {project: initialState.current.project, loaded: false}};
    case Constants.CURRENT_PROJECT_RECEIVED:
      return {...state, current: {project: action.project, loaded: true}};
    case Constants.CURRENT_PROJECT_UPDATED:
      return {...state, submiting: false, current: {project: action.project, loaded: true}};

    case Constants.PROJECTS_ERROR:
      return {...state, errors: action.errors, submiting: false};
    case Constants.PROJECTS_ERROR_RESET:
      return {...state, errors: initialState.errors};

    default:
      return state;
  }
}

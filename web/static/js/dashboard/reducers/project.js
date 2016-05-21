import Constants from '../constants';

const initialState = {
  projects: [],
  loaded: false,
  submiting: false,

  current: {
    project: {},
    loaded: false
  },

  deleted: {},
  errors: {}
}

function addProject(projects, project) {
  return projects.concat(project).sort((a, b) => {
    return a.date > b.date;
  });
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
      return {...state, projects: addProject(state.projects, action.project), submiting: false};
    case Constants.PROJECTS_DELETE:
      return {...state, deleted: action.project};
    case Constants.PROJECTS_UNDO:
      return {...state, deleted: initialState.deleted};
    case Constants.PROJECTS_UNDO_RESET:
      return {...state, deleted: {}};

    case Constants.PROJECTS_ERROR:
      return {...state, errors: action.errors, submiting: false};
    case Constants.PROJECTS_ERROR_RESET:
      return {...state, errors: initialState.errors};

    case Constants.CURRENT_PROJECT_FETCHING:
      return {...state, current: {project: initialState.current.project, loaded: false}};
    case Constants.CURRENT_PROJECT_RECEIVED:
      return {...state, current: {project: action.project, loaded: true}};
    case Constants.CURRENT_PROJECT_EDIT:
      return state;
    case Constants.CURRENT_PROJECT_UPDATE:
      return {...state, submiting: false, current: {project: action.project, loaded: true}};

    default:
      return state;
  }
}

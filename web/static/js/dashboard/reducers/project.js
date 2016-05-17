import Constants from '../constants';
import {zipIndex} from '../utils';

const initialState = {
  projects: [],
  loaded: false,
  focused: {},
  deleted: {},
  errors: {}
}

function addProject(projects, project) {
  const sorted = projects.concat(project).sort((a, b) => {
    return a.date > b.date;
  });
  return zipIndex(sorted);
}
export default function projectReducer(state = initialState, action) {
  switch (action.type) {
    case Constants.PROJECTS_FETCHING:
      return {...state, loaded: false};
    case Constants.PROJECTS_RECEIVED:
      return {...state, projects: zipIndex(action.projects), loaded: true};
    case Constants.PROJECTS_PROJECT_FETCHING:
      return {...state, loaded: false};
    case Constants.PROJECTS_PROJECT_RECEIVED:
      return {...state, focused: action.project, loaded: true};
    case Constants.PROJECTS_PROJECT_NEW:
      return {...state, projects: addProject(state.projects, action.project), focused: action.project};
    case Constants.PROJECTS_PROJECT_DELETED:
      return {...state, projects: state.projects.filter(x => x.id != action.project.id), deleted: action.project};
    case Constants.PROJECTS_PROJECT_UNDO:
      return {...state, deleted: {}};
    case Constants.PROJECTS_PROJECT_ERROR:
      return {...state, errors: action.errors};
    case Constants.PROJECTS_PROJECT_ERROR_RESET:
      return {...state, errors: {}};
    default:
      return state;
  }
}

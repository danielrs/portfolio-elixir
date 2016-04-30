import Enum from '../utils/enum';

const Constants = new Enum([
  'USER_SIGNED_IN',
  'USER_SIGNED_OUT',
  'USER_CURRENT_USER',
  'USER_ERROR',

  'PROJECTS_FETCHING',
  'PROJECTS_RECEIVED',
  'PROJECTS_PROJECT_FETCHING',
  'PROJECTS_PROJECT_RECEIVED',
  'PROJECTS_PROJECT_DELETED',
  'PROJECTS_PROJECT_UNDO',
  'PROJECTS_PROJECT_ERROR',
  'PROJECTS_PROJECT_FORM_RESET'
]);

export default Constants;

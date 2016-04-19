import Enum from '../utils/enum';

const Constants = new Enum([
  'USER_SIGNED_IN',
  'USER_SIGNED_OUT',
  'USER_CURRENT_USER',
  'USER_ERROR',

  'PROJECTS_FETCHING',
  'PROJECTS_RECEIVED',
  'PROJECTS_PROJECT_FETCHING',
  'PROJECTS_PROJECT_RECEIVED'
]);

export default Constants;

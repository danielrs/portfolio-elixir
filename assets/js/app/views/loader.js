import HomeIndexView from './home';
import ContactIndexView from './contact';
import MainView from './main';

// Collection of specific views.
const views = {
  HomeIndexView,
  ContactIndexView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}

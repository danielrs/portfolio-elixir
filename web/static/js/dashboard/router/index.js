import React from 'react';
import {Router, Route, IndexRoute, Link, browserHistory} from 'react-router';
import {syncHistoryWithStore, push} from 'react-router-redux';
import store from '../store';
import Actions from '../actions/session';

// Layouts
import MainLayoutView from '../views/layout/main';

// Views
import SessionNewView from '../views/session/new';
import HomeIndexView from '../views/home/index';

import ProjectIndexView from '../views/project/index';
import ProjectNewView from '../views/project/new';
import ProjectShowView from '../views/project/show';
import ProjectEditView from '../views/project/edit';

export default function router(store) {
  const history = syncHistoryWithStore(browserHistory, store);

  const ensureAuthenticated = (nextState, replace, callback) => {
    const {dispatch} = store;
    const {session} = store.getState();
    if (!session.user && localStorage.getItem('auth-token')) {
      dispatch(Actions.currentUser());
    }
    else if (!localStorage.getItem('auth-token')) {
      replace('/dashboard/sign_in');
    }
    callback();
  }

  return (
    <Router history={history}>
      <Route path="/dashboard" component={MainLayoutView}>
        <Route path="sign_in" component={SessionNewView} />
        <Route onEnter={ensureAuthenticated}>
          <IndexRoute component={HomeIndexView} />
          <Route path="projects" component={ProjectIndexView} >
            <Route path="new" component={ProjectNewView} />
            <Route path=":id" component={ProjectShowView} />
            <Route path=":id/edit" component={ProjectEditView} />
          </Route>
        </Route>
      </Route>
    </Router>
  );
}

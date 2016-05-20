import React from 'react';
import {Router, Route, IndexRoute, Link, browserHistory} from 'react-router';
import {syncHistoryWithStore, push} from 'react-router-redux';
import store from '../store';
import Actions from '../actions/session';

// Layouts
import SessionLayoutView from '../views/layout/session';
import MainLayoutView from '../views/layout/main';

// Views
import SessionNewView from '../views/session/new';
import HomeIndexView from '../views/home/index';

import ProjectIndexView from '../views/project/index';
import ProjectNewView from '../views/project/new';
import ProjectShowView from '../views/project/show';

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
      <Route component={SessionLayoutView}>
        <Route path="/dashboard/sign_in" component={SessionNewView} />
      </Route>
      <Route path="/dashboard" component={MainLayoutView} onEnter={ensureAuthenticated}>
        <IndexRoute component={HomeIndexView} />
        <Route path="projects" component={ProjectIndexView}>
          <Route path="new" component={ProjectNewView} />
          <Route path=":id" component={ProjectShowView}>
            <Route path="edit" component={_ => (<noscript />)} />
          </Route>
        </Route>
      </Route>
    </Router>
  );
}

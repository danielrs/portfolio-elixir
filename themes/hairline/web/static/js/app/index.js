// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "process"
import "phoenix"
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

// var _ = require('lodash');

import MainView from './views/main';
import loadView from './views/loader';

function handleDOMContentLoaded() {
  // Get view name for this page.
  const viewName = document.getElementsByTagName('body')[0].getAttribute('data-js-view-name');

  // Load class for the view.
  const ViewClass = loadView(viewName);
  const view = new ViewClass();
  view.mount();

  window.currentView = view;
}

function handleUnload() {
  window.currentView.umount();
  window.currentView = null;
}

// window.addEventListener('DOMContentLoaded', handleDOMContentLoaded, false);
handleDOMContentLoaded(); // change to line above if javascript loads before content.
window.addEventListener('unload', handleUnload, false);

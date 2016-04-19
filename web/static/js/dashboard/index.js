import React from 'react';
import {render} from 'react-dom';
import {Provider} from 'react-redux';

import store from './store';
import router from './router';

render(
  <Provider store={store}>
    {router(store)}
  </Provider>
  , document.getElementById('dashboard-container'));

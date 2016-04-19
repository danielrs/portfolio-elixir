import fetch from 'isomorphic-fetch';

const headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
}

function buildHeaders() {
  const authToken = localStorage.getItem('auth-token');
  return {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': authToken
  }
}

function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response;
  }
  else {
    var error = new Error(response.statusText);
    error.response = response;
    throw error;
  }
}

function parseJSON(response) {
  return response.json();
}

export default {
  get: function(url) {
    const config = {
      method: 'GET',
      headers: buildHeaders()
    }
    return fetch(url, config)
    .then(checkStatus)
    .then(parseJSON);
  },

  post: function(url, data) {
    const config = {
      method: 'POST',
      headers: buildHeaders(),
      body: JSON.stringify(data)
    }
    return fetch(url, config)
    .then(checkStatus)
    .then(parseJSON);
  },

  delete: function(url, data) {
    const config = {
      method: 'DELETE',
      headers: buildHeaders(),
      body: JSON.stringify(data)
    }
    return fetch(url, config)
    .then(checkStatus)
    .then(parseJSON);
  },

  patch: function(url, data) {
    const config = {
      method: 'PATCH',
      headers: buildHeaders(),
      body: JSON.stringify(data)
    }
    return fetch(url, config)
    .then(checkStatus)
    .then(parseJSON);
  }
}

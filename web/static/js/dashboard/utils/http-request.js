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
  return response.status != 204 ? response.json() : response;
}

export default {
  get: function(url, params = {}) {
    const queryString = Object.keys(params).reduce((acc, key) => {
      const encodedKey = encodeURIComponent(key);
      const encodedValue = encodeURIComponent(params[key]);
      if (encodedValue.length == 0) return acc;
      else return acc.concat('' + encodedKey + '=' + encodedValue);
    }, []).join('&');

    console.log(queryString);

    const config = {
      method: 'GET',
      headers: buildHeaders()
    }
    return fetch(url + '?' + queryString, config)
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

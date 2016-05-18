exports.config = {
  // Files to compile
  files: {
    javascripts: {
      joinTo: {
       'js/app.js': /^web\/static\/js\/(app|socket.js)/,
       'js/dashboard.js': /^web\/static\/js\/dashboard/,
       'js/vendor.js': /^node_modules|bower_components|web\/static\/vendor/
      }
    },
    stylesheets: {
      joinTo: {
        'css/app.css': /^web\/static\/less\/app/,
        'css/dashboard.css': /^web\/static\/less\/dashboard/,
        'css/vendor.css': /^node_modules|bower_components|web\/static\/vendor/
      }
    }
  },

  conventions: {
    assets: /^web\/static\/assets/
  },

  // Phoenix paths configuration
  paths: {
    watched: [
      'web/static',
      'test/static'
    ],
    public: 'priv/static'
  },

  // Plugin configuration
  plugins: {
    babel: {
      presets: ['es2015', 'react', 'stage-0', 'stage-2'],
      ignore: [/node_modules/, /bower_components/, /web\/static\/vendor/]
    }
  },

  modules: {
    autoRequire: {
      'js/app.js': ['web/static/js/app/index'],
      'js/dashboard.js': ['web/static/js/dashboard/index']
    }
  },

  npm: {
    styles: {'react-date-picker': ['index.css']}
  }
};

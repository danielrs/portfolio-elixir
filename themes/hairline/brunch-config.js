exports.config = {
  // Files to compile
  files: {
    javascripts: {
      joinTo: {
        'js/vendor.js': /^bower_components|static\/vendor/
      },
      entryPoints: {
        'static/js/app/index.js': 'js/app.js',
        'static/js/dashboard/index.js': 'js/dashboard.js',
      }
    },
    stylesheets: {
      joinTo: {
        'css/app.css': /^static\/less\/app/,
        'css/dashboard.css': /^static\/less\/dashboard/,
        'css/vendor.css': /^node_modules|bower_components|static\/vendor/
      }
    }
  },

  conventions: {
    assets: /^static\/assets/
  },

  // Phoenix paths configuration
  paths: {
    watched: [
      'static',
      'test/static'
    ],
    public: '/home/danielrs/Development/Projects/portfolio/priv/static'
  },

  // Plugin configuration
  plugins: {
    babel: {
      presets: ['es2015', 'react', 'stage-0', 'stage-2'],
      ignore: [/node_modules/, /bower_components/, /static\/vendor/]
    }
  },

  modules: {
    autoRequire: {
      'js/app.js': ['static/js/app/index'],
      'js/dashboard.js': ['static/js/dashboard/index']
    }
  },

  npm: {
    styles: {'react-date-picker': ['index.css']}
  }
};

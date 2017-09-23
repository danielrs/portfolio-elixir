exports.config = {
  // Files to compile
  files: {
    javascripts: {
      joinTo: {
        'js/vendor.js': /^bower_components|node_modules|vendor/
      },
      entryPoints: {
        'js/app/index.js': 'js/app.js',
        'js/dashboard/index.js': 'js/dashboard.js',
      }
    },
    stylesheets: {
      joinTo: {
        'css/app.css': /^less\/app/,
        'css/dashboard.css': /^less\/dashboard/,
        'css/vendor.css': /^node_modules|bower_components|vendor/
      }
    }
  },

  conventions: {
    assets: /^(static)/
  },

  // Phoenix paths configuration
  paths: {
    watched: ["static", "css", "less", "js", "vendor"],
    public: "../priv/static"
  },

  // Plugin configuration
  plugins: {
    babel: {
      presets: ['es2015', 'react', 'stage-0', 'stage-2'],
      // Do not use ES6 compiler in vendor code
      ignore: [/node_modules/, /bower_components/, /vendor/]
    }
  },

  modules: {
    autoRequire: {
      'js/app.js': ['js/app/index'],
      'js/dashboard.js': ['js/dashboard/index']
    }
  },

  npm: {
    styles: {'react-date-picker': ['index.css']}
  }
};

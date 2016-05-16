exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      // To use a separate vendor.js bundle, specify two files path
      // https://github.com/brunch/brunch/blob/stable/docs/config.md#files
      joinTo: {
       'js/app.js': /^(web\/static\/js\/(app|socket).js)/,
       'js/dashboard.js': /^(web\/static\/js\/dashboard)/,
       'js/vendor.js': /^(node_modules|bower_components)/
      }
      //
      // To change the order of concatenation of files, explicitly mention here
      // https://github.com/brunch/brunch/tree/master/docs#concatenation
      // order: {
      //   before: [
      //     'web/static/vendor/js/jquery-2.1.1.js',
      //     'web/static/vendor/js/bootstrap.min.js'
      //   ]
      // }
    },
    stylesheets: {
      joinTo: {
        'css/app.css': /^web\/static\/less\/app\/app.less/,
        'css/dashboard.css': /^web\/static\/less\/dashboard\/dashboard.less/,
        'css/vendor.css': /^(bower_components|node_modules|web\/static\/vendor)/
      }
    },
    templates: {
      joinTo: 'js/app.js'
    }
  },

  conventions: {
    ignored: /^(web\/static\/less\/(?!app\/app.less|dashboard\/dashboard.less))/,
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to '/web/static/assets'. Files in this directory
    // will be copied to `paths.public`, which is 'priv/static' by default.
    assets: /^(web\/static\/assets)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      'web/static',
      'test/static'
    ],

    // Where to compile files to
    public: 'priv/static'
  },

  // Configure your plugins
  plugins: {
    babel: {
      presets: ['es2015', 'react', 'stage-0', 'stage-2'],
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/, /bower_components/]
    }
  },

  modules: {
    autoRequire: {
      'js/app.js': ['web/static/js/app'],
      'js/dashboard.js': ['web/static/js/dashboard/index']
    }
  },

  npm: {
    styles: {'react-date-picker': ['index.css']}
  }

};

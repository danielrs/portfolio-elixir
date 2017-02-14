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

var _ = require('lodash');

class ClassToggler {
  constructor(el) {
    this.$el = $(el);
    this.onClasses = undefined;
    this.offClasses = undefined;
  }

  on(classes) {
    this.onClasses = classes;
    this._removeClass(this.offClasses);
    this._addClass(this.onClasses);
  }

  off(classes) {
    this.offClasses = classes;
    this._removeClass(this.onClasses);
    this._addClass(this.offClasses);
  }

  _addClass(classes) {
    if (classes && !this.$el.hasClass(classes))
      this.$el.addClass(classes);
  }
  _removeClass(classes) {
    if (classes && this.$el.hasClass(classes))
      this.$el.removeClass(classes);
  }
}

const isHome = $('body').hasClass('body--home');

// Tagline
$('#tagline').typing({
  sentences: ["Hello",
              "I'm Daniel",
              "I design stuff",
              "I code that stuff",
              "I'm a programmer"]});

// Header toggle
const headerToggler = new ClassToggler('header.header');
const brandToggler = new ClassToggler('header.header .navbar-brand');

$(document).scroll(function() {
  if ($(document).scrollTop() <= 10) {
    headerToggler.on('header--transparent');
    if (isHome) brandToggler.off('animated fadeOutLeft');
  }
  else {
    headerToggler.off();
    if (isHome) brandToggler.on('animated fadeInLeft');
  }
}).trigger('scroll');

// Navbar click
$('.navbar-toggle').click(function() {
  $('.nav-wrapper').toggleClass('nav-wrapper--collapsed');
});

// Resize mega-brand to window height
if (isHome) {
  $(window).resize(_.throttle(function() {
    $('.mega-brand').height($(window).height());
  }, 100));
  $(window).resize();
}

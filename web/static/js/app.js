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
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

$(document).ready(function() {

  $('#tagline').typing({
    sentences: ["Hello",
                "I'm daniel",
                "I code stuff",
                "I'm a programmer!"]});

  $(document).scroll(function() {
    const scroll = $(this).stop().scrollTop();
    if (scroll > 10) $('header').removeClass('header--home');
    else $('header').addClass('header--home');
  });

  if ($('main[role=main]').hasClass('main--home')) {
    $(document).scroll(function() {
      const scroll = $(this).stop().scrollTop();
      if (scroll > 10) {
        $('header').removeClass('header--home');
        $('header .navbar-brand').removeClass('fadeOutLeft');
        $('header .navbar-brand').addClass('animated fadeInLeft');
      }
      else {
        $('header').addClass('header--home');
        $('header .navbar-brand').removeClass('fadeInLeft');
        $('header .navbar-brand').addClass('animated fadeOutLeft');
      }
    });
  }

  $(document).scroll();

});

import {isMobile, ClassToggler} from '../../util';

function headerToggle() {
  const isHome = $('body').hasClass('body--home');
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
}

function navbarClick() {
    $('.navbar-toggle').click(function() {
      $('.nav-wrapper').toggleClass('nav-wrapper--collapsed');
    });
}

function toasts() {
  setTimeout(function() {
    const toastToggler = new ClassToggler('.container--toast');
    toastToggler.off('fadeInUp');
    toastToggler.on('fadeOutDown');
  }, 4000);
}

function highlightjs() {
  hljs.initHighlightingOnLoad();
}

export default class MainView {
  mount() {
    headerToggle();
    navbarClick();
    toasts();
    highlightjs();
  }

  umount() {
  }
}


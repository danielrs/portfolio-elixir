import {Element, isMobile, ClassToggler} from '../../util';

function scrollTop() {
  return (document.documentElement && document.documentElement.scrollTop) || document.body.scrollTop;
}

function headerToggle() {
  const isHome = new Element('body').hasClass('body--home');
  const headerToggler = new ClassToggler('header.header');
  const brandToggler = new ClassToggler('header.header .navbar-brand');

  window.addEventListener('scroll', function() {
    if (scrollTop() <= 10) {
      headerToggler.on('header--transparent');
      if (isHome) brandToggler.off('animated fadeOutLeft');
    }
    else {
      headerToggler.off();
      if (isHome) brandToggler.on('animated fadeInLeft');
    }
  });
  window.dispatchEvent(new Event('scroll'));
}

function navbarClick() {
  new Element('.navbar-toggle').first().addEventListener('click', function() {
    new Element('.nav-wrapper').toggleClass('nav-wrapper--collapsed');
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


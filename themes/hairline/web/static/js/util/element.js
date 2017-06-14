// Different manipulations on multi-elements.
export default class Element {
  constructor(selector) {
    this.elements = [...document.querySelectorAll(selector)];
  }

  first() {
    return this.elements[0];
  }

  hasClass(classes) {
    if (this.elements.length > 0) {
      const el = this.elements[0];
      return classes.split(' ').some(c => hasClass(el, c));
    }
    return false;
  }

  addClass(classes) {
    if (classes) {
      classes = classes.split(' ');
      this.elements.map(el => {
	classes.map(c => addClass(el, c));
      });
    }
  }

  removeClass(classes) {
    if (classes) {
      classes = classes.split(' ');
      this.elements.map(el => {
	classes.map(c => removeClass(el, c));
      });
    }
  }

  toggleClass(classes) {
    if (classes) {
      classes = classes.split(' ');
      this.elements.map(el => {
	classes.map(c => toggleClass(el, c));
      });
    }
  }
}

// Class manipulations.

export function hasClass(el, className) {
  if (el.classList) {
    return el.classList.contains(className);
  } else {
    return new RegExp('(^| )' + className + '( |$)', 'gi').test(el.className);
  }
}

export function addClass(el, className) {
  if (el.classList) {
    el.classList.add(className)
  } else {
    el.className += ' ' + className
  }
}

export function removeClass(el, className) {
  if (el.classList) {
	el.classList.remove(className);
  } else {
	el.className =
      el.className
	  .replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ');
  }
}

export function toggleClass(el, className) {
  if (el.classList) {
    el.classList.toggle(className);
  } else {
    const classes = el.className.split(' ');
    const existingIndex = classes.indexOf(className);

    if (existingIndex >= 0) {
      classes.splice(existingIndex, 1);
    } else {
      classes.push(className);
    }

    el.className = classes.join(' ');
  }
}

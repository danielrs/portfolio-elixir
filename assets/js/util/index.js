import Element from './element';

// Re-exports.
export { Element };

// Function for mapping a function call on
// array values.
export function map(array, f) {
  return Array.prototype.map.call(array, f);
}

// Function to check if we are on a mobile
// From: http://stackoverflow.com/questions/3514784/what-is-the-best-way-to-detect-a-mobile-device-in-jquery
export function isMobile() {
  return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
}

// Toggles the given classes from the given element.
export class ClassToggler {
  constructor(selector) {
    this.el = new Element(selector);
    this.onClasses = '';
    this.offClasses = '';
  }

  on(classes) {
    this.onClasses = classes;
    this.el.removeClass(this.offClasses);
    this.el.addClass(this.onClasses);
  }

  off(classes) {
    this.offClasses = classes;
    this.el.removeClass(this.onClasses);
    this.el.addClass(this.offClasses);
  }
}

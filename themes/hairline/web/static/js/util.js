// Function to check if we are on a mobile
// From: http://stackoverflow.com/questions/3514784/what-is-the-best-way-to-detect-a-mobile-device-in-jquery
export function isMobile() {
  return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
}

// Toggles the given classes from the given element.
export class ClassToggler {
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

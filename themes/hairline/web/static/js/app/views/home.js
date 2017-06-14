import MainView from './main';
import {Element, isMobile} from '../../util';

export default class HomeView extends MainView {
  mount() {
    super.mount();

    // Tagline
    const sentences = [...document.getElementById('tagline-list').children]
      .map(li => li.textContent);

    Typing.new('#tagline', {
      sentences: sentences,
      sentenceDelay: 1000,
      ignorePrefix: true
    });

    // If we are not on mobile, mega brand can be dynamic height.
    if (!isMobile()) {
      new Element('.mega-brand').addClass('mega-brand--dynamic-height');
    }
  }

  umount() {
    super.umount();
  }
}

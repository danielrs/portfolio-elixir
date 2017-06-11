import MainView from './main';
import {isMobile} from '../../util';

export default class HomeView extends MainView {
  mount() {
    super.mount();

    // Tagline
    const sentences = $('#tagline-list').children().map((_, li) => $(li).text());
    $('#tagline').typing({
      sentences: sentences,
      sentenceDelay: 1000,
      ignorePrefix: true
    });

    // If we are not on mobile, mega brand can be dynamic height.
    if (!isMobile()) {
      $('.mega-brand').addClass('mega-brand--dynamic-height');
    }
  }

  umount() {
    super.umount();
  }
}

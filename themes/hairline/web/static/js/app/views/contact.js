import MainView from './main';
import {map} from '../../util';

export default class ContactView extends MainView {
  mount() {
    super.mount();

    // Email.
    const user = 'danielrivas';
    const domain = 'danielrs.me';
    const email = user + '@' + domain;

    const a = document.createElement('a');
    const linkText = document.createTextNode(email);
    a.appendChild(linkText);
    a.title = email;
    a.href = 'mailto:' + email;

    const elements = document.getElementsByClassName('personal-email');
    map(elements, el => {
      el.innerHTML = '';
      el.appendChild(a);
    });
  }

  umount() {
    super.umount();
  }
}

import React from 'react';
import {Link} from 'react-router';

class Navigation extends React.Component {
  render() {
    return (
      <nav role="navigation">
        <ul className="nav">
          <li className="nav__item">
            <Link to="/dashboard/projects" className="nav__link" activeClassName="nav__link--active">Projects</Link>
          </li>
          <li className="nav__item">
            <Link to="/dashboard/posts" className="nav__link" activeClassName="nav__link--active">Posts</Link>
          </li>
        </ul>
      </nav>
    );
  }
}

export default Navigation;

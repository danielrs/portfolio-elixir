import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import {Glyph} from 'elemental';

class MainLayoutView extends React.Component {
  render() {
    return (
      <div className="dashboard">
        <aside className="primary-aside">
          <header role="heading">
            <Link to="/dashboard" className="primary-header__title">
              <h4><Glyph icon="circuit-board" /> Dashboard</h4>
            </Link>
          </header>
          <h3>Resources</h3>
          <ul className="aside-list">
            <li>
              <Link to="/dashboard/projects" activeClassName="aside-list__active">
                <i className="fa fa-book" /> Projects
              </Link>
            </li>
            <li>
              <Link to="/dashboard/posts" activeClassName="aside-list__active">
                <i className="fa fa-wpforms" /> Posts
              </Link>
            </li>
          </ul>
          <h3>Settings</h3>
          <ul className="aside-list">
            <li>
              <Link to="/dashboard/users" activeClassName="aside-list__active">
                <i className="fa fa-users" /> Users
              </Link>
            </li>
          </ul>
        </aside>
        <main role="main">
          {this.props.children}
        </main>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {user: state.session.user};
};

export default connect(mapStateToProps)(MainLayoutView);

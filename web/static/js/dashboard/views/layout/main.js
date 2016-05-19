import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import Navigation from '../../components/layout/navigation';
import DocumentTitle from '../../components/layout/document-title';

class MainLayoutView extends React.Component {
  render() {
    return (
      <DocumentTitle title="Dashboard" suffix="">
        <div className="dashboard">
          <header role="heading">
            <div className="container">
              <h1><Link to="/dashboard">Dashboard</Link></h1>
              <Navigation />
            </div>
          </header>
          <main role="main">
            <div className="container">
              {this.props.children}
            </div>
          </main>
        </div>
      </DocumentTitle>
    );
  }
}

const mapStateToProps = state => {
  return {user: state.session.user};
};

export default connect(mapStateToProps)(MainLayoutView);

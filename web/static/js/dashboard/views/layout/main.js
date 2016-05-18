import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import Navigation from '../../components/layout/navigation';
import Container from '../../components/layout/container';
import DocumentTitle from '../../components/layout/document-title';

class MainLayoutView extends React.Component {
  render() {
    return (
      <DocumentTitle title="Dashboard" suffix="">
        <div className="dashboard">
          <header role="heading">
            <Container>
              <h1><Link to="/dashboard">Dashboard</Link></h1>
              <Navigation />
            </Container>
          </header>
          <main role="main">
            <Container>
              {this.props.children}
            </Container>
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

import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import {replace} from 'react-router-redux';
import DocumentTitle from '../../components/layout/document-title';

class HomeIndexView extends React.Component {
  componentWillMount() {
    const {dispatch} = this.props;
    dispatch(replace('/dashboard/projects'));
  }

  render() {
    return (
      <DocumentTitle title="Home">
        <Link to="/dashboard/projects">Projects</Link>
      </DocumentTitle>
    );
  }
}

const mapStateToProps = state => {
  return state;
};

export default connect(mapStateToProps)(HomeIndexView);

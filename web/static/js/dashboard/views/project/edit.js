import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import Constants from '../../constants';
import Actions from '../../actions/project';

class ProjectEditView extends React.Component {

  render() {
    return (
      <div>Edit</div>
    );
  }
}

const mapStateToProps = function(state) {
  return state.project;
};

export default connect(mapStateToProps)(ProjectEditView);

import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import Constants from '../../constants';
import Actions from '../../actions/project';
import {Button, Dropdown, Glyph, Table, Spinner} from 'elemental';
import ProjectList from '../../components/project/project-list';
import ProjectDeleteUndo from '../../components/project/project-delete-undo.js';
import Loader from '../../components/layout/loader';
import DocumentTitle from '../../components/layout/document-title';

class ProjectIndexView extends React.Component {
  componentDidMount() {
    const {dispatch} = this.props;
    dispatch(Actions.fetchProjects());
  }

  render() {
    return (
      <DocumentTitle title="Projects">
        <div className="header-content">
          <Button component={<Link to="/dashboard/projects/new"/>} type="hollow-primary" size="sm">
            <Glyph icon="plus" />
            {' '}
            Create project
          </Button>
        </div>
        <ProjectDeleteUndo />
        <Loader loaded={this.props.loaded}>
          <ProjectList dispatch={this.props.dispatch} projects={this.props.projects} />
        </Loader>
        {this.props.children}
      </DocumentTitle>
    );
  }
}

const mapStateToProps = function(state) {
  return state.project;
};

export default connect(mapStateToProps)(ProjectIndexView);

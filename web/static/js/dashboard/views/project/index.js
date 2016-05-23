import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import {Button, Dropdown, Glyph, Table, Spinner} from 'elemental';

import Constants from '../../constants';
import Actions from '../../actions/project';
import Loader from '../../components/layout/loader';
import DocumentTitle from '../../components/layout/document-title';
import FilterForm from '../../components/layout/filter-form';
import ProjectDeleteUndo from '../../components/project/project-delete-undo.js';
import ProjectList from '../../components/project/project-list';

const sortOptions = [
  {label: 'Date', value: 'date'},
  {label: 'Title', value: 'title'},
  {label: 'Description', value: 'description'},
  {label: 'Homepage', value: 'homepage'},
  {label: 'Content', value: 'content'}
];

class ProjectIndexView extends React.Component {
  _handleChange = filter => {}

  _handleFilterChange = filter => {
    const {dispatch} = this.props;
    dispatch(Actions.filter(filter));
  }

  _handleSubmit = e => {
    e.preventDefault();
    const {dispatch} = this.props;
    dispatch(Actions.filter(this.props.filter));
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
          <FilterForm
            sortOptions={sortOptions}
            onLoad={this._handleFilterChange}
            onChange={this._handleChange}
            onFilterChange={this._handleFilterChange}
            onSubmit={this._handleSubmit} noSearch noSubmit />
          <ProjectDeleteUndo />
        </div>
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

import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import Constants from '../../constants';
import Actions from '../../actions/project';
import {Button, Dropdown, Glyph, Table} from 'elemental';
import Enum from '../../utils/enum';
import ProjectList from '../../components/project/project-list';
import ProjectDeleteUndo from '../../components/project/project-delete-undo.js';

const DropdownActions  = new Enum([
  'EDIT',
  'DELETE'
]);

const DROPDOWN_ITEMS = [
  {label: 'Edit', value: DropdownActions.EDIT},
  {label: 'Delete', value: DropdownActions.DELETE}
];

class ProjectIndexView extends React.Component {
  componentDidMount() {
    const {dispatch} = this.props;
    dispatch(Actions.fetchProjects());
  }

  render() {
    return (
      <div>
        <div className="header-content">
          <Button component={<Link to="/dashboard/projects/new"/>} type="hollow-primary" size="sm">
            <Glyph icon="plus" />
            {' '}
            Create project
          </Button>
        </div>
        <ProjectDeleteUndo />
        <div className="main-container">
          <ProjectList />
        </div>
        {this.props.children}
      </div>
    );
  }
}

const mapStateToProps = function(state) {
  return state.project;
};

export default connect(mapStateToProps)(ProjectIndexView);

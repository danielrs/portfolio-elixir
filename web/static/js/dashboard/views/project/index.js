import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import Constants from '../../constants';
import Actions from '../../actions/project';

class ProjectIndexView extends React.Component {
  componentDidMount() {
    const {dispatch} = this.props;
    dispatch(Actions.fetchProjects());
  }

  render() {
    return (
      <div>
        <h2>Projects</h2>
        <ul>
          {this.props.projects.map(this._renderProject)}
        </ul>
        {this.props.children}
      </div>
    );
  }

  _renderProject(project) {
    return (
      <li key={project.id}>
        <Link to={'/dashboard/projects/' + project.id}>
          {project.title}
        </Link>
        <p>{project.description}</p>
        <Link to={'/dashboard/projects/' + project.id + '/edit'}>Edit</Link>
      </li>
    );
  }
}

const mapStateToProps = function(state) {
  return state.project;
};

export default connect(mapStateToProps)(ProjectIndexView);

import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import Constants from '../../constants';
import Actions from '../../actions/project';

class ProjectShowView extends React.Component {
  componentDidMount() {
    this.fetchProject();
  }

  componentDidUpdate(prevProps) {
    if (this.props.params.id != prevProps.params.id)
      this.fetchProject();
  }

  render() {
    return (
      <div className="project">
        <h1>{this.props.title}</h1>
        <p>{this.props.description}</p>
        <a href={this.props.homepage}>Visit homepage</a>
        <div className="project__content">
          {this.props.content}
        </div>
      </div>
    );
  }

  fetchProject() {
    const {dispatch} = this.props;
    dispatch(Actions.fetchProject(this.props.params.id));
  }
}

const mapStateToProps = function(state) {
  return state.project.focusedProject;
};

export default connect(mapStateToProps)(ProjectShowView);

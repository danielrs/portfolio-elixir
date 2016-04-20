import React from 'react';
import {Link, goBack} from 'react-router';
import {connect} from 'react-redux';
import Constants from '../../constants';
import Actions from '../../actions/project';
import ProjectForm from './form';

class ProjectEditView extends React.Component {
  render() {
    return (
      <div>
        <h1>Editing {this.props.project.title}</h1>
        <form onSubmit={this._handleSubmit}>
          <ProjectForm ref="form"
                       errors={this.props.errors}
                       {...this.props.project}
                       />
          <input type="button" value="Cancel" onClick={this._handleCancel} />
          <input type="submit" value="Create" className="button--primary" />
        </form>
      </div>
    );
  }

  _handleCancel = (e) => {
    const {dispatch} = this.props;
    dispatch(goBack());
  }

  _handleSubmit = (e) => {
    e.preventDefault();
    const {dispatch} = this.props;
    dispatch(Actions.newProject(this.refs.form.getFormData()));
  }
}

const mapStateToProps = function(state) {
  return {
    project: state.project.focusedProject,
    errors: state.project.errors
  };
};

export default connect(mapStateToProps)(ProjectEditView);

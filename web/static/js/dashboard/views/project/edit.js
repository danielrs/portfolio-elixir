import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import Constants from '../../constants';
import Actions from '../../actions/project';
import ProjectForm from './form';

class ProjectEditView extends React.Component {
  componentDidMount() {
    this.fetchProject();
  }

  componentDidUpdate(prevProps) {
    if (this.props.params.id != prevProps.params.id)
      this.fetchProject();
  }

  render() {
    return (
      <div>
        <h1>Editing {this.props.project.title}</h1>
        <form onSubmit={this._handleSubmit}>
          <ProjectForm ref="form"
                       handleChange={this._handleChange}
                       handleSubmit={this._handleSubmit}
                       errors={this.props.errors}
                       {...this.props.project}
                       />
          <input type="submit" value="Save" />
        </form>
      </div>
    );
  }

  fetchProject() {
    const {dispatch} = this.props;
    dispatch(Actions.fetchProject(this.props.params.id));
  }

  _handleChange = (e) => {
    console.log('Changed');
  }

  _handleSubmit = (e) => {
    e.preventDefault();
    const {dispatch} = this.props;
    dispatch(Actions.editProject(this.props.params.id, this.refs.form.getFormData()));
  }
}

const mapStateToProps = function(state) {
  return {
    project: state.project.focusedProject,
    errors: state.project.errors
  };
};

export default connect(mapStateToProps)(ProjectEditView);

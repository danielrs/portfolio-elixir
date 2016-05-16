import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import {replace} from 'react-router-redux';
import Constants from '../../constants';
import Actions from '../../actions/project';
import ProjectForm from '../../components/project/form';
import {Button, Modal, ModalHeader, ModalBody, ModalFooter} from 'elemental';

class ProjectEditView extends React.Component {
  state = {
    isOpen: false,
    changed: false
  }

  componentDidMount() {
    this.fetchProject();
    this.setState({isOpen: true});
  }

  componentDidUpdate(prevProps) {
    if (this.props.params.id != prevProps.params.id)
      this.fetchProject();
  }

  fetchProject() {
    const {dispatch} = this.props;
    dispatch(Actions.formReset());
    dispatch(Actions.fetchProject(this.props.params.id));
  }

  _handleSubmit = (e) => {
    const {dispatch} = this.props;
    this.setState({isOpen: false});
    console.log(this.refs.form.getFormData());
    dispatch(Actions.editProject(this.props.params.id, this.refs.form.getFormData()));
    dispatch(replace(`/dashboard/projects/${this.props.params.id}`));
  }

  _handleCancel = (e) => {
    const {dispatch} = this.props;
    this.setState({isOpen: false});
    dispatch(replace(`/dashboard/projects/${this.props.params.id}`));
  }

  _handleClose = (e) => {
    const {dispatch} = this.props;
    this.setState({isOpen: false});
    dispatch(replace('/dashboard/projects'));
  }

  _handleChange = (e) => {

    function scrubProject(project) {
      Object.keys(project).forEach(key => {if (!project[key]) project[key] = ''});
      return Object.assign({}, project);
    }

    function equalProjects(a, b) {
      const scrubbedA = scrubProject(a);
      const scrubbedB = scrubProject(b);
      console.log(a);
      console.log(b);
      return  scrubbedA.title == b.title
              && scrubbedA.description == scrubbedB.description
              && scrubbedA.homepage == scrubbedB.homepage
              && scrubbedA.content == scrubbedB.content
              && scrubbedA.date == scrubbedB.date;
    }

    this.setState({changed: !equalProjects(this.props.project, this.refs.form.getFormData().project)});
  }

  render() {
    return (
      <Modal isOpen={this.state.isOpen}>
        <ModalHeader text={"Editing " + this.props.project.title} showCloseButton onClose={this._handleClose} />
        <ModalBody>
          <ProjectForm ref="form" project={this.props.project} errors={this.props.errors} onChange={this._handleChange} />
        </ModalBody>
        <ModalFooter>
          <Button type="hollow-primary" onClick={this._handleSubmit} disabled={!this.state.changed}>Save</Button>
          <Button type="link-cancel" onClick={this._handleCancel}>Show</Button>
          <Button type="link-cancel" onClick={this._handleClose}>Close</Button>
        </ModalFooter>
      </Modal>
    );
  }
}

const mapStateToProps = function(state) {
  return {
    project: state.project.focused,
    errors: state.project.errors
  };
};

export default connect(mapStateToProps)(ProjectEditView);

import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import {push} from 'react-router-redux';
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
    dispatch(Actions.errorReset());
    dispatch(Actions.fetchProject(this.props.params.id));
  }

  _handleSubmit = (e) => {
    const {dispatch} = this.props;
    dispatch(Actions.editProject(this.props.params.id, this.refs.form.getFormData()));
  }

  _handleShow = (e) => {
    const {dispatch} = this.props;
    this.setState({isOpen: false});
    dispatch(push(`/dashboard/projects/${this.props.params.id}`));
  }

  _handleClose = (e) => {
    const {dispatch} = this.props;
    this.setState({isOpen: false});
    dispatch(push('/dashboard/projects'));
  }

  render() {
    return (
      <Modal isOpen={this.state.isOpen}>
        <ModalHeader text={"Editing " + this.props.project.title} showCloseButton onClose={this._handleClose} />
        <ModalBody>
          <ProjectForm ref="form" project={this.props.project} errors={this.props.errors} />
        </ModalBody>
        <ModalFooter>
          <Button type="hollow-primary" onClick={this._handleSubmit}>Save</Button>
          <Button type="link-cancel" onClick={this._handleShow}>Show</Button>
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

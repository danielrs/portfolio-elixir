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
    isOpen: false
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

  render() {
    return (
      <Modal isOpen={this.state.isOpen}>
        <ModalHeader text={"Editing " + this.props.project.title} showCloseButton onClose={this._handleCancel} />
        <ModalBody>
          <ProjectForm ref="form" errors={this.props.errors} {...this.props.project} />
        </ModalBody>
        <ModalFooter>
          <Button type="hollow-primary" onClick={this._handleSubmit}>Save</Button>
          <Button type="link-cancel" onClick={this._handleCancel}>Cancel</Button>
        </ModalFooter>
      </Modal>
    );
  }

  _handleChange = (e) => {
  }

  _handleSubmit = (e) => {
    const {dispatch} = this.props;
    dispatch(Actions.editProject(this.props.params.id, this.refs.form.getFormData()));
  }

  _handleCancel = (e) => {
    const {dispatch} = this.props;
    this.setState({isOpen: false});
    dispatch(replace('/dashboard/projects'));
  }
}

const mapStateToProps = function(state) {
  return {
    project: state.project.focused,
    errors: state.project.errors
  };
};

export default connect(mapStateToProps)(ProjectEditView);

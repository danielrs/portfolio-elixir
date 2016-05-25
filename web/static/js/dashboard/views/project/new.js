import React from 'react';
import {push} from 'react-router-redux';
import {connect} from 'react-redux';
import {Button, Modal, ModalHeader, ModalBody, ModalFooter} from 'elemental';

import Constants from '../../constants';
import Actions from '../../actions/project';
import ProjectForm from '../../components/project/form';
import DocumentTitle from '../../components/layout/document-title';

class ProjectNewView extends React.Component {
  state = {
    isOpen: false
  }

  componentDidMount() {
    const {dispatch} = this.props;
    dispatch(Actions.errorReset());
    this.setState({isOpen: true});
  }

  _handleSubmit = (e) => {
    e.preventDefault();
    const {dispatch} = this.props;
    dispatch(Actions.createProject(this.refs.form.getFormData()));
  }

  _handleClose = (e) => {
    const {dispatch} = this.props;
    this.setState({isOpen: false});
    dispatch(push('/dashboard/projects'));
  }

  render() {
    return (
      <DocumentTitle title="New project">
        <Modal isOpen={this.state.isOpen}>
          <ModalHeader text="New project" showCloseButton onClose={this._handleCancel}/>
          <ModalBody>
            <ProjectForm ref="form" errors={this.props.errors} />
          </ModalBody>
          <ModalFooter>
            <Button type="hollow-primary" onClick={this._handleSubmit} disabled={this.props.submiting}>
              {this.props.submiting ? 'Creating...' : 'Create'}
            </Button>
            <Button type="link-cancel" onClick={this._handleClose}>Close</Button>
          </ModalFooter>
        </Modal>
      </DocumentTitle>
    );
  }
}

const mapStateToProps = function(state) {
  return {
    submiting: state.project.submiting,
    errors: state.project.errors
  };
};

export default connect(mapStateToProps)(ProjectNewView);

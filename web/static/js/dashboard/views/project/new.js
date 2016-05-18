import React from 'react';
import {Link} from 'react-router';
import {push} from 'react-router-redux';
import {connect} from 'react-redux';
import Constants from '../../constants';
import Actions from '../../actions/project';
import ProjectForm from '../../components/project/form';
import {Button, Modal, ModalHeader, ModalBody, ModalFooter} from 'elemental';
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
    dispatch(Actions.newProject(this.refs.form.getFormData()));
  }

  _handleClose = (e) => {
    const {dispatch} = this.props;
    this.setState({isOpen: false});
    dispatch(push('/dashboard/projects'));
  }

  render() {
    return (
      <DocumentTitle title="Create project">
        <Modal isOpen={this.state.isOpen}>
          <ModalHeader text="Create project" showCloseButton onClose={this._handleCancel}/>
          <ModalBody>
            <ProjectForm ref="form" errors={this.props.errors} />
          </ModalBody>
          <ModalFooter>
            <Button type="hollow-primary" onClick={this._handleSubmit}>Create</Button>
            <Button type="link-cancel" onClick={this._handleClose}>Close</Button>
          </ModalFooter>
        </Modal>
      </DocumentTitle>
    );
  }
}

const mapStateToProps = function(state) {
  return {
    errors: state.project.errors
  };
};

export default connect(mapStateToProps)(ProjectNewView);

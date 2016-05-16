import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import {push, replace} from 'react-router-redux';
import Constants from '../../constants';
import Actions from '../../actions/project';
import {Button, Modal, ModalHeader, ModalBody, ModalFooter} from 'elemental';

class ProjectShowView extends React.Component {
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
    dispatch(Actions.fetchProject(this.props.params.id));
  }


  _handleEdit = (e) => {
    const {dispatch} = this.props;
    dispatch(push(`/dashboard/projects/${this.props.params.id}/edit`));
  }

  _handleClose = (e) => {
    const {dispatch} = this.props;
    this.setState({isOpen: false});
    dispatch(replace('/dashboard/projects'));
  }

  render() {
    const editUrl = '/dashboard/projects/' + this.props.params.id + '/edit';
    return (
      <Modal isOpen={this.state.isOpen}>
        <ModalHeader text={this.props.project.title} showCloseButton onClose={this._handleClose} />
        <ModalBody>
          <h1>{this.props.project.title}</h1>
          <div>{this.props.project.description}</div>
          <a href="{this.props.project.homepage}">{this.props.project.homepage}</a>
          <div>
            {this.props.project.content}
          </div>
        </ModalBody>
        <ModalFooter>
          <Button type="hollow-primary" onClick={this._handleEdit}>Edit</Button>
          <Button type="link-cancel" onClick={this._handleClose}>Close</Button>
        </ModalFooter>
      </Modal>
    );
  }
}

const mapStateToProps = function(state) {
  return {
    project: state.project.focused
  }
};

export default connect(mapStateToProps)(ProjectShowView);

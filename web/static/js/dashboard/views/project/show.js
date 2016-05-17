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
    const content = this.props.project.content
      ? <div className="project__content">{this.props.project.content}</div>
      : '';
    return (
      <Modal isOpen={this.state.isOpen}>
        <ModalHeader text={'Showing ' + this.props.project.title} showCloseButton onClose={this._handleClose} />
        <ModalBody className="project">
          <h1 className="project__title">
            {this.props.project.title + ' '}
            <span className="project__date">{this.props.project.date}</span>
          </h1>
          <div className="project__description">{this.props.project.description}</div>
          <a className="project__homepage" href={this.props.project.homepage}>{this.props.project.homepage}</a>
          {content}
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

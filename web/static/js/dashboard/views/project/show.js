import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import {push} from 'react-router-redux';
import Constants from '../../constants';
import Actions from '../../actions/project';
import {Button, ModalHeader, ModalBody, ModalFooter} from 'elemental';
import ModalLoader from '../../components/layout/modal-loader';
import DocumentTitle from '../../components/layout/document-title';
import Loader from '../../components/layout/loader';
import ProjectForm from '../../components/project/form';
import Collapse from 'react-collapse';
import {presets} from 'react-motion';

class ProjectShowView extends React.Component {
  state = {
    isOpen: false
  }

  componentDidMount() {
    this.fetchProject();
    this.setState({isOpen: true});
  }

  componentWillUnmount() {
    document.body.style.overflow = null;
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
    dispatch(Actions.editProject(this.props.params.id));
  }

  _handleClose = (e) => {
    const {dispatch} = this.props;
    dispatch(push('/dashboard/projects'));
  }

  _renderShow() {
    return (
      <div>
        <ModalHeader text={'Showing ' + this.props.project.title} showCloseButton onClose={this._handleClose} />
        <ModalBody className="project">
          <Collapse isOpened={true}>
            <h1 className="project__title">
              {this.props.project.title + ' '}
              <span className="project__date">{this.props.project.date}</span>
            </h1>
            <div className="project__description">{this.props.project.description}</div>
            <a className="project__homepage" href={this.props.project.homepage}>{this.props.project.homepage}</a>
            {this.props.project.content
              ? <div className="project__content">{this.props.project.content}</div>
              : ''
            }
          </Collapse>
        </ModalBody>
        <ModalFooter key={Math.random()}>
          <Button type="hollow-primary" onClick={this._handleEdit}>Edit</Button>
          <Button type="link-cancel" onClick={this._handleClose}>Close</Button>
        </ModalFooter>
      </div>
    );
  }

  _handleSave = e => {
    const {dispatch} = this.props;
    dispatch(Actions.updateProject(this.props.params.id, this.refs.form.getFormData()));
  }

  _handleShow = e => {
    const {dispatch} = this.props;
    dispatch(Actions.showProject(this.props.params.id));
  }

  _renderEdit() {
    return (
      <div>
        <ModalHeader text={'Editing ' + this.props.project.title} showCloseButton onClose={this._handleClose} />
        <ModalBody>
          <Collapse isOpened={true}>
            <ProjectForm ref="form" project={this.props.project} errors={this.props.errors} />
          </Collapse>
        </ModalBody>
        <ModalFooter key={Math.random()}>
          <Button type="hollow-primary" onClick={this._handleSave} disabled={this.props.submiting}>
            {this.props.submiting ? 'Saving...' : 'Save'}
          </Button>
          <Button type="link-cancel" onClick={this._handleShow}>Show</Button>
          <Button type="link-cancel" onClick={this._handleClose}>Close</Button>
        </ModalFooter>
      </div>
    );
  }

  render() {
    return (
      <DocumentTitle title={(this.props.children ? 'Editing ' : '') + (this.props.project.title || '...')}>
        <ModalLoader loaded={this.props.loaded} isOpen={this.state.isOpen}>
          {this.props.children ? this._renderEdit() : this._renderShow()}
        </ModalLoader>
      </DocumentTitle>
    );
  }
}

const mapStateToProps = function(state) {
  return {
    ...state.project.current,
    submiting: state.project.submiting,
    errors: state.project.errors
  };
};

export default connect(mapStateToProps)(ProjectShowView);

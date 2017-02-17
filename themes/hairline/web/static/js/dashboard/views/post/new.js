import React from 'react';
import {push} from 'react-router-redux';
import {connect} from 'react-redux';
import {Button, Modal, ModalHeader, ModalBody, ModalFooter} from 'elemental';

import Constants from '../../constants';
import Actions from '../../actions/post';

import DocumentTitle from '../../components/layout/document-title';
import PostForm from './components/form';

class PostNewView extends React.Component {
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
    dispatch(Actions.createPost(this.refs.form.getFormData()));
  }

  _handleClose = (e) => {
    const {dispatch} = this.props;
    this.setState({isOpen: false});
    dispatch(push('/dashboard/posts'));
  }

  render() {
    return (
      <DocumentTitle title="New post">
        <Modal width="large" isOpen={this.state.isOpen}>
          <ModalHeader text="New post" showCloseButton onClose={this._handleClose}/>
          <ModalBody>
            <PostForm ref="form" errors={this.props.errors} />
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
    submiting: state.post.submiting,
    errors: state.post.errors
  };
};

export default connect(mapStateToProps)(PostNewView);

import React from 'react';
import {findDOMNode} from 'react-dom'
import {connect} from 'react-redux';
import {push} from 'react-router-redux';
import {presets} from 'react-motion';
import {Button, ModalHeader, ModalBody, ModalFooter} from 'elemental';

import Constants from '../../constants';
import Actions from '../../actions/post';

import DocumentTitle from '../../components/layout/document-title';
import ModalLoader from '../../components/layout/modal-loader';
import ConfirmButton from '../../components/layout/confirm-button';
import PostForm from './components/form';

class PostShowView extends React.Component {
  state = {
    isOpen: false,
    changed:  false
  }

  componentDidMount() {
    this.fetchPost();
    this.setState({isOpen: true});
  }

  shouldComponentUpdate(nextProps, nextState) {
    if (nextState.changed == true && this.state.changed == false) {
      return false;
    }
    return true;
  }

  componentDidUpdate(prevProps) {
    if (this.props.params.id != prevProps.params.id)
      this.fetchPost();
  }

  fetchPost() {
    const {dispatch} = this.props;
    dispatch(Actions.fetchPost(this.props.params.id));
  }

  // Show Modal
  _handleEdit = (e) => {
    const {dispatch} = this.props;
    dispatch(Actions.editPost(this.props.params.id));
  }

  _handleClose = (e) => {
    const {dispatch} = this.props;
    dispatch(push('/dashboard/posts'));
  }

  _highlightPost = (post_body) => {
    if (!this.props.children) {
      $(post_body).find('pre code').each(function(i, block) {
        hljs.highlightBlock(block);
      });
    }
  }

  _renderShow() {
    return (
      <div>
        <ModalHeader text={'Showing ' + this.props.post.title} showCloseButton onClose={this._handleClose} />
        <ModalBody className="post">
          <header className="post__header post__header--main">
            <div className="post__date">{this.props.post.date}</div>
            <h1 className="post__title">{this.props.post.title}</h1>

            <div className="post__meta">
              by
              <span className="post__author">
              </span>

            </div>
          </header>
          <div ref={this._highlightPost} className="post__body" dangerouslySetInnerHTML={{__html: this.props.post.html}} />
        </ModalBody>
        <ModalFooter key={Math.random()}>
          <Button type="hollow-primary" onClick={this._handleEdit}>Edit</Button>
          <Button type="link-cancel" onClick={this._handleClose}>Close</Button>
        </ModalFooter>
      </div>
    );
  }

  // Edit Modal
  _handleChange = e => {
    if (!this.state.changed) {
      this.setState({changed: true});
    }
  }

  _handleSave = e => {
    const {dispatch} = this.props;
    dispatch(Actions.updatePost(this.props.params.id, this.refs.form.getFormData()));
    this.setState({changed: false});
  }

  _handleShow = e => {
    const {dispatch} = this.props;
    dispatch(Actions.showPost(this.props.params.id));
    this.setState({changed: false});
  }

  _renderEdit() {
    return (
      <div>
        <ModalHeader text={'Editing ' + this.props.post.title} showCloseButton onClose={this._handleClose} />
        <ModalBody>
          <PostForm ref="form" post={this.props.post} errors={this.props.errors} onChange={this._handleChange} />
          </ModalBody>
        <ModalFooter key={Math.random()}>
          <Button type="hollow-primary" onClick={this._handleSave} disabled={this.props.submiting}>
            {this.props.submiting ? 'Saving...' : 'Save'}
          </Button>
          <ConfirmButton mustConfirm={() => this.state.changed} onConfirm={this._handleShow}>
            {confirming => confirming
              ?  <Button type="link-danger">Show without saving?</Button>
              : <Button type="link-text">Show</Button>
            }
          </ConfirmButton>
          <ConfirmButton mustConfirm={() => this.state.changed} onConfirm={this._handleClose}>
            {confirming => confirming
              ? <Button type="link-danger">Close without saving?</Button>
              : <Button type="link-cancel">Close</Button>
            }
          </ConfirmButton>
        </ModalFooter>
      </div>
    );
  }

  // Render show or edit modal
  render() {
    return (
      <DocumentTitle title={(this.props.children ? 'Editing ' : '') + (this.props.post.title || '...')}>
        <ModalLoader width="large" loaded={this.props.loaded} isOpen={this.state.isOpen}>
          {this.props.children ? this._renderEdit() : this._renderShow()}
        </ModalLoader>
      </DocumentTitle>
    );
  }
}

const mapStateToProps = function(state) {
  return {
    ...state.post.current,
    submiting: state.post.submiting,
    errors: state.post.errors
  };
};

export default connect(mapStateToProps)(PostShowView);

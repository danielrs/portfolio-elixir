import React from 'react';
import {connect} from 'react-redux';
import Constants from '../../constants';
import Actions from '../../actions/session';
import {Button, Form, FormField, FormIconField, FormInput, Modal, ModalHeader, ModalBody, ModalFooter} from 'elemental';
import DocumentTitle from '../../components/layout/document-title';

class SessionNewView extends React.Component {
  _handleSubmit = (e) => {
    e.preventDefault();
    const {dispatch} = this.props;
    dispatch(Actions.signIn(this.refs.email.refs.input.value, this.refs.password.refs.input.value));
  }

  _renderError = () => {
    const {error} = this.props;
    if (!error) return false;
    return (
      <div className="error">
        {error}
      </div>
    );
  }

  render() {
    return (
      <DocumentTitle title="Login">
        <Modal isOpen={true} width={420} className="login-modal">
          <ModalHeader text="Login" />
          <ModalBody>
            <Form>
              <FormField>
                {this._renderError()}
              </FormField>
              <FormIconField iconKey="mail" iconFill="default">
                <FormInput ref="email" type="text" placeholder="Email" size="lg" autoFocus />
              </FormIconField>
              <FormIconField iconKey="lock" iconFill="default">
                <FormInput ref="password" type="password" placeholder="Password" size="lg" />
              </FormIconField>
              <Button type="primary" onClick={this._handleSubmit} width="100%">Login</Button>
            </Form>
          </ModalBody>
        </Modal>
      </DocumentTitle>
    );
  }
}

const mapStateToProps = function(state) {
  return state.session;
};

export default connect(mapStateToProps)(SessionNewView);

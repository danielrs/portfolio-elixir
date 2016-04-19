import React from 'react';
import {connect} from 'react-redux';
import Constants from '../../constants';
import Actions from '../../actions/session';

class SessionNewView extends React.Component {
  render() {
    return (
      <form id="session-form" onSubmit={::this._handleSubmit}>
        {::this._renderError()}
        <input ref="email" type="text" placeholder="Email" required={true} />
        <input ref="password" type="password" placeholder="Password" required={true} />
        <input type="submit" />
      </form>
    );
  }

  _handleSubmit(e) {
    e.preventDefault();
    const {dispatch} = this.props;
    dispatch(Actions.signIn(this.refs.email.value, this.refs.password.value));
  }

  _renderError() {
    const {error} = this.props;
    if (!error) return false;
    return (
      <div className="error">
        {error}
      </div>
    );
  }
}

const mapStateToProps = function(state) {
  return state.session;
};

export default connect(mapStateToProps)(SessionNewView);

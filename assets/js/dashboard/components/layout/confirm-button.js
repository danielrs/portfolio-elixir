import React from 'react';

class ConfirmButton extends React.Component {
  static propTypes = {
    component: React.PropTypes.node,
    mustConfirm: React.PropTypes.func.isRequired,
    timeout: React.PropTypes.number.isRequired,
    onConfirm: React.PropTypes.func,
    children: React.PropTypes.func.isRequired
  }

  static defaultProps = {
    component: 'span',
    mustConfirm: () => true,
    timeout: 2000,
    onConfirm: _ => undefined
  }

  state = {
    clicked: false,
    timeoutId: null
  }

  componentWillUnmount() {
    clearTimeout(this.state.timeoutId);
  }

  _handleClick = e => {
    if (!this.state.clicked && this.props.mustConfirm()) {
      this.setState({
        clicked: true,
        timeoutId: setTimeout(() => this.setState({clicked: false}), this.props.timeout)
      });
    }
    else {
      clearTimeout(this.state.timeoutId);
      this.props.onConfirm(e);
    }
  }

  render() {
    return React.createElement(
      this.props.component,
      {key: this.state.clicked ? 'confirm' : 'normal', onClick: this._handleClick},
      this.props.children(this.state.clicked)
    );
  }
}

export default ConfirmButton;

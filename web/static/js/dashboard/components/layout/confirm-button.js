import React from 'react';

class ConfirmButton extends React.Component {
  static propTypes = {
    component: React.PropTypes.element,
    componentConfirm: React.PropTypes.element,
    wrapperComponent: React.PropTypes.node,
    mustConfirm: React.PropTypes.func.isRequired,
    timeout: React.PropTypes.number.isRequired,
    onConfirm: React.PropTypes.func,
  }

  static defaultProps = {
    wrapperComponent: 'span',
    mustConfirm: _ => true,
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
    let children;
    if (this.state.clicked) children = this.props.componentConfirm;
    else children = this.props.component;
    return React.createElement(
      this.props.wrapperComponent,
      {key: this.state.clicked ? 'normal' : 'confirm', onClick: this._handleClick},
      children
    );
  }
}

export default ConfirmButton;

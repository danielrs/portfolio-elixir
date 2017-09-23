import React from 'react';
import {Spinner} from 'elemental';

class Loader extends React.Component {
  static defaultProps = {
    className: '',
    component: 'div',
    loaderComponent: 'div',
    contentComponent: 'div',
    loaded: false
  }

  _renderSpinner() {
    return <Spinner size="md" className="Spinner--main" />
  }

  render() {
    const loaderProps = {
      key: 'loader',
      style: {display: this.props.loaded ? 'none' : 'initial'}
    }

    const contentProps = {
      key: 'content',
      style: {display: this.props.loaded ? 'initial' : 'none'}
    }

    const children = [
      React.createElement(this.props.loaderComponent, loaderProps, this._renderSpinner()),
      React.createElement(this.props.contentComponent, contentProps, this.props.children)
    ];

    return React.createElement(this.props.component, {className: this.props.className}, children);
  }
}

export default Loader;

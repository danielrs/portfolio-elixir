import React from 'react';
import {Modal, ModalBody} from 'elemental';
import Loader from './loader';

class ModalLoader extends React.Component {
  static propTypes = {
    loaded: React.PropTypes.bool.isRequired
  }

  static defaultProps = {
    loaded: true
  }

  _renderLoading() {
    return (
      <Modal {...this.props}>
        <ModalBody>
          <Loader loaded={this.props.loaded} />
        </ModalBody>
      </Modal>
    );
  }

  _renderLoaded() {
    return (
      <Modal {...this.props}>
        {this.props.children}
      </Modal>
    );
  }

  render() {
    return this.props.loaded ? this._renderLoaded() : this._renderLoading();
  }
}

export default ModalLoader;

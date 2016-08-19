import React from 'react';
import Collapse from 'react-collapse';
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
        <Collapse isOpened={true}>
          <ModalBody>
            <Loader loaded={this.props.loaded} />
          </ModalBody>
        </Collapse>
      </Modal>
    );
  }

  _renderLoaded() {
    return (
      <Modal {...this.props}>
        <Collapse isOpened={true}>
          {this.props.children}
        </Collapse>
      </Modal>
    );
  }

  render() {
    return this.props.loaded ? this._renderLoaded() : this._renderLoading();
  }
}

export default ModalLoader;

import React from 'react';
import {TransitionMotion} from 'react-motion';
import Enum from '../../utils/enum';

const ItemState = new Enum([
  'ENTERING',
  'RESTING',
  'LEAVING'
]);

class StaggeredList extends React.Component {
  static propTypes = {
    chainedStyles: React.PropTypes.any,
    isResting: React.PropTypes.func
  }

  static defaultProps = {
    chainedStyles:  _ => [],
    isResting: _ => false
  }

  _indexate = (styles) => {
    const fixedStyles = styles || []
    return fixedStyles.map((config, i) => {
      const state = this.props.isResting(config) && ItemState.RESTING || ItemState.ENTERING;
      return {
        key: config.key,
        data: Object.assign({}, config.data, {__index__: i, __state__: state}),
        style: config.style
      };
    });
  }

  _getStyles = (prevStyles) => {
    // Prepare styles
    let targetStyles;
    if (Array.isArray(this.props.styles)) targetStyles = this.props.styles;
    else targetStyles = this.props.styles(prevStyles);
    targetStyles = this._indexate(targetStyles);

    // Prepare prevStyles
    const prevIndexed = this._indexate(prevStyles);
    const prevEntering = prevIndexed.filter(config => config.data.__state__ == ItemState.ENTERING);
    const prevResting = prevIndexed.filter(config => config.data.__state__ == ItemState.RESTING);
    const prevLeaving = prevIndexed.filter(config => config.data.__state__ == ItemState.LEAVING);

    // Combine user prev with ours
    if (targetStyles.length == prevIndexed.length) {
      const userPrevStyles = this.props.chainedStyles(prevEntering);
      userPrevStyles.forEach(config => {
        targetStyles[config.data.__index__].style = config.style;
      });
    }

    return targetStyles;
  }

  render() {
    const props = {...this.props, styles: this._getStyles}
    return (
      <TransitionMotion {...props}>
        {this.props.children}
      </TransitionMotion>
    );
  }
}

export default StaggeredList;

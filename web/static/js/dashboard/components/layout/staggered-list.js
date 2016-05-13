import React from 'react';
import {TransitionMotion, spring, presets} from 'react-motion';

class StaggeredList extends React.Component {
  static propTypes = {
    children: React.PropTypes.func.isRequired,
    spring: React.PropTypes.func,
    willEnter: React.PropTypes.func.isRequired,
    willRest: React.PropTypes.func.isRequired,
    willLeave: React.PropTypes.func.isRequired,
    styles: React.PropTypes.array.isRequired
  }

  static defaultProps = {
    spring: x => spring(x, presets.stiff)
  }

  _mapSpring = (styles) => {
    let copy = Object.assign({}, styles);
    Object.keys(copy).forEach(key => {
      copy[key] = this.props.spring(copy[key])
    });
    return copy;
  }

  _willLeave = () => {
    return this._mapSpring(this.props.willLeave());
  }

  _getStyles = (prevStyles) => {
    let targetStyles = this.props.styles.map(config => {
      return {
        key: config.key,
        data: Object.assign({__mounted__: false}, config.data),
        style: this._mapSpring(this.props.willRest())
      };
    });

    if (prevStyles.length == targetStyles.length) {
      prevStyles.forEach((_, i) => {
        // Interpolate previoues styles
        targetStyles[i].data.__mounted__ = prevStyles[i].data.__mounted__;
        if (prevStyles[i - 1] && !targetStyles[i].data.__mounted__) {
          Object.keys(prevStyles[i - 1].style).forEach(key => {
            targetStyles[i].style[key] = this.props.spring(prevStyles[i - 1].style[key]);
          });
        }
        // Check if element finished interpolation
        let finished = true;
        Object.keys(prevStyles[i].style).forEach(key => {
          if (prevStyles[i].style[key] != this.props.willRest()[key])
            finished = false;
        });
        targetStyles[i].data.__mounted__ = finished;
      });
    }

    console.log(this.props);
    return targetStyles;
  }

  render() {
    return (
      <TransitionMotion
        willEnter={this.props.willEnter}
        willLeave={this._willLeave}
        defaultStyles={this.props.styles}
        styles={this._getStyles}>
        {this.props.children}
      </TransitionMotion>
    );
  }
}

export default StaggeredList;

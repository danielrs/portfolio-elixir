import React from 'react';

class DocumentTitle extends React.Component {
  static propTypes = {
    title: React.PropTypes.string.isRequired,
    suffix: React.PropTypes.string.isRequired,
    component: React.PropTypes.node
  }

  static defaultProps = {
    suffix: ' | Dashboard',
    component: 'div'
  }

  render() {
    document.title = this.props.title + this.props.suffix;
    if (React.Children.count(this.props.children) == 1)
      return React.Children.only(this.props.children);
    else if (React.Children.count(this.props.children) > 1)
      return React.createElement(this.props.component, {}, this.props.children);
    else
      return null;
  }
}

export default DocumentTitle;

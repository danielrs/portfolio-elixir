import React from 'react';

class SessionLayoutView extends React.Component {
  render() {
    return (
      <div className="dashboard">
        {this.props.children}
      </div>
    );
  }
}

export default SessionLayoutView;

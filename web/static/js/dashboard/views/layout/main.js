import React from 'react';

class MainLayoutView extends React.Component {
  render() {
    return (
      <div className="dashboard">
        <header className="primary-header"></header>
        <aside className="primary-aside"></aside>
        <main role="main">
          {this.props.children}
        </main>
      </div>
    );
  }
}

export default MainLayoutView;

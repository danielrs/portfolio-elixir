import React from 'react';
import {Link} from 'react-router';

class HomeIndexView extends React.Component {
  render() {
    return (
      <div>
        <Link to="/dashboard/projects">Projects</Link>
      </div>
    );
  }
}

export default HomeIndexView;

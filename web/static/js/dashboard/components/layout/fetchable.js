import React from 'react';
import {Spinner} from 'elemental';

class Fetchable extends React.Component {
  renderFetching() {
    return <Spinner size="md" className="Spinner--main" />
  }

  render() {
    if (this.props.fetching)
      return this.renderFetching();
    else
      return this.renderFetched();
  }
}

export default Fetchable;

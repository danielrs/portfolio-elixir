import React from 'react';
import {connect} from 'react-redux';
import {Pill} from 'elemental';
import Actions from '../../actions/project';

class ProjectDeleteUndo extends React.Component {
  static propTypes = {
    project: React.PropTypes.object.isRequired
  }

  _handleClick = e => {
    const {dispatch} = this.props;
    dispatch(Actions.undoDelete({project: this.props.project}));
  }

  _handleClear = e => {
    const {dispatch} = this.props;
    dispatch(Actions.undoReset());
  }

  _renderUndo() {
    return (
      <Pill
        type="primary"
        onClick={this._handleClick}
        label={`Undo '${this.props.project.title}' delete`}
        onClear={this._handleClear} />
    );
  }

  render() {
    return this.props.project.id ? this._renderUndo() : null;
  }
}

const mapStateToProps = function(state) {
  return {project: state.project.deleted};
}

export default connect(mapStateToProps)(ProjectDeleteUndo);

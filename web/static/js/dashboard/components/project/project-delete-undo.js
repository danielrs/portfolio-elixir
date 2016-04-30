import React from 'react';
import {connect} from 'react-redux';
import {Pill} from 'elemental';
import Actions from '../../actions/project';

class ProjectDeleteUndo extends React.Component {
  render() {
    if (this.props.project && this.props.project.id) return this._renderUndo();
    else return this._renderDisabled();
  }

  _handleClick = (e) => {
    const {dispatch} = this.props;
    dispatch(Actions.undoDelete(this.props.project));
  }

  _renderUndo() {
    return (
      <div>
        <span>Project {this.props.project.title} was deleted </span>
        <Pill onClick={this._handleClick} label="Undo" />
      </div>
    );
  }

  _renderDisabled() {
    return false;
  }
}

const mapStateToProps = function(state) {
  return {project: state.project.deletedProject};
}

export default connect(mapStateToProps)(ProjectDeleteUndo);

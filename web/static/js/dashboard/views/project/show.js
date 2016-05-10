import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import Constants from '../../constants';
import Actions from '../../actions/project';
import {Button, Modal, ModalHeader, ModalBody, ModalFooter} from 'elemental';

class ProjectShowView extends React.Component {
  state = {
    isOpen: false
  }

  componentDidMount() {
    this.fetchProject();
    this.setState({isOpen: true});
  }

  componentDidUpdate(prevProps) {
    if (this.props.params.id != prevProps.params.id)
      this.fetchProject();
  }

  fetchProject() {
    const {dispatch} = this.props;
    dispatch(Actions.fetchProject(this.props.params.id));
  }

  render() {
    return (
      <Modal isOpen={this.state.isOpen}>
        <ModalHeader text={this.props.project.title} showCloseButton onClose={this._handleClose} />
        <ModalBody>
        </ModalBody>
        <ModalFooter>
        </ModalFooter>
      </Modal>
    );
    return (
      <div className="project">
        <h1>{this.props.title}</h1>
        <p>{this.props.description}</p>
        <a href={this.props.homepage}>Visit homepage</a>
        <div className="project__content">
          {this.props.content}
        </div>
        <Link to={"/dashboard/projects/" + this.props.params.id + "/edit"}>
          Edit
        </Link>
      </div>
    );
  }
}

const mapStateToProps = function(state) {
  return state.project.focused;
};

export default connect(mapStateToProps)(ProjectShowView);

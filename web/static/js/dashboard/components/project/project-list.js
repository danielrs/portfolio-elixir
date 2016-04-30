import React from 'react';
import {connect} from 'react-redux';
import {push} from 'react-router-redux';
import {Link} from 'react-router';
import Actions from '../../actions/project';
import {Button, Dropdown, Glyph, Table, Row, Col, Card} from 'elemental';
import Enum from '../../utils/enum';
import ReactCSSTransitionGroup from 'react-addons-css-transition-group';

const projectSpec = React.PropTypes.shape({
  id: React.PropTypes.number.isRequired,
  title: React.PropTypes.string.isRequired,
  description: React.PropTypes.string.isRequired,
  homepage: React.PropTypes.string.isRequired,
  content: React.PropTypes.string,
  date: React.PropTypes.any.isRequired
});

class ProjectListItem extends React.Component {

  static propTypes = {
    project: projectSpec
  }

  _handleEdit = (e) => {
    const {dispatch} = this.props;
    dispatch(push(`/dashboard/projects/${this.props.project.id}/edit`));
  }

  _handleDelete = (e) => {
    const {dispatch} = this.props;
    dispatch(Actions.deleteProject(this.props.project.id, this.props.project));
  }

  render() {
    return (
      <Card key={this.props.project.id} className="project-card">
        <div className="project-card__header">
          <Link to={'/dashboard/projects/' + this.props.project.id}>{this.props.project.title}</Link>
          <span className="project-card__date">
            {this.props.project.date}
          </span>
        </div>
        <div className="project-card__body">
          {this.props.project.description}
        </div>
        <div className="project-card__footer">
          <Button type="link-primary" onClick={this._handleEdit}><Glyph icon="pencil" /></Button>
          <Button type="link-danger" onClick={this._handleDelete}><Glyph icon="trashcan" /></Button>
        </div>
      </Card>
    );
  }
}

class ProjectList extends React.Component {
  static propTypes = {
    projects: React.PropTypes.arrayOf(projectSpec)
  }

  componentDidMount() {
    const {dispatch} = this.props;
    dispatch(Actions.fetchProjects());
  }

  render() {
    return (
      <div className="project-list">
        <ReactCSSTransitionGroup
          transitionName="project-card-animation"
          transitionAppear={true}
          transitionEnterTimeout={500}
          transitionLeaveTimeout={250}
          transitionAppearTimeout={250}
          >
          {this.props.projects.map(this._renderProject)}
        </ReactCSSTransitionGroup>
      </div>
    );
  }

  _renderProject = (project) => {
    return (
      <ProjectListItem dispatch={this.props.dispatch} key={project.id} project={project} />
    );
  }
}

const mapStateToProps = (state) => {
  return state.project;
}

export default connect(mapStateToProps)(ProjectList);

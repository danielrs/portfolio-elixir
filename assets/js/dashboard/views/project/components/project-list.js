import React from 'react';
import {push} from 'react-router-redux';
import {Link} from 'react-router';
import Actions from '../../../actions/project';
import {Button, Dropdown, Glyph, Table, Row, Col, Card} from 'elemental';
import {TransitionMotion, spring, presets} from 'react-motion';
import StaggeredList from '../../../components/layout/staggered-list';

import Project from '../../../proptypes/project';

class ProjectListItem extends React.Component {

  static propTypes = {
    project: Project,
  }

  _handleShow = e => {
    const {dispatch} = this.props;
    dispatch(Actions.showProject(this.props.project.id));
  }

  _handleEdit = (e) => {
    const {dispatch} = this.props;
    dispatch(Actions.editProject(this.props.project.id));
  }

  _handleDelete = (e) => {
    const {dispatch} = this.props;
    dispatch(Actions.deleteProject(this.props.project.id, this.props.project));
  }

  render() {
    return (
      <Card
        key={this.props.project.id} className="project-card" style={this.props.style} >
        <div className="project-card__body" onClick={this._handleShow}>
          <h3 className="project-card__title">{this.props.project.title}</h3>
          <span className="project-card__date">{this.props.project.date}</span>
          <p>{this.props.project.description}</p>
        </div>
        <div className="project-card__footer">
          <Button type="link" onClick={this._handleEdit}>Edit</Button>
          <Button type="link-danger" onClick={this._handleDelete}>Delete</Button>
        </div>
      </Card>
    );
  }
}

class ProjectList extends React.Component {
  static propTypes = {
    projects: React.PropTypes.arrayOf(Project)
  }

  static defaultProps = {
    projects: []
  }

  _willEnter = () => {
    return {opacity: 0, offset: 100};
  }

  _willLeave = () => {
    return {opacity: spring(0, presets.stiff), offset: spring(100, presets.stiff)};
  }

  _defaultStyles() {
    return this.props.projects.map(project => {
      return {
        key: project.id.toString(),
        style: {opacity: 0, offset: 100}
      };
    });
  }

  _styles = () => {
    return this.props.projects.map(project => {
      return {
        key: project.id.toString(),
        data: project,
        style: {opacity: spring(1, presets.stiff), offset: spring(0, presets.stiff)}
      };
    });
  }

  _chainedStyles = (prevStyles) => {
    return prevStyles.map((config, i) => {
      return {
        ...config,
        style: i === 0
          ? {opacity: spring(1, presets.stiff), offset: spring(0, presets.stiff)}
          : {
            opacity: spring(prevStyles[i - 1].style.opacity, presets.stiff),
            offset: spring(prevStyles[i - 1].style.offset, presets.stiff)
          }
      };
    });
  }

  render() {
    return (
      <StaggeredList
        willEnter={this._willEnter}
        isResting={config => {
          return config.style.opacity == 1 && config.style.offset == 0
        }}
        willLeave={this._willLeave}
        defaultStyles={this._defaultStyles()}
        styles={this._styles()}
        chainedStyles={this._chainedStyles}>
        {interpolatedStyles =>
          <div className="project-list">
            {interpolatedStyles.map(this._renderProject)}
          </div>
        }
      </StaggeredList>
    );
  }

  _renderProject = (config) => {
    return (
      <ProjectListItem
        key={config.key}
        dispatch={this.props.dispatch}
        project={config.data}
        style={{...config.style, transform: `translateY(${config.style.offset}px)`}} />
    );
  }
}

export default ProjectList;

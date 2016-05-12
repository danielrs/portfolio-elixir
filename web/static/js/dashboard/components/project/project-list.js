import React from 'react';
import {push} from 'react-router-redux';
import {Link} from 'react-router';
import Actions from '../../actions/project';
import {Button, Dropdown, Glyph, Table, Row, Col, Card} from 'elemental';
import Enum from '../../utils/enum';
import {TransitionMotion, spring, presets} from 'react-motion';

const projectSpec = React.PropTypes.shape({
  index: React.PropTypes.number.isRequired,
  id: React.PropTypes.number.isRequired,
  title: React.PropTypes.string.isRequired,
  description: React.PropTypes.string.isRequired,
  homepage: React.PropTypes.string.isRequired,
  content: React.PropTypes.string,
  date: React.PropTypes.any.isRequired
});

class ProjectListItem extends React.Component {

  static propTypes = {
    project: projectSpec,
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
      <Card
        key={this.props.project.id} className="project-card" style={this.props.style} >
        <div className="project-card__body">
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
    projects: React.PropTypes.arrayOf(projectSpec),
    springConfig: React.PropTypes.any
  }

  static defaultProps = {
    projects: [],
    springConfig: presets.stiff
  }

  componentDidMount() {
    this.setState({mounted: false});
  }

  spring(x) {
    return spring(x, this.props.springConfig);
  }

  _willEnter() {
    return {opacity: 0, offset: 100};
  }

  _willLeave = () => {
    return {opacity: this.spring(0), offset: this.spring(100)};
  }

  _getDefaultStyles = () => {
    let defaultStyles = [];
    this.props.projects.forEach((project, i) => {
      defaultStyles[i] = {
        key: project.id.toString(),
        data: {...project, _rested: false},
        style: this._willEnter()
      };
    });
    return defaultStyles;
  }

  _targetStyle = {
    opacity: 1,
    offset: 0
  }

  _getStyles = (prevStyles) => {
    let targetStyles = this._getDefaultStyles().map(config => {
      return {
        ...config,
        style: {opacity: this.spring(this._targetStyle.opacity), offset: this.spring(this._targetStyle.offset)}
      };
    });

    if (prevStyles.length == targetStyles.length) {
      prevStyles.forEach((_, i) => {
        targetStyles[i].data._rested = prevStyles[i].data._rested;
        if (prevStyles[i - 1] && !targetStyles[i].data._rested) {
          targetStyles[i].style = {
            opacity: this.spring(prevStyles[i - 1].style.opacity),
            offset: this.spring(prevStyles[i - 1].style.offset)
          };
        }
        if (prevStyles[i].style.opacity == this._targetStyle.opacity
            && prevStyles[i].style.offset == this._targetStyle.offset) {
          targetStyles[i].data._rested = true;
        }
      });
    }

    return targetStyles;
  }

  render() {

    return (
      <TransitionMotion
        willEnter={this._willEnter}
        willLeave={this._willLeave}
        defaultStyles={this._getDefaultStyles()}
        styles={this._getStyles}>
        {function(interpolatedStyles) {
          return (
            <div className="project-list">
              {interpolatedStyles.map(this._renderProject)}
            </div>
          );
        }.bind(this)}
      </TransitionMotion>
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

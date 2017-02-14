import React from 'react';
import {push} from 'react-router-redux';
import {Link} from 'react-router';
import Actions from '../../../actions/post';

import {Button, Dropdown, Glyph, Table, Row, Col, Card} from 'elemental';
import {TransitionMotion, spring, presets} from 'react-motion';
import StaggeredList from '../../../components/layout/staggered-list';

const postSpec = React.PropTypes.shape({
  id: React.PropTypes.number.isRequired,
  title: React.PropTypes.string.isRequired,
  slug: React.PropTypes.string.isRequired,
  description: React.PropTypes.string,
  markdown: React.PropTypes.string,
  html: React.PropTypes.string.isRequired,
  date: React.PropTypes.any.isRequired,
  user: React.PropTypes.object.isRequired,
  tags: React.PropTypes.array,
  'published?': React.PropTypes.bool.isRequired,
});

class PostListItem extends React.Component {

  static propTypes = {
    post: postSpec,
  }

  _handleShow = e => {
    const {dispatch} = this.props;
    dispatch(Actions.showPost(this.props.post.id));
  }

  _handleEdit = (e) => {
    const {dispatch} = this.props;
    dispatch(Actions.editPost(this.props.post.id));
  }

  // _handleDelete = (e) => {
  //   const {dispatch} = this.props;
  //   dispatch(Actions.deleteProject(this.props.project.id, this.props.project));
  // }

  render() {
    return (
      <div key={this.props.post.id} className="post-item">
        <h4>{this.props.post.title}</h4>
        <Button type="link" onClick={this._handleShow}>Show</Button>
        <Button type="link" onClick={this._handleEdit}>Edit</Button>
      </div>
    );
  }
}

class PostList extends React.Component {
  static propTypes = {
    posts: React.PropTypes.arrayOf(postSpec)
  }

  static defaultProps = {
    posts: []
  }

  // _willEnter = () => {
  //   return {opacity: 0, offset: 100};
  // }

  // _willLeave = () => {
  //   return {opacity: spring(0, presets.stiff), offset: spring(100, presets.stiff)};
  // }

  // _defaultStyles() {
  //   return this.props.projects.map(project => {
  //     return {
  //       key: project.id.toString(),
  //       style: {opacity: 0, offset: 100}
  //     };
  //   });
  // }

  // _styles = () => {
  //   return this.props.projects.map(project => {
  //     return {
  //       key: project.id.toString(),
  //       data: project,
  //       style: {opacity: spring(1, presets.stiff), offset: spring(0, presets.stiff)}
  //     };
  //   });
  // }

  // _chainedStyles = (prevStyles) => {
  //   return prevStyles.map((config, i) => {
  //     return {
  //       ...config,
  //       style: i === 0
  //         ? {opacity: spring(1, presets.stiff), offset: spring(0, presets.stiff)}
  //         : {
  //           opacity: spring(prevStyles[i - 1].style.opacity, presets.stiff),
  //           offset: spring(prevStyles[i - 1].style.offset, presets.stiff)
  //         }
  //     };
  //   });
  // }

  render() {
    return (
      <div key={this.props.posts}>
        {this.props.posts.map(post => {
          return this._renderPost(post)
        })}
      </div>
    );
  }

  _renderPost = (post) => {
    return (
      <PostListItem
        key={post.id.toString()}
        dispatch={this.props.dispatch}
        post={post} />
    );
  }
}

export default PostList;

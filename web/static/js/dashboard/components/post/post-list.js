import React from 'react';
import {push} from 'react-router-redux';
import {Link} from 'react-router';
import Actions from '../../actions/post';
import ReactCSSTransitionGroup from 'react-addons-css-transition-group';
import {Button, Dropdown, Glyph, Table} from 'elemental';

const postSpec = React.PropTypes.shape({
  index: React.PropTypes.number.isRequired,
  id: React.PropTypes.number.isRequired,
  title: React.PropTypes.string.isRequired,
  slug: React.PropTypes.string.isRequired,
  markdown: React.PropTypes.string,
  html: React.PropTypes.string.isRequired,
  date: React.PropTypes.any.isRequired,
  published: React.PropTypes.bool.isRequired
});

class PostListItem extends React.Component {

  static propTypes = {
    post: postSpec
  }

  _handleEdit = (e) => {
    const {dispatch} = this.props;
    dispatch(push(`/dashboard/posts/${this.props.post.id}/edit`));
  }

  _handleDelete = (e) => {
    const {dispatch} = this.props;
    dispatch(Actions.deletePost(this.props.post.id, this.props.post));
  }

  render() {
    return (
      <tr key={this.props.post.id}>
        <td><Link to={'/dashboard/posts' +  this.props.post.id}>{this.props.post.title}</Link></td>
        <td>{this.props.post.date}</td>
        <td>{this.props.post.published ? "published" : "not published"}</td>
        <td>
          <Button type="link">Edit</Button>
          <Button type="link-cancel">Cancel</Button>
        </td>
      </tr>
    );
  }
}

class PostList extends React.Component {
  static propTypes = {
    posts: React.PropTypes.arrayOf(postSpec)
  }

  render() {
    return (
      <Table className="post-list">
        <thead>
          <tr>
            <th>Title</th>
            <th>Date</th>
            <th>Published?</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {this.props.posts.map(this._renderPost)}
        </tbody>
      </Table>
    );
  }

  _renderPost = (post) => {
    return (
      <PostListItem dispatch={this.props.dispatch} key={post.id} post={post} />
    );
  }
}

export default PostList;

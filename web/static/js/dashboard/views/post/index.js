import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import Constants from '../../constants';
import Actions from '../../actions/post';
import {Button, Dropdown, Glyph, Table} from 'elemental';
import Enum from '../../utils/enum';
import PostList from '../../components/post/post-list';
// import ProjectDeleteUndo from '../../components/project/project-delete-undo.js';
import Loader from '../../components/layout/loader';

class PostIndexView extends React.Component {
  componentDidMount() {
    const {dispatch} = this.props;
    dispatch(Actions.fetchPosts());
  }

  _post_markup(post) {
    return {__html: post.html};
  }

  render() {
    return (
      <div>
        <div className="header-content">
          <Button component={<Link to="/dashboard/posts/new"/>} type="hollow-primary" size="sm">
            <Glyph icon="plus" />
            {' '}
            Create post
          </Button>
        </div>
        <div className="main-container">
          <Loader loaded={this.props.loaded}>
            <PostList dispatch={this.props.dispatch} posts={this.props.posts} />
          </Loader>
        </div>
        {this.props.children}
      </div>
    );
  }

  _render_post(post) {
    return (
      <div key={post.id} class="post">
        <h1>{post.title}</h1>
        <div dangerouslySetInnerHTML={this._post_markup(post)} />
      </div>
    );
  }
}

const mapStateToProps = function(state) {
  return state.post;
};

export default connect(mapStateToProps)(PostIndexView);

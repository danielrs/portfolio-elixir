import React from 'react';
import {Link} from 'react-router';
import {connect} from 'react-redux';
import Constants from '../../constants';
import Actions from '../../actions/post';
import {Button, Dropdown, Glyph, Table} from 'elemental';
import Enum from '../../utils/enum';
// import ProjectList from '../../components/project/project-list';
// import ProjectDeleteUndo from '../../components/project/project-delete-undo.js';

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
          {this.props.posts.map(::this._render_post)}
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

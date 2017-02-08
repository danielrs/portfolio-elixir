import React from 'react';
import {connect} from 'react-redux';
import {Button, Dropdown, Glyph, Table, Spinner} from 'elemental';

import Constants from '../../constants';
import Actions from '../../actions/post';
import Loader from '../../components/layout/loader';
import DocumentTitle from '../../components/layout/document-title';
import FilterForm from '../../components/layout/filter-form';

// import ProjectDeleteUndo from '../../components/project/project-delete-undo.js';
import PostList from './components/post-list';

const sortOptions = [
  {label: 'Date', value: 'date'},
  {label: 'Title', value: 'title'},
];

class PostIndexView extends React.Component {
  _handleNewPostClick = () => {
    const {dispatch} = this.props;
    dispatch(Actions.newPost());
  }

  _handleFilterChange = filter => {
    const {dispatch} = this.props;
    dispatch(Actions.filterPosts(filter));
  }

  _handleFilterSubmit = e => {
    e.preventDefault();
    const {dispatch} = this.props;
    dispatch(Actions.filterPosts(this.props.filter));
  }

  render() {
    return (
      <DocumentTitle title="Posts">
        <div className="header-content">
          <Button type="hollow-primary" size="sm" onClick={this._handleNewPostClick}>
            <Glyph icon="plus" />
            {' '}
            New post
          </Button>
          <FilterForm
            sortOptions={sortOptions}
            onLoad={this._handleFilterChange}
            onFilterChange={this._handleFilterChange}
            onSubmit={this._handleFilterSubmit} noSearch noSubmit />
        </div>
        <Loader loaded={this.props.loaded}>
          <PostList dispatch={this.props.dispatch} posts={this.props.posts} />
        </Loader>
        {this.props.children}
      </DocumentTitle>
    );
  }
}

const mapStateToProps = function(state) {
  return state.post;
};

export default connect(mapStateToProps)(PostIndexView);

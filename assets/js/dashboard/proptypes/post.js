import React from 'react';

export default React.PropTypes.shape({
  title: React.PropTypes.string,
  slug: React.PropTypes.string,
  description: React.PropTypes.string,
  date: React.PropTypes.any,
  markdown: React.PropTypes.string,
  html: React.PropTypes.string,
  'published?': React.PropTypes.bool,

  user: React.PropTypes.shape({
    name: React.PropTypes.string,
    email: React.PropTypes.string,
    role: React.PropTypes.shape({
      name: React.PropTypes.string
    })
  }),

  tags: React.PropTypes.arrayOf(React.PropTypes.shape({
    name: React.PropTypes.string
  }))
});

import React from 'react';

export default React.PropTypes.shape({
  title: React.PropTypes.string,
  description: React.PropTypes.string,
  homepage: React.PropTypes.string,
  content: React.PropTypes.string,
  date: React.PropTypes.any,

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

import React from 'react';
import {DateField} from 'react-date-picker';
import {renderErrorsFor, dateToISO8601} from '../../../utils';
import {Form, FormField, FormInput, Checkbox} from 'elemental';
import Post from '../../../proptypes/post';

class PostForm extends React.Component {

  static propTypes = {
    post: Post,
    errors: React.PropTypes.object,
    onChange: React.PropTypes.func.isRequired
  }

  static defaultProps = {
    post: {},
    errors: {},
    onChange: function() {},
  }

  // We don't use state for date since we need to be updated immediately (state updates after render step)
  date = this.props.post.date || dateToISO8601(new Date())

  getFormData() {
    const data = {
      post: {
        title: this.refs.title.refs.input.value,
        slug: this.refs.slug.refs.input.value,
        description: this.refs.description.refs.input.value,
        date: this.date,
        markdown: this.refs.markdown.refs.input.value,
        'published?': this.refs['published?'].refs.target.checked
      },
      tags: this._asTaglist(this.refs.tags.refs.input.value)
    };
    return data;
  }

  _asTaglist(string) {
    return string.split(/,\s*/).filter(tag => tag.length > 0);
  }

  _asTagString(taglist) {
    if (taglist && Array.isArray(taglist)) {
      return taglist.map(tag => tag.name);
    }
    else {
      return '';
    }
  }

  _handleChange = (e) => {
    this.props.onChange(e);
  }

  _handleDateChange = (date) => {
    this.date = date;
    this._handleChange(date);
  }

  render() {
    return (
      <Form className="post--edit" key={this.props.post.id}>
        <FormField className={this.props.errors.title ? 'is-invalid' : ''}>
          <FormInput
            type="text"
            ref="title"
            name="title"
            placeholder="Title*"
            onChange={this._handleChange}
            defaultValue={this.props.post.title} />
          {renderErrorsFor(this.props.errors, 'title')}
        </FormField>

        <FormField className={this.props.errors.slug ? 'is-invalid' : ''}>
          <FormInput
            type="text"
            ref="slug"
            name="slug"
            placeholder="Slug"
            onChange={this._handleChange}
            defaultValue={this.props.post.slug} />
          {renderErrorsFor(this.props.errors, 'slug')}
        </FormField>

        <FormField className={this.props.errors.description ? 'is-invalid' : ''}>
          <FormInput
            type="text"
            ref="description"
            name="description"
            placeholder="Description"
            onChange={this._handleChange}
            defaultValue={this.props.post.description} />
          {renderErrorsFor(this.props.errors, 'description')}
        </FormField>

        <FormField className={this.props.errors.tags ? 'is-invalid' : ''}>
          <FormInput
            type="text"
            ref="tags"
            name="tags"
            placeholder="Tags separated by comma"
            onChange={this._handleChange}
            defaultValue={this._asTagString(this.props.post.tags)} />
          {renderErrorsFor(this.props.errors, 'tags')}
        </FormField>

        <FormField className={this.props.errors.date ? 'is-invalid' : ''}>
          <DateField
            ref="date"
            defaultValue={this.date}
            dateFormat="YYYY-MM-DD"
            onChange={this._handleDateChange}
            forceValidDate />
          {renderErrorsFor(this.props.errors, 'date')}
        </FormField>

        <FormField className={this.props.errors.markdown ? 'is-invalid' : ''}>
          <FormInput
            type="text"
            ref="markdown"
            name="markdown"
            placeholder="Markdown"
            onChange={this._handleChange}
            defaultValue={this.props.post.markdown}
            multiline />
          {renderErrorsFor(this.props.errors, 'markdown')}
        </FormField>

        <FormField>
          <Checkbox
            label="Published"
            ref="published?"
            name="published?"
            onChange={this._handleChange}
            defaultChecked={this.props.post["published?"]} />
        </FormField>
      </Form>
    );
  }
}

export default PostForm;

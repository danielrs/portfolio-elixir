import React from 'react';
import DatePicker from 'react-date-picker';
import {renderErrorsFor, dateToISO8601} from '../../../utils';
import {Form, FormField, FormInput, Checkbox} from 'elemental';

class PostForm extends React.Component {

  static propTypes = {
    post: React.PropTypes.shape({
      title: React.PropTypes.string,
      slug: React.PropTypes.string,
      markdown: React.PropTypes.string,
      date: React.PropTypes.any,
      'published?': React.PropTypes.bool,
    }),
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
        markdown: this.refs.markdown.refs.input.value,
        date: this.date,
        'published?': this.refs['published?'].refs.target.checked,
      }
    };
    return data;
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
      <Form key={this.props.post.id}>
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

        <FormField className={this.props.errors.date ? 'is-invalid' : ''}>
          <DatePicker ref="date" defaultDate={this.date} onChange={this._handleDateChange} />
          {renderErrorsFor(this.props.errors, 'date')}
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

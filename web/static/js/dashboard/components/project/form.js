import React from 'react';
import DatePicker from 'react-date-picker';
import {renderErrorsFor, dateToISO8601} from '../../utils';
import {Form, FormField, FormInput} from 'elemental';

class ProjectForm extends React.Component {

  static propTypes = {
    project: React.PropTypes.shape({
      title: React.PropTypes.string,
      description: React.PropTypes.string,
      homepage: React.PropTypes.string,
      content: React.PropTypes.string,
      date: React.PropTypes.any,
    }),
    errors: React.PropTypes.object,
    onChange: React.PropTypes.func.isRequired
  }

  static defaultProps = {
    project: {},
    errors: {},
    onChange: function() {},
  }

  // We don't use state for date since we need to be updated immediately (state updates after render step)
  date = dateToISO8601(new Date())

  getFormData() {
    const data = {
      project: {
        title: this.refs.title.refs.input.value,
        description: this.refs.description.refs.input.value,
        homepage: this.refs.homepage.refs.input.value,
        content: this.refs.content.refs.input.value,
        date: this.date
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
      <Form key={this.props.project.id}>
        <FormField className={this.props.errors.title ? 'is-invalid' : ''}>
          <FormInput
            type="text"
            ref="title"
            name="title"
            placeholder="Title*"
            onChange={this._handleChange}
            defaultValue={this.props.project.title} />
          {renderErrorsFor(this.props.errors, 'title')}
        </FormField>
        <FormField className={this.props.errors.description ? 'is-invalid' : ''}>
          <FormInput
            type="text"
            ref="description"
            name="description"
            placeholder="Description*"
            onChange={this._handleChange}
            defaultValue={this.props.project.description} />
          {renderErrorsFor(this.props.errors, 'description')}
        </FormField>
        <FormField className={this.props.errors.homepage ? 'is-invalid' : ''}>
          <FormInput
            type="text"
            ref="homepage"
            name="homepage"
            placeholder="URL*"
            onChange={this._handleChange}
            defaultValue={this.props.project.homepage} />
          {renderErrorsFor(this.props.errors, 'homepage')}
        </FormField>
        <FormField className={this.props.errors.content ? 'is-invalid' : ''}>
          <FormInput
            type="text"
            ref="content"
            name="content"
            placeholder="Content"
            onChange={this._handleChange}
            defaultValue={this.props.project.content}
            multiline />
          {renderErrorsFor(this.props.errors, 'content')}
        </FormField>
        <FormField className={this.props.errors.date ? 'is-invalid' : ''}>
          <DatePicker ref="date" defaultDate={this.props.project.date || this.date} onChange={this._handleDateChange} />
          {renderErrorsFor(this.props.errors, 'date')}
        </FormField>
      </Form>
    );
  }
}

export default ProjectForm;

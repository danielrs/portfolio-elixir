import React from 'react';
import {DateField} from 'react-date-picker';
import {renderErrorsFor, dateToISO8601} from '../../../utils';
import {Form, FormField, FormInput} from 'elemental';

import Project from '../../../proptypes/project';

class ProjectForm extends React.Component {

  static propTypes = {
    project: Project,
    errors: React.PropTypes.object,
    onChange: React.PropTypes.func.isRequired
  }

  static defaultProps = {
    project: {},
    errors: {},
    onChange: function() {},
  }

  // We don't use state for date since we need to be updated immediately (state updates after render step)
  date = this.props.project.date || dateToISO8601(new Date())

  getFormData() {
    const data = {
      project: {
        title: this.refs.title.refs.input.value,
        description: this.refs.description.refs.input.value,
        homepage: this.refs.homepage.refs.input.value,
        language: this.refs.language.refs.input.value,
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

        <FormField className={this.props.errors.date ? 'is-invalid' : ''}>
          <DateField
            ref="date"
            defaultValue={this.date}
            dateFormat="YYYY-MM-DD"
            onChange={this._handleDateChange}
            forceValidDate />
          {renderErrorsFor(this.props.errors, 'date')}
        </FormField>

        <FormField className={this.props.errors.language ? 'is-invalid' : ''}>
          <FormInput
            type="text"
            ref="language"
            name="language"
            placeholder="Language"
            onChange={this._handleChange}
            defaultValue={this.props.project.language} />
          {renderErrorsFor(this.props.errors, 'language')}
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
      </Form>
    );
  }
}

export default ProjectForm;

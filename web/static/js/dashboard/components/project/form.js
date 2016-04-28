import React from 'react';
import DatePicker from 'react-datepicker';
import moment from 'moment';
import {renderErrorsFor} from '../../utils';
import {Form, FormField, FormInput} from 'elemental';

class ProjectForm extends React.Component {

  static propTypes = {
    title: React.PropTypes.string,
    description: React.PropTypes.string,
    homepage: React.PropTypes.string,
    content: React.PropTypes.string,
    date: React.PropTypes.any,
    onChange: React.PropTypes.func.isRequired
  }

  static defaultProps = {
    onChange: function() {},
  }

  state = {changed: false, date: moment()}

  componentWillReceiveProps(nextProps) {
    this.setState({date: nextProps.date || moment()});
  }

  render() {
    return (
      <Form key={this.props.id}>
        <FormField>
          <FormInput
            type="text"
            ref="title"
            name="title"
            placeholder="Title"
            onChange={this._handleChange}
            defaultValue={this.props.title} />
        </FormField>
        <FormField>
          <FormInput
            type="text"
            ref="description"
            name="description"
            placeholder="Description"
            onChange={this._handleChange}
            defaultValue={this.props.description} />
        </FormField>
        <FormField>
          <FormInput
            type="text"
            ref="homepage"
            name="homepage"
            placeholder="URL"
            onChange={this._handleChange}
            defaultValue={this.props.homepage} />
        </FormField>
        <FormField>
          <FormInput
            type="text"
            ref="content"
            name="content"
            placeholder="Content"
            onChange={this._handleChange}
            defaultValue={this.props.content}
            multiline />
        </FormField>
        <FormField>
          <DatePicker ref="date" selected={this.state.date} onChange={this._handleDateChange} />
        </FormField>
      </Form>
    );
  }

  getFormData() {
    console.log(this.refs.title.refs.input.value);
    const data = {
      project: {
        title: this.refs.title.refs.input.value,
        description: this.refs.description.refs.input.value,
        homepage: this.refs.homepage.refs.input.value,
        content: this.refs.content.refs.input.value,
        date: this.state.date.format('YYYY-MM-DD')
      }
    };
    return data;
  }

  _handleChange = (e) => {
    this.props.onChange(e);
    this.setState({changed: true});
  }

  _handleDateChange = (date) => {
    this.setState({date: date});
  }
}

export default ProjectForm;

import React from 'react';
import DatePicker from 'react-datepicker';
import moment from 'moment';
import {renderErrorsFor} from '../../utils';

class ProjectFormView extends React.Component {
  static defaultProps = {
    handleChange: function() {}
  }

  state = {changed: false, date: moment()}

  componentWillReceiveProps(nextProps) {
    this.setState({date: nextProps.date});
  }

  render() {
    return (
      <fieldset key={this.props.id}>
        <legend>Project details</legend>
        <input type="text"
               ref="title"
               name="title"
               placeholder="Title"
               defaultValue={this.props.title}
               onChange={this._handleChange} />
        {renderErrorsFor(this.props.errors, 'title')}
        <input type="text"
               ref="description"
               name="description"
               placeholder="Description"
               defaultValue={this.props.description}
               onChange={this._handleChange} />
        {renderErrorsFor(this.props.errors, 'description')}
        <input type="text"
               ref="homepage"
               name="homepage"
               placeholder="Homepage URL"
               defaultValue={this.props.homepage}
               onChange={this._handleChange} />
        {renderErrorsFor(this.props.errors, 'homepage')}
        <textarea ref="content"
                  name="content"
                  placeholder="Content"
                  defaultValue={this.props.content}
                  onChange={this._handleChange} />
        {renderErrorsFor(this.props.errors, 'content')}
        <DatePicker ref="date"
                    selected={this.state.date}
                    onChange={this._handleDateChange} />
        {renderErrorsFor(this.props.errors, 'date')}
      </fieldset>
    );
  }

  getFormData() {
    const data = {
      project: {
        title: this.refs.title.value,
        description: this.refs.description.value,
        homepage: this.refs.homepage.value,
        content: this.refs.content.value,
        date: this.state.date.format('YYYY-MM-DD')
      }
    };
    return data;
  }

  _handleChange = (e) => {
    this.props.handleChange(e);
    this.setState({changed: true});
  }

  _handleDateChange = (date) => {
    this.setState({date: date});
  }
}

export default ProjectFormView;

import React from 'react';
import {Enum} from '../../utils';
import {Form, FormIconField, FormInput, FormSelect} from 'elemental';

const Order = new Enum(['ASC', 'DESC']);

const orderOptions = [
  {label: 'Asc', value: Order.ASC.toLowerCase()},
  {label: 'Desc', value: Order.DESC.toLowerCase()}
]

class FilterForm extends React.Component {
  static propTypes = {
    sortOptions: React.PropTypes.arrayOf(React.PropTypes.object.isRequired),
    onChange: React.PropTypes.func,
    onSubmit: React.PropTypes.func
  }

  static defaultProps = {
    sortOptions: [],
    onChange: state => undefined,
    onSubmit: e => undefined
  }

  state = {
    sort_by: this.props.sortOptions[0] && this.props.sortOptions[0].value || '',
    order: Order.ASC.toLowerCase(),
    search: ''
  }

  _handleSortChange = value => {
    const newState = {...this.state, sort_by: value};
    this.setState(newState);
    this.props.onChange(newState);
  }

  _handleOrderChange = value => {
    const newState = {...this.state, order: value};
    this.setState(newState);
    this.props.onChange(newState);
  }

  _handleSearchChange = e => {
    const newState = {...this.state, search: e.target.value};
    this.setState(newState);
    this.props.onChange(newState);
  }

  render() {
    const select = this.props.sortOptions.length > 0
     ? <FormSelect label="Sort" options={this.props.sortOptions} onChange={this._handleSortChange} />
    : null;
    return (
      <Form type="inline" onSubmit={this.props.onSubmit} className="search-form">
        {select}
        <FormSelect label="Order" options={orderOptions} onChange={this._handleOrderChange} />
        <FormIconField iconKey="search">
          <FormInput type="search" placeholder="Search" name="search" onChange={this._handleSearchChange} />
        </FormIconField>
      </Form>
    );
  }
}

export default FilterForm;

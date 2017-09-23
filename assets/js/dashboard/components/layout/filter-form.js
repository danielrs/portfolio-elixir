import React from 'react';
import {Enum} from '../../utils';
import {Button, Form, FormIconField, FormInput, FormSelect} from 'elemental';

const Order = new Enum(['DESC', 'ASC']);

const orderOptions = [
  {label: 'Desc', value: Order.DESC},
  {label: 'Asc', value: Order.ASC}
]

class FilterForm extends React.Component {
  static propTypes = {
    sortOptions: React.PropTypes.arrayOf(React.PropTypes.object.isRequired),
    onLoad: React.PropTypes.func,
    onChange: React.PropTypes.func,
    onFilterChange: React.PropTypes.func,
    onSubmit: React.PropTypes.func,
    // Options
    noSearch: React.PropTypes.bool,
    noSubmit: React.PropTypes.bool
  }

  static defaultProps = {
    sortOptions: [],
    onLoad: state => undefined,
    onChange: state => undefined,
    onFilterChange: state => undefined,
    onSubmit: e => undefined,
    noSearch: false,
    noSubmit: false
  }

  state = {
    order_by: this.props.sortOptions[0] && this.props.sortOptions[0].value || '',
    order: Order.DESC,
    search: ''
  }

  componentDidMount() {
    this.props.onLoad(this.state);
  }

  _formatState = state => {
    const direction = state.order == Order.ASC ? '+' : '-';
    return {
      order_by: direction + state.order_by,
      search: state.search
    };
  }

  _handleSortChange = value => {
    const newState = {...this.state, order_by: value};
    this.setState(newState);
    this.props.onChange(newState);
    this.props.onFilterChange(this._formatState(newState));
  }

  _handleOrderChange = value => {
    const newState = {...this.state, order: value};
    this.setState(newState);
    this.props.onChange(newState);
    this.props.onFilterChange(this._formatState(newState));
  }

  _handleSearchChange = e => {
    const newState = {...this.state, search: e.target.value};
    this.setState(newState);
    this.props.onChange(newState);
  }

  _handleSearchBlur = e => {
    const newState = {...this.state, search: e.target.value};
    this.setState(newState);
    this.props.onFilterChange(this._formatState(newState));
  }

  render() {
    const select = this.props.sortOptions.length > 0
      ? <FormSelect label="Sort" options={this.props.sortOptions} onChange={this._handleSortChange} />
      : null;
    const search = !this.props.noSearch
      ? (
        <FormIconField iconKey="search">
          <FormInput
            type="search"
            placeholder="Search"
            name="search"
            onChange={this._handleSearchChange}
            onBlur={this._handleSearchBlur} />
        </FormIconField>)
      : null;
    const submit = !this.props.noSubmit ? <Button submit>Search</Button> : null;

    return (
      <Form type="inline" onSubmit={this.props.onSubmit} className="search-form">
        {select}
        <FormSelect label="Order" options={orderOptions} onChange={this._handleOrderChange} />
        {search}
        {submit}
      </Form>
    );
  }
}

export default FilterForm;

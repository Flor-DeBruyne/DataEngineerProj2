import React from 'react';
import Select from 'react-select';

const Dropdown = ({ options, selectedOption, onChange }) => {
  return (
    <Select
      options={options}
      value={selectedOption}
      onChange={onChange}
      isClearable
      isSearchable
    />
  );
};

export default Dropdown;

import {React, useState} from 'react';
import DatePicker from './DatePicker'; // Adjust the path accordingly
import Dropdown from './Dropdown'; // Adjust the path accordingly


const Epic4Page = () => {
  const [selectedOption, setSelectedOption] = useState(null);
  const yourOptions = ['bruh', 'bruh']

    // Handle dropdown change
    const handleDropdownChange = (option) => {
      setSelectedOption(option);
      // Perform any additional actions you need with the selected option
    };

  return (
    <div>
        <Dropdown
          className="border-black border-t-2"
          options={yourOptions}
          selectedOption={selectedOption}
          onChange={handleDropdownChange}
        />

        {/* API results */}
    </div>
  );
};

export default Epic4Page;

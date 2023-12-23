import {React, useState} from 'react';
import DatePicker from './DatePicker'; // Adjust the path accordingly
import Dropdown from './Dropdown'; // Adjust the path accordingly


const Epic5Page = () => {
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [selectedOption, setSelectedOption] = useState(null);
  const [amount, setAmount] = useState(10); // Default amount

  const yourOptions = ['bruh', 'bruh']
  // Handle date change
  const handleDateChange = (date) => {
    setSelectedDate(date);
    // Perform any additional actions you need with the new date
  };

  // Handle dropdown change
  const handleDropdownChange = (option) => {
    setSelectedOption(option);
    // Perform any additional actions you need with the selected option
  };

  // Handle amount change
  const handleAmountChange = (event) => {
    setAmount(event.target.value);
    // Perform any additional actions you need with the amount
  };

  // Now you can use selectedDate, selectedOption, and amount in your API requests


  return (
    <div>
        <DatePicker className="border-black border-t-2" selectedDate={selectedDate} onChange={handleDateChange} />

        <Dropdown
          className="border-black border-t-2"
          options={yourOptions}
          selectedOption={selectedOption}
          onChange={handleDropdownChange}
        />

        <input
          className="border-black border-t-2"
          type="number"
          value={amount}
          onChange={handleAmountChange}
          placeholder="Enter amount"
        />

        {/* API results */}
    </div>
  );
};

export default Epic5Page;

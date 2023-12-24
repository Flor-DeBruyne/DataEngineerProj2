import React, { useState, useEffect } from 'react';
import DatePicker from './DatePicker';
import Dropdown from './Dropdown';

const Epic3Page = () => {
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [selectedOption, setSelectedOption] = useState(null);
  const [amount, setAmount] = useState(10);
  const [dropdownOptions, setDropdownOptions] = useState([]);
  const [apiResult, setApiResult] = useState(null);

  useEffect(() => {
    fetchDropdownOptions();
  }, []);

  const handleDateChange = (date) => {
    setSelectedDate(date);
  };

  const handleDropdownChange = (option) => {
    setSelectedOption(option);
  };

  const handleAmountChange = (event) => {
    setAmount(event.target.value);
  };

  const fetchDropdownOptions = async () => {
    try {
      const response = await fetch('http://0.0.0.0:8000/get_contacts/');
      const data = await response.json();
  
      if (response.ok) {
        const options = Object.entries(data.result).map(([key, value]) => ({
          value: key,
          label: value,
        }));
  
        setDropdownOptions(options);
      } else {
        console.error('Error fetching dropdown options:', data.error);
      }
    } catch (error) {
      console.error('Error fetching dropdown options:', error);
    }
  };

  const handleSubmit = async () => {
    try {
      console.log(`http://0.0.0.0:8000/generate_campagnes/${selectedOption.label}?after_date=${selectedDate.toISOString().slice(0, 10)}&amount=${amount}`)
      const response = await fetch(`http://0.0.0.0:8000/generate_campagnes/${selectedOption.label}?after_date=${selectedDate.toISOString().slice(0, 10)}&amount=${amount}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      }); 

      const result = await response.json();

      if (response.ok) {
        setApiResult(result);
      } else {
        console.error('Error submitting data:', result.error);
      }
    } catch (error) {
      console.error('Error submitting data:', error);
    }
  };

  return (
    <div>
      <DatePicker
        className="border-black border-t-2"
        selectedDate={selectedDate}
        onChange={handleDateChange}
      />

      <Dropdown
        className="border-black border-t-2"
        options={dropdownOptions}
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

      <button onClick={handleSubmit}>Submit</button>

      {apiResult && (
        <div>
          <h2>API Result</h2>
          {/* Display result in a table or field */}
          {/* Modify this based on the structure of your API response */}
          <pre>{JSON.stringify(apiResult, "Geen Campagnes")}</pre>
        </div>
      )}
    </div>
  );
};

export default Epic3Page;

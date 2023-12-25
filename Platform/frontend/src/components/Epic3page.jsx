import React, { useState, useEffect } from 'react';
import DatePicker from './DatePicker';
import Dropdown from './Dropdown';

const Epic3Page = () => {
  const [selectedDate, setSelectedDate] = useState(new Date('2020-01-01'));
  const [selectedOption, setSelectedOption] = useState(null);
  const [amount, setAmount] = useState(1);
  const [dropdownOptions, setDropdownOptions] = useState([]);
  const [apiResult, setApiResult] = useState({
    result: [
      { campaign: '', probas: '' },
    ],
  });

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
      const response = await fetch('http://localhost:8000/get_contacts/');
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
      console.log(`http://localhost:8000/generate_campagnes/${selectedOption.label}?after_date=${selectedDate.toISOString().slice(0, 10)}&amount=${amount}`)
      const response = await fetch(`http://localhost:8000/generate_campagnes/${selectedOption.label}?after_date=${selectedDate.toISOString().slice(0, 10)}&amount=${amount}`, {
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
      <div className="container mx-auto p-4">
        <DatePicker
          inplace="2023-01-01"
          className="border-black border-t-2 mb-4"
          selectedDate={selectedDate}
          onChange={handleDateChange}
        />
  
        <Dropdown
          className="border-black border-t-2 mb-4"
          options={dropdownOptions}
          selectedOption={selectedOption}
          onChange={handleDropdownChange}
        />
  
        <input
          className="border-black border-t-2 mb-4 p-2"
          type="number"
          value={amount}
          onChange={handleAmountChange}
          placeholder="Enter amount"
        />
  
        <button
          className="bg-blue-500 text-white p-2 rounded hover:bg-blue-700"
          onClick={handleSubmit}
        >
          Submit
        </button>
  
        {apiResult && (
          <div className="mt-8">
            <h2 className="text-lg font-bold mb-4">API Result</h2>
            <table className="table-auto w-full">
              <thead>
                <tr>
                  <th className="px-4 py-2">Campaign</th>
                  <th className="px-4 py-2">Probability</th>
                </tr>
              </thead>
              <tbody>
                {apiResult.result.map((row, index) => (
                  <tr key={index}>
                    <td className="border px-4 py-2">{row.campaign}</td>
                    <td className="border px-4 py-2">{row.probas}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    );
  };
  
  export default Epic3Page;  

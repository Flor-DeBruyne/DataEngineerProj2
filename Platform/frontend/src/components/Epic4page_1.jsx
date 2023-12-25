import React, { useState, useEffect } from 'react';
import Dropdown from './Dropdown';
import { Link } from 'react-router-dom';

const Epic4Page_1 = () => {
  const [selectedOption, setSelectedOption] = useState(null);
  const [dropdownOptions, setDropdownOptions] = useState([]);
  const [apiResult, setApiResult] = useState({
    result: [
      { Contact_ID: '', Similarity: '' },
    ],
  });

  useEffect(() => {
    fetchDropdownOptions();
  }, []);

  const handleDropdownChange = (option) => {
    setSelectedOption(option);
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
      console.log(`http://localhost:8000/lookalikes/${selectedOption.label}`)
      const response = await fetch(`http://localhost:8000/lookalikes/${selectedOption.label}`, {
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
      <nav className="flex space-x-4 mb-4">
        <Link to="/epic4/lookalikes" className="text-blue-500 hover:underline">Lookalikes</Link>
        <Link to="/epic4/clusters" className="text-blue-500 hover:underline">Clusters</Link>
      </nav>
      <Dropdown
        className="border-black border-t-2 mb-4"
        options={dropdownOptions}
        selectedOption={selectedOption}
        onChange={handleDropdownChange}
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
                <th className="px-4 py-2">Contact</th>
                <th className="px-4 py-2">Similarity</th>
              </tr>
            </thead>
            <tbody>
              {apiResult.result.map((row, index) => (
                <tr key={index}>
                  <td className="border px-4 py-2">{row.Contact_ID}</td>
                  <td className="border px-4 py-2">{row.Similarity}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
};

export default Epic4Page_1;

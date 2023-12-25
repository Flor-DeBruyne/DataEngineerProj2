import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';

const Epic4Page_2 = () => {
  const [dropdownOptions, setDropdownOptions] = useState([]);
  const [apiResult, setApiResult] = useState({
    result: [
      { Contact_ID: '', Cluster: '' },
    ],
  });

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const response = await fetch('http://localhost:8000/clusters');
      const result = await response.json();

      if (response.ok) {
        setApiResult(result);
      } else {
        console.error('Error fetching data:', result.error);
      }
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };

  return (
    <div className="container mx-auto p-4">
      <nav className="flex space-x-4 mb-4">
        <Link to="/epic4/lookalikes" className="text-blue-500 hover:underline">Lookalikes</Link>
        <Link to="/epic4/clusters" className="text-blue-500 hover:underline">Clusters</Link>
      </nav>

      {apiResult && (
        <div className="mt-8">
          <h2 className="text-lg font-bold mb-4">API Result</h2>
          <table className="table-auto w-full">
            <thead>
              <tr>
                <th className="px-4 py-2">Contact</th>
                <th className="px-4 py-2">Cluster</th>
              </tr>
            </thead>
            <tbody>
              {apiResult.result.map((row, index) => (
                <tr key={index}>
                  <td className="border px-4 py-2">{row.Contact_ID}</td>
                  <td className="border px-4 py-2">{row.Cluster}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
};

export default Epic4Page_2;
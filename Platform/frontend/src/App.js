import './index.css';
import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Navigation from './components/navbar.jsx';
import HomePage from './components/Homepage.jsx';
import Epic3Page from './components/Epic3page.jsx';
import Epic4Page_1 from './components/Epic4page_1.jsx';
import Epic4Page_2 from './components/Epic4page_2.jsx';
import Epic5Page from './components/Epic5page.jsx';




function App() {
  return (
    <div className='flex flex-col h-screen'>
      <Navigation />
      <div className="flex-grow">
        <Router>
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/epic3" element={<Epic3Page />} />
            <Route path="/epic4/lookalikes" element={<Epic4Page_1 />} />
            <Route path="/epic4/clusters" element={<Epic4Page_2 />} />
            <Route path="/epic5" element={<Epic5Page />} />
          </Routes>
        </Router>
      </div>
    </div>
  );
}

export default App;

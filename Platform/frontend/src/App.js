import './index.css';
import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Navigation from './components/navbar.jsx';
import HomePage from './components/Homepage.jsx';
import Epic3Page from './components/Epic3page.jsx';
import Epic4Page from './components/Epic4page.jsx';
import Epic5Page from './components/Epic5page.jsx';




function App() {
  return (
    <div className='flex fill-current'>
      <Navigation/>
    <Router>
    <Routes>
      <Route path="/" element={<HomePage />} />
      <Route path="/epic3" element={<Epic3Page />} />
      <Route path="/epic4" element={<Epic4Page />} />
      <Route path="/epic5" element={<Epic5Page />} />
    </Routes>
  </Router>
  
  </div>
  );
}

export default App;

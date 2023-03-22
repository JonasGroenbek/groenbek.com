import React from 'react'
import Navbar from '../components/Navbar';
import '../styles/globals.css';

export default ({ Component, pageProps }) => {
  return (
    <>
      <Navbar />
      <Component {...pageProps} />
    </>
  );
}
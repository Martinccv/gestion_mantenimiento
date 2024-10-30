// frontend/src/pages/Dashboard.js
import React from 'react';
import OrderList from '../components/OrderList';

function Dashboard() {
  const token = localStorage.getItem('token');

  if (!token) {
    return <p>Inicia sesión para acceder a las órdenes de mantenimiento</p>;
  }

  return (
    <div>
      <h1>Dashboard</h1>
      <OrderList token={token} />
    </div>
  );
}

export default Dashboard;

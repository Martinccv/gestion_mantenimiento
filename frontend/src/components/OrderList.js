// frontend/src/components/OrderList.js
import React, { useEffect, useState } from 'react';

function OrderList({ token }) {
  const [orders, setOrders] = useState([]);

  useEffect(() => {
    const fetchOrders = async () => {
      const response = await fetch('http://localhost:5000/ordenes', {
        headers: { Authorization: `Bearer ${token}` },
      });
      const data = await response.json();
      setOrders(data);
    };
    fetchOrders();
  }, [token]);

  return (
    <div>
      <h2>Órdenes de Mantenimiento</h2>
      <ul>
        {orders.map((order) => (
          <li key={order.id}>Orden ID: {order.id}, Tipo: {order.tipo}, Prioridad: {order.prioridad}</li>
        ))}
      </ul>
    </div>
  );
}

export default OrderList;

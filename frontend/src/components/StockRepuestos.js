// src/components/StockRepuestos.js
import React, { useState } from "react";
import { obtenerStock } from "./services/api";

function StockRepuestos() {
  const [idRepuesto, setIdRepuesto] = useState("");
  const [stock, setStock] = useState(null);

  const handleFetchStock = async () => {
    try {
      const response = await obtenerStock(idRepuesto);
      setStock(response.data);
    } catch (error) {
      alert("Error al obtener el stock");
    }
  };

  return (
    <div>
      <h2>Consultar Stock de Repuestos</h2>
      <input
        type="text"
        placeholder="ID Repuesto"
        value={idRepuesto}
        onChange={(e) => setIdRepuesto(e.target.value)}
      />
      <button onClick={handleFetchStock}>Consultar Stock</button>
      {stock && (
        <ul>
          {stock.map((item) => (
            <li key={item.ID_Deposito}>
              {item.Nombre_Deposito}: {item.Cantidad_Stock} unidades
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

export default StockRepuestos;

// src/components/CrearOrden.js
import React, { useState } from "react";
import { crearOrden } from "./services/api";

function CrearOrden() {
  const [idEquipo, setIdEquipo] = useState("");
  const [tipo, setTipo] = useState("Correctivo");
  const [prioridad, setPrioridad] = useState("Baja");
  const [fechaEstimada, setFechaEstimada] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await crearOrden({ id_equipo: idEquipo, tipo, prioridad, fecha_estimada: fechaEstimada });
      alert("Orden de mantenimiento creada con éxito");
    } catch (error) {
      alert("Error al crear la orden");
    }
  };

  return (
    <div>
      <h2>Crear Orden de Mantenimiento</h2>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="ID Equipo"
          value={idEquipo}
          onChange={(e) => setIdEquipo(e.target.value)}
        />
        <select value={tipo} onChange={(e) => setTipo(e.target.value)}>
          <option value="Correctivo">Correctivo</option>
          <option value="Preventivo">Preventivo</option>
        </select>
        <select value={prioridad} onChange={(e) => setPrioridad(e.target.value)}>
          <option value="Baja">Baja</option>
          <option value="Media">Media</option>
          <option value="Alta">Alta</option>
        </select>
        <input
          type="date"
          value={fechaEstimada}
          onChange={(e) => setFechaEstimada(e.target.value)}
        />
        <button type="submit">Crear Orden</button>
      </form>
    </div>
  );
}

export default CrearOrden;

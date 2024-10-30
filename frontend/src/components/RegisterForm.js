// frontend/src/components/RegisterForm.js
import React, { useState } from 'react';

function RegisterForm() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [role, setRole] = useState('administrativo');

  const handleSubmit = async (e) => {
    e.preventDefault();
    // Enviar solicitud de registro
    const response = await fetch('http://localhost:5000/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ nombre_usuario: username, contraseña: password, rol: role }),
    });

    if (response.ok) {
      alert('Registro exitoso');
    } else {
      alert('Registro fallido');
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <label>
        Usuario:
        <input
          type="text"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
        />
      </label>
      <label>
        Contraseña:
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
      </label>
      <label>
        Rol:
        <select value={role} onChange={(e) => setRole(e.target.value)}>
          <option value="administrativo">Administrativo</option>
          <option value="ingeniero">Ingeniero</option>
          <option value="gerente">Gerente</option>
        </select>
      </label>
      <button type="submit">Registrar</button>
    </form>
  );
}

export default RegisterForm;

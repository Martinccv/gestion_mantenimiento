// frontend/src/pages/LoginPage.js
import React, { useState } from 'react';
import LoginForm from '../components/LoginForm';

function LoginPage() {
  const [token, setToken] = useState(null);

  const handleLogin = (accessToken) => {
    setToken(accessToken);
    localStorage.setItem('token', accessToken); // Guardar token en localStorage
  };

  return (
    <div>
      <h1>Iniciar Sesión</h1>
      <LoginForm onLogin={handleLogin} />
    </div>
  );
}

export default LoginPage;

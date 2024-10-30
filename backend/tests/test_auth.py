# backend/tests/test_auth.py
import json
from app.models import Usuario

def test_register_user(test_client, init_database):
    # Datos para el registro
    data = {
        "nombre_usuario": "newuser",
        "contraseña": "newpassword",
        "rol": "administrativo"
    }
    response = test_client.post('/register', data=json.dumps(data), content_type='application/json')
    assert response.status_code == 201
    assert response.json['message'] == "Usuario registrado exitosamente"

def test_login_user(test_client, init_database):
    # Datos para el login
    data = {
        "nombre_usuario": "testuser",
        "contraseña": "test123"
    }
    response = test_client.post('/login', data=json.dumps(data), content_type='application/json')
    assert response.status_code == 200
    assert "access_token" in response.json

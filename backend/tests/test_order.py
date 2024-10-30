# backend/tests/test_orders.py
import json
from app.models import OrdenMantenimiento

def test_create_order(test_client, init_database):
    # Primero autenticarse para obtener un token
    login_data = {
        "nombre_usuario": "testuser",
        "contraseña": "test123"
    }
    login_response = test_client.post('/login', data=json.dumps(login_data), content_type='application/json')
    access_token = login_response.json['access_token']
    
    # Crear una orden de mantenimiento con el token
    headers = {'Authorization': f'Bearer {access_token}'}
    order_data = {
        "equipo_id": 1,
        "tipo": "Preventivo",
        "prioridad": "Alta"
    }
    response = test_client.post('/ordenes', data=json.dumps(order_data), headers=headers, content_type='application/json')
    
    assert response.status_code == 201
    assert response.json['message'] == "Orden creada exitosamente"

def test_get_orders(test_client, init_database):
    # Autenticarse para obtener un token
    login_data = {
        "nombre_usuario": "testuser",
        "contraseña": "test123"
    }
    login_response = test_client.post('/login', data=json.dumps(login_data), content_type='application/json')
    access_token = login_response.json['access_token']
    
    # Recuperar órdenes con el token
    headers = {'Authorization': f'Bearer {access_token}'}
    response = test_client.get('/ordenes', headers=headers)
    
    assert response.status_code == 200
    assert isinstance(response.json, list)

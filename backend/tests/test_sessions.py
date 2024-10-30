# backend/tests/test_sessions.py
from app.models import Sesion, Usuario

def test_session_created_on_login(test_client, init_database):
    # Iniciar sesión para crear una sesión en la base de datos
    login_data = {
        "nombre_usuario": "testuser",
        "contraseña": "test123"
    }
    test_client.post('/login', json=login_data)
    
    # Verificar que la sesión ha sido creada
    sesion = Sesion.query.filter_by(usuario_id=1).first()
    assert sesion is not None
    assert sesion.usuario_id == 1

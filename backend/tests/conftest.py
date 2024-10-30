# backend/tests/conftest.py
import pytest
from app import create_app, db
from app.models import Usuario
from werkzeug.security import generate_password_hash

@pytest.fixture(scope='module')
def test_client():
    # Configurar la aplicación en modo de prueba
    flask_app = create_app()
    flask_app.config['TESTING'] = True
    flask_app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    
    # Crear el cliente de prueba
    with flask_app.test_client() as testing_client:
        with flask_app.app_context():
            db.create_all()
            yield testing_client  # pruebas se ejecutarán aquí
            db.drop_all()

@pytest.fixture(scope='module')
def init_database():
    # Agregar datos de prueba
    hashed_password = generate_password_hash("test123", method='sha256')
    user = Usuario(nombre_usuario="testuser", contraseña=hashed_password, rol="administrativo")
    db.session.add(user)
    db.session.commit()
    yield
    # Eliminar datos de prueba
    db.session.remove()

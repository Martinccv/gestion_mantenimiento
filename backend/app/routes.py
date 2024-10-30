# backend/app/routes.py
from flask import Blueprint, request, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from .models import Usuario, OrdenMantenimiento, Sesion
from . import db

main_blueprint = Blueprint('main', __name__)

@main_blueprint.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    hashed_password = generate_password_hash(data['contraseña'], method='sha256')
    new_user = Usuario(nombre_usuario=data['nombre_usuario'], contraseña=hashed_password, rol=data['rol'])
    db.session.add(new_user)
    db.session.commit()
    return jsonify({"message": "Usuario registrado exitosamente"}), 201

@main_blueprint.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    user = Usuario.query.filter_by(nombre_usuario=data['nombre_usuario']).first()
    if not user or not check_password_hash(user.contraseña, data['contraseña']):
        return jsonify({"message": "Credenciales incorrectas"}), 401
    access_token = create_access_token(identity=user.id)
    
    # Registrar sesión de usuario
    sesion = Sesion(usuario_id=user.id)
    db.session.add(sesion)
    db.session.commit()

    return jsonify(access_token=access_token), 200

@main_blueprint.route('/ordenes', methods=['POST'])
@jwt_required()
def create_order():
    user_id = get_jwt_identity()
    data = request.get_json()
    new_order = OrdenMantenimiento(
        equipo_id=data['equipo_id'],
        tipo=data['tipo'],
        prioridad=data['prioridad'],
        usuario_id=user_id
    )
    db.session.add(new_order)
    db.session.commit()
    return jsonify({"message": "Orden creada exitosamente"}), 201

@main_blueprint.route('/ordenes', methods=['GET'])
@jwt_required()
def get_orders():
    orders = OrdenMantenimiento.query.all()
    orders_list = [{"id": o.id, "equipo_id": o.equipo_id, "tipo": o.tipo, "prioridad": o.prioridad} for o in orders]
    return jsonify(orders_list), 200

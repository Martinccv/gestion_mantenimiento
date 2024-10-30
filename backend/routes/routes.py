# routes/routes.py
from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from models.models import Database
from werkzeug.security import check_password_hash

auth = Blueprint('auth', __name__)
maintenance = Blueprint('maintenance', __name__)

@auth.route('/login', methods=['POST'])
def login():
    data = request.json
    username = data.get("username")
    password = data.get("password")

    db = Database()
    user = db.execute_query("SELECT * FROM Usuarios WHERE Nombre_Usuario = %s", (username,))
    
    if user and check_password_hash(user[0]["Contraseña"], password):
        access_token = create_access_token(identity=user[0]["ID_Usuario"])
        return jsonify(access_token=access_token), 200
    return jsonify({"msg": "Credenciales incorrectas"}), 401

@maintenance.route('/crear_orden', methods=['POST'])
@jwt_required()
def crear_orden():
    data = request.json
    id_equipo = data.get("id_equipo")
    tipo = data.get("tipo")
    prioridad = data.get("prioridad")
    fecha_estimada = data.get("fecha_estimada")
    
    id_usuario = get_jwt_identity()  # Usuario que realiza la orden

    db = Database()
    query = """
    INSERT INTO Ordenes_Mantenimiento (ID_Equipo, Tipo, Fecha_Orden, Prioridad, Fecha_Estimada, ID_Usuario)
    VALUES (%s, %s, CURDATE(), %s, %s, %s)
    """
    db.execute_query(query, (id_equipo, tipo, prioridad, fecha_estimada, id_usuario))
    return jsonify({"msg": "Orden de mantenimiento creada exitosamente"}), 201

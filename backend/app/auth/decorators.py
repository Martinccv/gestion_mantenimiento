# backend/app/auth/decorators.py
from functools import wraps
from flask_jwt_extended import get_jwt_identity, jwt_required
from flask import jsonify
from ..models import Usuario

def role_required(role):
    def decorator(fn):
        @wraps(fn)
        @jwt_required()
        def wrapper(*args, **kwargs):
            user_id = get_jwt_identity()
            user = Usuario.query.get(user_id)
            if user.rol != role:
                return jsonify({"message": "Acceso denegado"}), 403
            return fn(*args, **kwargs)
        return wrapper
    return decorator

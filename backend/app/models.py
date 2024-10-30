# backend/app/models.py
from . import db
from datetime import datetime

class Usuario(db.Model):
    __tablename__ = 'usuarios'
    id = db.Column(db.Integer, primary_key=True)
    nombre_usuario = db.Column(db.String(100), nullable=False, unique=True)
    contraseña = db.Column(db.String(255), nullable=False)
    rol = db.Column(db.String(50), nullable=False)

    def __repr__(self):
        return f"<Usuario {self.nombre_usuario}>"

class OrdenMantenimiento(db.Model):
    __tablename__ = 'ordenes_mantenimiento'
    id = db.Column(db.Integer, primary_key=True)
    equipo_id = db.Column(db.Integer, nullable=False)
    tipo = db.Column(db.String(50), nullable=False)
    fecha_orden = db.Column(db.Date, default=datetime.utcnow)
    prioridad = db.Column(db.String(50), nullable=False)
    fecha_estimada = db.Column(db.Date, nullable=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuarios.id'))

    def __repr__(self):
        return f"<Orden {self.id} - Equipo {self.equipo_id}>"

class Sesion(db.Model):
    __tablename__ = 'sesiones'
    id = db.Column(db.Integer, primary_key=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuarios.id'))
    fecha_inicio = db.Column(db.DateTime, default=datetime.utcnow)
    fecha_fin = db.Column(db.DateTime, nullable=True)

    def __repr__(self):
        return f"<Sesion {self.id} - Usuario {self.usuario_id}>"

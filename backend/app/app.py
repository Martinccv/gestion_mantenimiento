from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app, origins=["http://localhost:3000"])  # Permite solicitudes desde el frontend

@app.route("/login", methods=["POST"])
def login():
    data = request.json
    print("Datos recibidos:", data)  # Log para ver datos recibidos
    # Lógica de autenticación
    return jsonify({"status": "success"}), 200

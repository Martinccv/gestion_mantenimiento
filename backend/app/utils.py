# backend/app/utils.py

from flask import jsonify

def format_error(message, status_code=400):
    response = jsonify({"error": message})
    response.status_code = status_code
    return response

# controllers/controllers.py
from models.models import Database

def obtener_stock_repuesto(id_repuesto):
    db = Database()
    query = """
    SELECT d.Nombre_Deposito, s.Cantidad_Stock
    FROM Stock_Depositos s
    JOIN Depositos d ON s.ID_Deposito = d.ID_Deposito
    WHERE s.ID_Repuesto = %s
    """
    stock = db.execute_query(query, (id_repuesto,))
    db.close()
    return stock

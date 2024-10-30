# Sistema de Gestión de Mantenimiento

Este proyecto es un sistema completo de gestión de mantenimiento, optimizado y modularizado para gestionar órdenes de mantenimiento, stock de repuestos y sesiones de usuarios en empresas de construcción, logística o industrias.

## Estructura del Proyecto

El proyecto incluye:
- **Backend** en Flask, que ofrece una API REST para gestionar la base de datos y autenticación.
- **Frontend** en React, para la interfaz gráfica.
- **Base de Datos** en MySQL.
- **Docker** para contenerizar cada componente y facilitar la implementación.

## Requisitos

- Docker
- Docker Compose
- Node.js (para ejecutar el frontend localmente, opcionalmente)

## Configuración del Entorno

### Variables de Entorno

1. **Backend**: Crea un archivo `.env` en el directorio `backend` con las siguientes variables:

   ```plaintext
   DATABASE_URI=mysql+pymysql://user:password@db/sistema_gestion
   SECRET_KEY=my_secret_key

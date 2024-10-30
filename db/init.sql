DROP DATABASE IF EXISTS Sistema_gestion_mantenimiento;
CREATE DATABASE Sistema_gestion_mantenimiento;
USE Sistema_gestion_mantenimiento;

CREATE TABLE Equipos (
    ID_Equipo INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Tipo VARCHAR(100),
    Marca VARCHAR(100),
    Modelo VARCHAR(100),
    Numero_Serie VARCHAR(100),
    Numero_Motor VARCHAR(100),
    Ubicacion VARCHAR(150),
    Fecha_Compra DATE,
    Estado VARCHAR(50) -- (Ej: Operativo, Fuera de Servicio, Mantenimiento)
);

CREATE TABLE Tecnicos (
    ID_Tecnico INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100),
    Especialidad VARCHAR(100), -- Ej: Mecánico, Electricista, etc.
    Disponibilidad VARCHAR(50), -- Ej: Disponible, Ocupado
    Telefono VARCHAR(15),
    Correo VARCHAR(100)
);

CREATE TABLE Depositos (
    ID_Deposito INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Deposito VARCHAR(100),
    Ubicacion VARCHAR(255)
);

CREATE TABLE Proveedores (
    ID_Proveedor INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Proveedor VARCHAR(150) NOT NULL,
    Tipo_Servicio VARCHAR(100), -- Ej: Mantenimiento mecánico, eléctrico, etc.
    Contacto VARCHAR(100),
    Telefono VARCHAR(15),
    Correo VARCHAR(100),
    Direccion VARCHAR(150)
);

CREATE TABLE Repuestos (
    ID_Repuesto INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Repuesto VARCHAR(100),
    Descripcion VARCHAR(255),
    Marca VARCHAR(100),
    Modelo VARCHAR(100),
    Cantidad_Stock INT -- Cantidad disponible en inventario
);

CREATE TABLE Mantenimiento (
    ID_Mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
    ID_Equipo INT, -- Llave foránea a Equipos
    Tipo VARCHAR(50), -- Correctivo o Preventivo
    Fecha_Inicio DATE,
    Fecha_Fin DATE,
    Descripcion TEXT,
    Estado VARCHAR(50) -- Pendiente, En Proceso, Completado
);

CREATE TABLE Movimientos_Repuestos (
    ID_Movimiento INT AUTO_INCREMENT PRIMARY KEY,
    ID_Deposito INT, -- Llave foránea a Depositos
    ID_Repuesto INT, -- Llave foránea a Repuestos
    Tipo_Movimiento VARCHAR(50), -- Entrada o Salida
    Cantidad INT, -- Cantidad de repuestos que ingresan o se utilizan
    Fecha DATE,
    Descripcion VARCHAR(255)
);

CREATE TABLE Detalle_Mantenimiento (
    ID_Detalle INT AUTO_INCREMENT PRIMARY KEY,
    ID_Mantenimiento INT, -- Llave foránea a Mantenimiento
    ID_Tecnico INT, -- Llave foránea a Tecnicos
    ID_Proveedor INT, -- Llave foránea a Proveedores (nulo si es técnico propio)
    ID_Deposito INT, -- Llave foránea a Depositos
    ID_Repuesto INT, -- Llave foránea a Repuestos
    Cantidad INT, -- Cantidad de repuestos usados
    Costo_Piezas DECIMAL(10, 2),
    Mano_De_Obra DECIMAL(10, 2)
);

CREATE TABLE Ordenes_Mantenimiento (
    ID_Orden INT AUTO_INCREMENT PRIMARY KEY,
    ID_Equipo INT, -- Llave foránea a Equipos
    Tipo VARCHAR(50), -- Preventivo o Correctivo
    Fecha_Orden DATE,
    Prioridad VARCHAR(50), -- Baja, Media, Alta
    Fecha_Estimada DATE, -- Fecha estimada de realización
    ID_Usuario INT, -- Llave foránea a Usuarios
    ID_Tecnico INT, -- Técnico asignado (nulo si es proveedor externo)
    ID_Proveedor INT -- Proveedor asignado (nulo si es técnico propio)
);

CREATE TABLE Stock_Depositos (
    ID_Stock INT AUTO_INCREMENT PRIMARY KEY,
    ID_Deposito INT, -- Llave foránea a Depositos
    ID_Repuesto INT, -- Llave foránea a Repuestos
    Cantidad_Stock INT,
    UNIQUE (ID_Deposito, ID_Repuesto) -- Cada repuesto en cada depósito debe ser único
);

CREATE TABLE Usuarios (
    ID_Usuario INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Usuario VARCHAR(100),
    Contraseña VARCHAR(255), -- (Hasheada para seguridad)
    Rol VARCHAR(50) -- Ej: Administrador, Técnico, Supervisor
);

CREATE TABLE Sesiones (
    ID_Sesion INT AUTO_INCREMENT PRIMARY KEY,
    ID_Usuario INT,
    Fecha_Inicio DATETIME,
    Fecha_Fin DATETIME
);

-- Creación de foreign keys
-- Foreign key para la tabla Mantenimiento
ALTER TABLE Mantenimiento
ADD CONSTRAINT FK_Mantenimiento_Equipo FOREIGN KEY (ID_Equipo) REFERENCES Equipos(ID_Equipo);

-- Foreign key para la tabla Movimientos_Repuestos
ALTER TABLE Movimientos_Repuestos
ADD CONSTRAINT FK_Movimientos_Deposito FOREIGN KEY (ID_Deposito) REFERENCES Depositos(ID_Deposito),
ADD CONSTRAINT FK_Movimientos_Repuesto FOREIGN KEY (ID_Repuesto) REFERENCES Repuestos(ID_Repuesto);

-- Foreign key para la tabla Detalle_Mantenimiento
ALTER TABLE Detalle_Mantenimiento
ADD CONSTRAINT FK_Detalle_Mantenimiento_Mantenimiento FOREIGN KEY (ID_Mantenimiento) REFERENCES Mantenimiento(ID_Mantenimiento),
ADD CONSTRAINT FK_Detalle_Mantenimiento_Tecnico FOREIGN KEY (ID_Tecnico) REFERENCES Tecnicos(ID_Tecnico),
ADD CONSTRAINT FK_Detalle_Mantenimiento_Proveedor FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID_Proveedor),
ADD CONSTRAINT FK_Detalle_Mantenimiento_Deposito FOREIGN KEY (ID_Deposito) REFERENCES Depositos(ID_Deposito),
ADD CONSTRAINT FK_Detalle_Mantenimiento_Repuesto FOREIGN KEY (ID_Repuesto) REFERENCES Repuestos(ID_Repuesto);

-- Foreign key para la tabla Ordenes_Mantenimiento
ALTER TABLE Ordenes_Mantenimiento
ADD CONSTRAINT FK_Ordenes_Mantenimiento_Equipo FOREIGN KEY (ID_Equipo) REFERENCES Equipos(ID_Equipo),
ADD CONSTRAINT FK_Ordenes_Mantenimiento_Usuario FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario),
ADD CONSTRAINT FK_Ordenes_Mantenimiento_Tecnico FOREIGN KEY (ID_Tecnico) REFERENCES Tecnicos(ID_Tecnico),
ADD CONSTRAINT FK_Ordenes_Mantenimiento_Proveedor FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID_Proveedor);

-- Foreign key para la tabla Stock_Depositos
ALTER TABLE Stock_Depositos
ADD CONSTRAINT FK_Stock_Depositos_Deposito FOREIGN KEY (ID_Deposito) REFERENCES Depositos(ID_Deposito),
ADD CONSTRAINT FK_Stock_Depositos_Repuesto FOREIGN KEY (ID_Repuesto) REFERENCES Repuestos(ID_Repuesto);

-- Foreign key para la tabla Sesiones
ALTER TABLE Sesiones
ADD CONSTRAINT FK_Sesiones_Usuario FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario);



DELIMITER //
CREATE TRIGGER Actualizar_Stock_Salida
AFTER INSERT ON Detalle_Mantenimiento
FOR EACH ROW
BEGIN
    -- Actualizar el stock del repuesto en el depósito utilizado
    UPDATE Stock_Depositos
    SET Cantidad_Stock = Cantidad_Stock - NEW.Cantidad
    WHERE ID_Deposito = NEW.ID_Deposito AND ID_Repuesto = NEW.ID_Repuesto;

    -- Registrar la salida en Movimientos_Repuestos
    INSERT INTO Movimientos_Repuestos (ID_Deposito, ID_Repuesto, Tipo_Movimiento, Cantidad, Fecha, Descripcion)
    VALUES (NEW.ID_Deposito, NEW.ID_Repuesto, 'Salida', NEW.Cantidad, CURDATE(), CONCAT('Uso de ', NEW.Cantidad, ' repuestos en mantenimiento ID: ', NEW.ID_Mantenimiento));
END; //
DELIMITER ;

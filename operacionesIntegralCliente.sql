-- Usar esquema
USE reclutamiento;

-- Crear datos de ejemplo en cliente
INSERT INTO cliente (nombre, empresa, contacto, email) VALUES
('Acme S.A.',        'Acme',           'Laura Gómez',      'laura@acme.com'),
('Globant',          'Globant',        'Pedro Ruiz',       'pedro.ruiz@globant.com'),
('Mercado Libre',    'MELI',           'Ana Torres',       'ana.torres@meli.com'),
('Tech Solutions',   'Tech Solutions', 'María Fernández',  'maria@techsolutions.io');

-- Consultar por id
SELECT cliente_id, nombre, empresa, contacto, email
FROM cliente
WHERE cliente_id = 1;

-- Consultar por email
SELECT cliente_id, nombre, empresa, contacto, email
FROM cliente
WHERE email = 'laura@acme.com';

-- Modificar por id
UPDATE cliente
SET nombre   = 'Acme SA',
    empresa  = 'Acme',
    contacto = 'Laura G.',
    email    = 'laura.gomez@acme.com'
WHERE cliente_id = 1;

-- Modificar parcial por id
UPDATE cliente
SET contacto = 'Ana Torres (Compras)'
WHERE cliente_id = 3;

-- Listar con búsqueda y paginado
SET @busqueda = 'Acme';  -- usar '' o NULL para traer todo
SET @limite   = 50;
SET @offset   = 0;

SELECT cliente_id, nombre, empresa, contacto, email
FROM cliente
WHERE (
  COALESCE(@busqueda,'') = ''
  OR (
       nombre   LIKE CONCAT('%', @busqueda, '%')
    OR empresa  LIKE CONCAT('%', @busqueda, '%')
    OR contacto LIKE CONCAT('%', @busqueda, '%')
    OR email    LIKE CONCAT('%', @busqueda, '%')
  )
)
ORDER BY cliente_id DESC
LIMIT @limite OFFSET @offset;

-- Obtener total para paginado
SELECT COUNT(*) AS total
FROM cliente
WHERE (
  COALESCE(@busqueda,'') = ''
  OR (
       nombre   LIKE CONCAT('%', @busqueda, '%')
    OR empresa  LIKE CONCAT('%', @busqueda, '%')
    OR contacto LIKE CONCAT('%', @busqueda, '%')
    OR email    LIKE CONCAT('%', @busqueda, '%')
  )
);

-- Eliminar por id
SET SQL_SAFE_UPDATES = 0;
DELETE FROM cliente
WHERE cliente_id = 2;

-- Eliminar por email
DELETE FROM cliente
WHERE email = 'maria@techsolutions.io';

-- Listar final para verificar cambios
SELECT * FROM cliente ORDER BY cliente_id;

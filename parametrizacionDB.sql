-- =========================================================
-- Poblar catálogos (enumerations) - BD: reclutamiento
-- =========================================================
USE reclutamiento;

START TRANSACTION;

-- ---------- ROL ----------
INSERT INTO rol (nombre, descripcion) VALUES
  ('Lider',      'Acceso total al sistema'),
  ('Recruiter',          'Gestiona candidatos y entrevistas')
ON DUPLICATE KEY UPDATE descripcion = VALUES(descripcion);

-- ---------- SENIORITY ----------
INSERT INTO seniority (nombre, descripcion) VALUES
  ('Trainee',        'Sin experiencia previa o en formación'),
  ('Junior',         '0-2 años de experiencia'),
  ('Semi Senior',    '2-5 años de experiencia'),
  ('Senior',         '5+ años de experiencia y autonomía'),
  ('Lead',           'Liderazgo técnico/funcional')
ON DUPLICATE KEY UPDATE descripcion = VALUES(descripcion);

-- ---------- MODALIDAD ----------
INSERT INTO modalidad (nombre, descripcion) VALUES
  ('Presencial', 'Trabajo 100% en oficina'),
  ('Híbrida',    'Combinación oficina/remoto'),
  ('Remota',     'Trabajo 100% remoto')
ON DUPLICATE KEY UPDATE descripcion = VALUES(descripcion);

-- ---------- PRIORIDAD ----------
INSERT INTO prioridad (nombre, descripcion) VALUES
  ('Baja',    'Sin urgencia'),
  ('Media',   'Importante'),
  ('Alta',    'Necesidad próxima'),
  ('Crítica', 'Cobertura inmediata')
ON DUPLICATE KEY UPDATE descripcion = VALUES(descripcion);

-- ---------- ESTADO SOLICITUD ----------
INSERT INTO estado_solicitud (nombre, descripcion) VALUES
  ('Nueva',        'Solicitud registrada'),
  ('En análisis',  'Relevamiento y validación'),
  ('Aprobada',     'Autorizada para búsqueda'),
  ('Pausada',      'Temporalmente detenida'),
  ('Cerrada',      'Cerrada por cobertura o vencimiento'),
  ('Cancelada',    'Anulada por el solicitante')
ON DUPLICATE KEY UPDATE descripcion = VALUES(descripcion);

-- ---------- ESTADO POSTULACIÓN ----------
INSERT INTO estado_postulacion (nombre, descripcion) VALUES
  ('Recibida',             'CV recibido/registrado'),
  ('En evaluación',        'Screening inicial'),
  ('Preseleccionado',      'Pasa a entrevistas'),
  ('Entrevista técnica',   'En proceso técnico'),
  ('Oferta',               'Offer extendida'),
  ('Rechazado',            'No continúa'),
  ('Retirado',             'Candidato se retira')
ON DUPLICATE KEY UPDATE descripcion = VALUES(descripcion);

-- ---------- TIPO ENTREVISTA ----------
INSERT INTO tipo_entrevista (nombre, descripcion) VALUES
  ('Screening RRHH',     'Entrevista inicial con RRHH'),
  ('Técnica',            'Evaluación de conocimientos'),
  ('Hiring Manager',     'Fit con el área solicitante'),
  ('Pair Programming',   'Ejercicio práctico en vivo')
ON DUPLICATE KEY UPDATE descripcion = VALUES(descripcion);

-- ---------- RESULTADO ENTREVISTA ----------
INSERT INTO resultado_entrevista (nombre, descripcion) VALUES
  ('Aprobado',                'Cumple con los requisitos'),
  ('Aprobado con reservas',   'Requiere consideraciones'),
  ('Desaprobado',             'No cumple con el estándar'),
  ('Reprogramar',             'Reagendar entrevista'),
  ('Ausente',                 'No se presentó')
ON DUPLICATE KEY UPDATE descripcion = VALUES(descripcion);

-- ---------- NIVEL HABILIDAD ----------
INSERT INTO nivel_habilidad (nombre, descripcion) VALUES
  ('Básico',      'Conoce fundamentos'),
  ('Intermedio',  'Aplica con cierta autonomía'),
  ('Avanzado',    'Resuelve problemas complejos'),
  ('Experto',     'Dominio y liderazgo técnico')
ON DUPLICATE KEY UPDATE descripcion = VALUES(descripcion);

COMMIT;

-- Sugerencia: verificar
-- SELECT * FROM rol; SELECT * FROM seniority; ... etc.

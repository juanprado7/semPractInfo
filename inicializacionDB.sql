-- =========================================================
-- Esquema: reclutamiento
-- Motor/charset seguros para MySQL
-- =========================================================
DROP DATABASE IF EXISTS reclutamiento;
CREATE DATABASE reclutamiento
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
USE reclutamiento;

-- ============================
-- Tablas catálogo (enumerations)
-- ============================
CREATE TABLE rol (
  rol_id        TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre        VARCHAR(50)  NOT NULL UNIQUE,
  descripcion   VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE seniority (
  seniority_id  TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre        VARCHAR(50)  NOT NULL UNIQUE,
  descripcion   VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE modalidad (
  modalidad_id  TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre        VARCHAR(50)  NOT NULL UNIQUE,
  descripcion   VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE prioridad (
  prioridad_id  TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre        VARCHAR(50)  NOT NULL UNIQUE,
  descripcion   VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE estado_solicitud (
  estado_solicitud_id  TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre               VARCHAR(50)  NOT NULL UNIQUE,
  descripcion          VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE estado_postulacion (
  estado_postulacion_id  TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre                 VARCHAR(50)  NOT NULL UNIQUE,
  descripcion            VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE tipo_entrevista (
  tipo_entrevista_id  TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre              VARCHAR(50)  NOT NULL UNIQUE,
  descripcion         VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE resultado_entrevista (
  resultado_entrevista_id  TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre                   VARCHAR(50)  NOT NULL UNIQUE,
  descripcion              VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE nivel_habilidad (
  nivel_habilidad_id  TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre              VARCHAR(50)  NOT NULL UNIQUE,
  descripcion         VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================
-- Entidades
-- ============================
-- Cliente (idCliente, nombre, empresa, contacto, email)
CREATE TABLE cliente (
  cliente_id  INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre      VARCHAR(120) NOT NULL,
  empresa     VARCHAR(120),
  contacto    VARCHAR(120),
  email       VARCHAR(120),
  UNIQUE KEY uq_cliente_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Perfil (idPerfil, nombre, descripcion, contacto, email)
CREATE TABLE perfil (
  perfil_id    INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre       VARCHAR(120) NOT NULL,
  descripcion  VARCHAR(255),
  UNIQUE KEY uq_perfil_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Habilidad (idHabilidad, nombre, nivel:NivelHabilidad)
CREATE TABLE habilidad (
  habilidad_id        INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre              VARCHAR(120) NOT NULL,
  nivel_habilidad_id  TINYINT UNSIGNED NOT NULL,
  CONSTRAINT fk_habilidad_nivel
    FOREIGN KEY (nivel_habilidad_id) REFERENCES nivel_habilidad(nivel_habilidad_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  UNIQUE KEY uq_habilidad_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- N..N Perfil–Habilidad (del diagrama: Perfil agrupa muchas Habilidades y viceversa)
CREATE TABLE perfil_habilidad (
  perfil_id     INT UNSIGNED NOT NULL,
  habilidad_id  INT UNSIGNED NOT NULL,
  PRIMARY KEY (perfil_id, habilidad_id),
  CONSTRAINT fk_perfil_hab_perfil
    FOREIGN KEY (perfil_id) REFERENCES perfil(perfil_id)
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_perfil_hab_habilidad
    FOREIGN KEY (habilidad_id) REFERENCES habilidad(habilidad_id)
      ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Usuario (idUsuario, nombre, apellido, rol, username, email, contrasenaHash)
CREATE TABLE usuario (
  usuario_id       INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre           VARCHAR(120) NOT NULL,
  apellido         VARCHAR(120) NOT NULL,
  rol_id           TINYINT UNSIGNED NOT NULL,
  username         VARCHAR(60)  NOT NULL,
  email            VARCHAR(120) NOT NULL,
  contrasena_hash  VARCHAR(255) NOT NULL,
  CONSTRAINT fk_usuario_rol
    FOREIGN KEY (rol_id) REFERENCES rol(rol_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  UNIQUE KEY uq_usuario_username (username),
  UNIQUE KEY uq_usuario_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Candidato (idCandidato, nombre, apellido, email, telefono, perfil, seniority)
CREATE TABLE candidato (
  candidato_id  INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre        VARCHAR(120) NOT NULL,
  apellido      VARCHAR(120) NOT NULL,
  email         VARCHAR(120) NOT NULL,
  telefono      VARCHAR(40),
  perfil_id     INT UNSIGNED NOT NULL,
  seniority_id  TINYINT UNSIGNED NOT NULL,
  CONSTRAINT fk_candidato_perfil
    FOREIGN KEY (perfil_id) REFERENCES perfil(perfil_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_candidato_seniority
    FOREIGN KEY (seniority_id) REFERENCES seniority(seniority_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  UNIQUE KEY uq_candidato_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Etapa (idEtapa, nombre, fechaIngreso, fechaSalida)
CREATE TABLE etapa (
  etapa_id       INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  nombre         VARCHAR(120) NOT NULL,
  fecha_ingreso  DATE,
  fecha_salida   DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Solicitud (idSolicitud, fecha, hora, perfil, cantidadPerfiles, seniority, modalidad,
--            costo, prioridad, sla, estado, cliente, responsable:Usuario)
CREATE TABLE solicitud (
  solicitud_id      INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  fecha             DATE NOT NULL,
  hora              TIME,
  perfil_id         INT UNSIGNED NOT NULL,
  cantidad_perfiles INT UNSIGNED NOT NULL,
  seniority_id      TINYINT UNSIGNED NOT NULL,
  modalidad_id      TINYINT UNSIGNED NOT NULL,
  costo             DECIMAL(12,2) NOT NULL,
  prioridad_id      TINYINT UNSIGNED NOT NULL,
  sla               INT UNSIGNED,
  estado_solicitud_id  TINYINT UNSIGNED NOT NULL,
  cliente_id        INT UNSIGNED NOT NULL,
  responsable_id    INT UNSIGNED NOT NULL,
  CONSTRAINT fk_solicitud_perfil
    FOREIGN KEY (perfil_id) REFERENCES perfil(perfil_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_solicitud_seniority
    FOREIGN KEY (seniority_id) REFERENCES seniority(seniority_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_solicitud_modalidad
    FOREIGN KEY (modalidad_id) REFERENCES modalidad(modalidad_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_solicitud_prioridad
    FOREIGN KEY (prioridad_id) REFERENCES prioridad(prioridad_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_solicitud_estado
    FOREIGN KEY (estado_solicitud_id) REFERENCES estado_solicitud(estado_solicitud_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_solicitud_cliente
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_solicitud_responsable
    FOREIGN KEY (responsable_id) REFERENCES usuario(usuario_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  INDEX idx_solicitud_cliente (cliente_id),
  INDEX idx_solicitud_responsable (responsable_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Postulacion (idPostulacion, fecha, hora, estado, etapaActual, solicitud, candidato)
CREATE TABLE postulacion (
  postulacion_id         INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  fecha                  DATE NOT NULL,
  hora                   TIME,
  estado_postulacion_id  TINYINT UNSIGNED NOT NULL,
  etapa_actual_id        INT UNSIGNED,
  solicitud_id           INT UNSIGNED NOT NULL,
  candidato_id           INT UNSIGNED NOT NULL,
  CONSTRAINT fk_postulacion_estado
    FOREIGN KEY (estado_postulacion_id) REFERENCES estado_postulacion(estado_postulacion_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_postulacion_etapa
    FOREIGN KEY (etapa_actual_id) REFERENCES etapa(etapa_id)
      ON UPDATE RESTRICT ON DELETE SET NULL,
  CONSTRAINT fk_postulacion_solicitud
    FOREIGN KEY (solicitud_id) REFERENCES solicitud(solicitud_id)
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_postulacion_candidato
    FOREIGN KEY (candidato_id) REFERENCES candidato(candidato_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  UNIQUE KEY uq_postulacion_solicitud_candidato (solicitud_id, candidato_id),
  INDEX idx_postulacion_candidato (candidato_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Entrevista (idEntrevista, fecha, hora, tipo, evaluador:Usuario, candidato, resultado, notas)
CREATE TABLE entrevista (
  entrevista_id            INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  fecha                    DATE NOT NULL,
  hora                     TIME,
  tipo_entrevista_id       TINYINT UNSIGNED NOT NULL,
  evaluador_id             INT UNSIGNED NOT NULL,
  candidato_id             INT UNSIGNED NOT NULL,
  resultado_entrevista_id  TINYINT UNSIGNED,
  notas                    TEXT,
  CONSTRAINT fk_entrevista_tipo
    FOREIGN KEY (tipo_entrevista_id) REFERENCES tipo_entrevista(tipo_entrevista_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_entrevista_evaluador
    FOREIGN KEY (evaluador_id) REFERENCES usuario(usuario_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_entrevista_candidato
    FOREIGN KEY (candidato_id) REFERENCES candidato(candidato_id)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_entrevista_resultado
    FOREIGN KEY (resultado_entrevista_id) REFERENCES resultado_entrevista(resultado_entrevista_id)
      ON UPDATE RESTRICT ON DELETE SET NULL,
  INDEX idx_entrevista_candidato (candidato_id),
  INDEX idx_entrevista_evaluador (evaluador_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================
-- Vistas útiles (opcional)
-- ============================
-- Ejemplo: detalle de solicitud con textos de catálogos
-- CREATE VIEW vw_solicitud_detalle AS
-- SELECT s.*, se.nombre AS seniority_nombre, mo.nombre AS modalidad_nombre,
--        pr.nombre AS prioridad_nombre, es.nombre AS estado_nombre,
--        c.nombre AS cliente_nombre, u.username AS responsable_username
-- FROM solicitud s
-- JOIN seniority se ON se.seniority_id = s.seniority_id
-- JOIN modalidad mo ON mo.modalidad_id = s.modalidad_id
-- JOIN prioridad pr ON pr.prioridad_id = s.prioridad_id
-- JOIN estado_solicitud es ON es.estado_solicitud_id = s.estado_solicitud_id
-- JOIN cliente c ON c.cliente_id = s.cliente_id
-- JOIN usuario u ON u.usuario_id = s.responsable_id;

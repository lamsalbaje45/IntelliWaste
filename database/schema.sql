

DROP DATABASE IF EXISTS intelliwaste_db;
CREATE DATABASE intelliwaste_db;
USE intelliwaste_db;

-- ----------------------------------------------------------
-- Table: user (admins, citizens, workers - role differentiates)
-- ----------------------------------------------------------
CREATE TABLE user (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(120) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    role        VARCHAR(20)  NOT NULL,         -- ADMIN, USER, WORKER
    phone       VARCHAR(20),
    address     VARCHAR(255),
    is_approved BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ----------------------------------------------------------
-- Table: category (waste category lookup)
-- ----------------------------------------------------------
CREATE TABLE category (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50)  NOT NULL UNIQUE,
    description VARCHAR(200)
) ENGINE=InnoDB;

INSERT INTO category (name, description) VALUES
('Organic',      'Food waste, garden waste, biodegradable items'),
('Plastic',      'Bottles, packaging, plastic bags'),
('Paper',        'Newspapers, cardboard, office paper'),
('Glass',        'Bottles, broken glass, mirrors'),
('Metal',        'Cans, scrap metal, foil'),
('E-Waste',      'Electronics, batteries, cables'),
('Hazardous',    'Chemicals, medical waste, paint'),
('Mixed',        'Unsorted general waste');

-- ----------------------------------------------------------
-- Table: waste_report (core entity - reports filed by users)
-- ----------------------------------------------------------
CREATE TABLE waste_report (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT NOT NULL,
    category_id   INT NOT NULL,
    location      VARCHAR(255) NOT NULL,
    description   TEXT         NOT NULL,
    report_image  VARCHAR(255),
    priority      VARCHAR(10)  NOT NULL DEFAULT 'MEDIUM',   -- LOW, MEDIUM, HIGH
    status        VARCHAR(20)  NOT NULL DEFAULT 'PENDING',  -- PENDING, ASSIGNED, IN_PROGRESS, COMPLETED, REJECTED
    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)     REFERENCES user(id)     ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES category(id)
) ENGINE=InnoDB;

-- ----------------------------------------------------------
-- Table: assignment (admin assigns reports to workers)
-- ----------------------------------------------------------
CREATE TABLE assignment (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    report_id     INT NOT NULL,
    worker_id     INT NOT NULL,
    assigned_by   INT NOT NULL,
    worker_notes  TEXT,
    status        VARCHAR(20) NOT NULL DEFAULT 'PENDING',   -- PENDING, ACCEPTED, REJECTED, COMPLETED
    assigned_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at  TIMESTAMP NULL,
    FOREIGN KEY (report_id)   REFERENCES waste_report(id) ON DELETE CASCADE,
    FOREIGN KEY (worker_id)   REFERENCES user(id),
    FOREIGN KEY (assigned_by) REFERENCES user(id)
) ENGINE=InnoDB;

-- ----------------------------------------------------------
-- Seed: default admin / sample worker / sample user
-- Login credentials for testing (BCrypt hashes verified to work):
--   admin@intelliwaste.com  / Admin@123
--   worker@intelliwaste.com / Worker@123
--   user@intelliwaste.com   / User@123
-- ----------------------------------------------------------
INSERT INTO user (name, email, password, role, phone, address) VALUES
('System Admin',    'admin@intelliwaste.com',  '$2a$10$rBHvsX6DVhjEkLiORtKFyeEGsuAPyOCS5rGCtCSGbo5RNDMnBRnhm', 'ADMIN',  '9800000001', 'IntelliWaste HQ, Itahari'),
('Ram Worker',      'worker@intelliwaste.com', '$2a$10$qvHuSfoAuSwlFhnyPBdh2O1qgTGNW1DoSbH3uQO4bIU8LMXuOlWlS', 'WORKER', '9800000002', 'Itahari-4, Sunsari'),
('Sita Citizen',    'user@intelliwaste.com',   '$2a$10$zSeO9z1cy7HPw1cncbtdgeAqEyTSpmzxrXDPjB5q0TFQljHcEX7H6', 'USER',   '9800000003', 'Itahari-7, Sunsari');

-- ----------------------------------------------------------
-- Sample report (so admin dashboard isn't empty on first run)
-- ----------------------------------------------------------
INSERT INTO waste_report (user_id, category_id, location, description, priority, status)
VALUES (
  (SELECT id FROM user WHERE email='user@intelliwaste.com'),
  (SELECT id FROM category WHERE name='Plastic'),
  'Near Itahari Chowk, opposite the bus stop',
  'A large pile of plastic bottles and bags has accumulated for days. Needs urgent attention.',
  'HIGH',
  'PENDING'
);

-- ============================================================
-- The BCrypt hashes above are real, verified hashes generated with
-- BCrypt.hashpw(plaintext, BCrypt.gensalt(10)) and tested. Login
-- works out of the box. To rotate passwords, run a small main:
--
--   import org.mindrot.jbcrypt.BCrypt;
--   public class Hash {
--     public static void main(String[] a){
--       System.out.println(BCrypt.hashpw("NewPassword", BCrypt.gensalt()));
--     }
--   }
--
-- Then UPDATE user SET password='<paste>' WHERE email='...';
-- ============================================================

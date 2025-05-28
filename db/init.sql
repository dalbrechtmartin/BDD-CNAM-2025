-- Encodage des caractères
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Créer la base
CREATE DATABASE IF NOT EXISTS scp_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE scp_db;

-- Supprimer les tables si elles existent (ordre inverse des dépendances)
DROP TABLE IF EXISTS Access;
DROP TABLE IF EXISTS Work;
DROP TABLE IF EXISTS Incident;
DROP TABLE IF EXISTS `User`;
DROP TABLE IF EXISTS SCP;
DROP TABLE IF EXISTS UserClass;
DROP TABLE IF EXISTS Site;
DROP TABLE IF EXISTS SCPClassification;
DROP TABLE IF EXISTS SCPClass;

-- Création des tables de base

CREATE TABLE SCPClass (
    id_scp_class INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50)
);

CREATE TABLE SCPClassification (
    id_scp_classification INT PRIMARY KEY AUTO_INCREMENT,
    color VARCHAR(50),
    description TEXT
);

CREATE TABLE Site (
    id_site INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(255),
    description TEXT,
    cell VARCHAR(50)
);

CREATE TABLE UserClass (
    id_user_class INT PRIMARY KEY AUTO_INCREMENT,
    level INT,
    description TEXT,
    authorization VARCHAR(100)
);

CREATE TABLE SCP (
    id_scp INT PRIMARY KEY AUTO_INCREMENT,
    number VARCHAR(20) NOT NULL,
    title VARCHAR(255),
    description TEXT,
    image VARCHAR(255),
    threat_level VARCHAR(50),
    nationality VARCHAR(100),
    id_scp_class INT,
    id_scp_classification INT,
    id_site INT,
    FOREIGN KEY (id_scp_class) REFERENCES SCPClass(id_scp_class),
    FOREIGN KEY (id_scp_classification) REFERENCES SCPClassification(id_scp_classification),
    FOREIGN KEY (id_site) REFERENCES Site(id_site)
);

CREATE TABLE `User` (
    id_user INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    user_name VARCHAR(100) UNIQUE,
    email VARCHAR(100) UNIQUE,
    id_user_class INT,
    FOREIGN KEY (id_user_class) REFERENCES UserClass(id_user_class)
);

CREATE TABLE Incident (
    id_incident INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    date DATE,
    description TEXT,
    id_scp INT,
    FOREIGN KEY (id_scp) REFERENCES SCP(id_scp)
);

CREATE TABLE Work (
    id_site INT,
    id_user INT,
    PRIMARY KEY (id_site, id_user),
    FOREIGN KEY (id_site) REFERENCES Site(id_site),
    FOREIGN KEY (id_user) REFERENCES `User`(id_user)
);

CREATE TABLE Access (
    id_scp INT,
    id_user INT,
    date_access DATETIME,
    PRIMARY KEY (id_scp, id_user, date_access),
    FOREIGN KEY (id_scp) REFERENCES SCP(id_scp),
    FOREIGN KEY (id_user) REFERENCES `User`(id_user)
);

-- Insertion des données de bases

-- SCPClass
-- Safe
INSERT INTO SCPClass (name, description, category) 
VALUES ('Safe', 'Contenus et sans risque immédiat.', 'Primaire');
-- Euclid
INSERT INTO SCPClass (name, description, category) 
VALUES ('Euclid', 'Imprévisibles, nécessitant une surveillance constante.', 'Primaire');
-- Keter
INSERT INTO SCPClass (name, description, category) 
VALUES ('Keter', 'Dangereux et difficiles à contenir.', 'Primaire');
-- Thaumiel
INSERT INTO SCPClass (name, description, category) 
VALUES ('Thaumiel', 'Utilisés par la Fondation pour contenir d’autres SCP.', 'Secondaire');
-- Apollyon
INSERT INTO SCPClass (name, description, category) 
VALUES ('Apollyon', 'Impossible à contenir.', 'Secondaire');
-- Archon
INSERT INTO SCPClass (name, description, category) 
VALUES ('Archon', 'Peuvent être théoriquement contenus mais ne le sont pas pour certaines raisons.', 'Secondaire');
-- Ticonderoga
INSERT INTO SCPClass (name, description, category) 
VALUES ('Ticonderoga', 'Impossible à contenir mais n’ayant pas besoin d’être contenus.', 'Secondaire');

-- SCPClassification
INSERT INTO SCPClassification (color, description) 
VALUES ('Vert', 'Danger minimal - Confinement simple et stable');

INSERT INTO SCPClassification (color, description) 
VALUES ('Jaune', 'Danger modéré - Surveillance régulière requise');

INSERT INTO SCPClassification (color, description) 
VALUES ('Orange', 'Danger élevé - Procédures de sécurité strictes');

INSERT INTO SCPClassification (color, description) 
VALUES ('Rouge', 'Danger critique - Confinement spécial et personnel hautement qualifié');

INSERT INTO SCPClassification (color, description) 
VALUES ('Noir', 'Danger existentiel - Confinement prioritaire, accès limité au niveau O5');

INSERT INTO SCPClassification (color, description) 
VALUES ('Bleu', 'Ressource stratégique - Utilisé pour le confinement d’autres SCP');

INSERT INTO SCPClassification (color, description) 
VALUES ('Violet', 'Anomalie surveillée - Non confiné mais sous observation');

-- Sites
-- INSERT INTO Site (address, description, cell) 
-- VALUES ('TODO', 'TODO', 'TODO');

-- UserClass
INSERT INTO UserClass (level, description, authorization) 
VALUES (5, 'Conseil O5 - Supervision de la Fondation, accès total à tous les fichiers', 'Classe A - Accès illimité');

INSERT INTO UserClass (level, description, authorization) 
VALUES (4, 'Direction de site et hauts responsables, gestion des équipes et incidents critiques', 'Classe B - Accès élevé');

INSERT INTO UserClass (level, description, authorization) 
VALUES (3, 'Chercheurs et agents de terrain, accès aux SCP liés à leurs travaux', 'Classe C - Accès moyen');

INSERT INTO UserClass (level, description, authorization) 
VALUES (1, 'Personnel de classe D, majoritairement composé de prisonniers utilisés comme testeurs', 'Classe D - Accès minimal');

INSERT INTO UserClass (level, description, authorization) 
VALUES (2, 'Personnel en quarantaine après exposition à des SCP', 'Classe E - Accès conditionnel');

INSERT INTO UserClass (level, description, authorization) 
VALUES (0, 'Visiteurs et personnel non autorisé', 'Non classifié - Accès public uniquement');

-- SCPs
-- INSERT INTO SCP (number, title, description, image, threat_level, nationality, id_scp_class, id_scp_classification, id_site) 
-- VALUES ('TODO', 'TODO', 'TODO', 'TODO.jpg', 'TODO', 'TODO', 0, 0, 0);

-- Utilisateurs
-- INSERT INTO `User` (first_name, last_name, user_name, email, id_user_class) 
-- VALUES ('TODO', 'TODO', 'TODO', 'to.do@foundation.scp', 0);

INSERT INTO `User` (first_name, last_name, user_name, email, id_user_class) 
VALUES ('Christofeur', 'GERARD', 'Christ0u', 'Christ0u.gerard@foundation.scp', 3);

INSERT INTO `User` (first_name, last_name, user_name, email, id_user_class) 
VALUES ('Danaé', 'ALBRECHT--MARTIN', 'YumieY0ru', 'YumieY0ru.albrechtmartin@foundation.scp', 2);
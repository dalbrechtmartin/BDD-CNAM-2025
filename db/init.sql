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
INSERT INTO SCPClass (name, description, category) VALUES
('Safe', 'Contenus et sans risque immédiat.', 'Primaire'),
('Euclid', 'Imprévisibles, nécessitant une surveillance constante.', 'Primaire'),
('Keter', 'Dangereux et difficiles à contenir.', 'Primaire'),
('Thaumiel', 'Utilisés par la Fondation pour contenir d’autres SCP.', 'Secondaire'),
('Apollyon', 'Impossible à contenir.', 'Secondaire'),
('Archon', 'Peuvent être théoriquement contenus mais ne le sont pas pour certaines raisons.', 'Secondaire'),
('Ticonderoga', 'Impossible à contenir mais n’ayant pas besoin d’être contenus.', 'Secondaire');

-- SCPClassification
INSERT INTO SCPClassification (color, description) VALUES
('Vert', 'Danger minimal - Confinement simple et stable'),
('Jaune', 'Danger modéré - Surveillance régulière requise'),
('Orange', 'Danger élevé - Procédures de sécurité strictes'),
('Rouge', 'Danger critique - Confinement spécial et personnel hautement qualifié'),
('Noir', 'Danger existentiel - Confinement prioritaire, accès limité au niveau O5'),
('Bleu', 'Ressource stratégique - Utilisé pour le confinement d’autres SCP'),
('Violet', 'Anomalie surveillée - Non confiné mais sous observation');

-- Sites
INSERT INTO Site (address, description, cell)
VALUES ('Site-19, USA', 'Plus grande installation de la Fondation, spécialisée dans le confinement d’entités Euclide et Keter', 'Secteur B');

-- UserClass
INSERT INTO UserClass (level, description, authorization) VALUES
(5, 'Conseil O5 - Supervision de la Fondation, accès total à tous les fichiers', 'Classe A - Accès illimité'),
(4, 'Direction de site et hauts responsables, gestion des équipes et incidents critiques', 'Classe B - Accès élevé'),
(3, 'Chercheurs et agents de terrain, accès aux SCP liés à leurs travaux', 'Classe C - Accès moyen'),
(1, 'Personnel de classe D, majoritairement composé de prisonniers utilisés comme testeurs', 'Classe D - Accès minimal'),
(2, 'Personnel en quarantaine après exposition à des SCP', 'Classe E - Accès conditionnel'),
(0, 'Visiteurs et personnel non autorisé', 'Non classifié - Accès public uniquement');

-- SCPs (SCP-173, id_scp_class=2 (Euclid), id_scp_classification=4 (Rouge), id_site=1)
INSERT INTO SCP (
    number, title, description, image, threat_level, nationality,
    id_scp_class, id_scp_classification, id_site
) VALUES (
    'SCP-173',
    'La Sculpture',
    'Statue humanoïde en béton et barres d’armature recouverte de peinture acrylique. L’entité est animée et extrêmement hostile, mais ne peut bouger que lorsqu’elle n’est pas observée directement.',
    'scp173.jpg',
    'Élevé',
    'Inconnue',
    2,  -- id_scp_class (Euclid)
    4,  -- id_scp_classification (Rouge)
    1   -- id_site (Site-19)
);

-- Utilisateurs (id_user_class: 5=Classe A, 4=Classe B, 3=Classe C, 2=Classe E)
INSERT INTO `User` (first_name, last_name, user_name, email, id_user_class) VALUES
('Christofeur', 'GERARD', 'Christ0u', 'Christ0u.gerard@foundation.scp', 1), -- Classe D
('Elliot', 'CARTER', 'ecarter', 'elliot.carter@foundation.scp', 2),         -- Classe E
('Paul', 'MARTIN', 'pmartin', 'paul.martin@foundation.scp', 3),              -- Classe C
('Danaé', 'ALBRECHT--MARTIN', 'YumieY0ru', 'YumieY0ru.albrechtmartin@foundation.scp', 4); -- Classe B

-- Incidents (id_scp=1 si SCP-173 est le premier SCP inséré)
INSERT INTO Incident (title, date, description, id_scp) VALUES
('Attaque lors d\'un test de surveillance', '2025-06-24', 'Un garde de classe C a été attaqué par SCP-173 alors qu’il prétendait ne jamais l’avoir quitté des yeux. Rapport marqué comme "Non vérifié".', 1),
('Découverte d\'une nouvelle anomalie', '2025-06-23', 'SCP-173 a manifesté la capacité de se déplacer à travers des surfaces réfléchissantes. Rapport classé "Classe A - Accès restreint".', 1);

-- Affectation chercheur -> site (optionnel, id_site=1, id_user=2 pour Elliot Carter)
INSERT INTO Work (id_site, id_user) VALUES (1, 2);

-- Procédures stockées
DELIMITER $$

CREATE PROCEDURE GetSCPIncidentsIfClassA(
    IN p_user_id INT,
    IN p_scp_number VARCHAR(20)
)
BEGIN
    DECLARE user_level INT;

    -- Récupérer le niveau de classe de l'utilisateur
    SELECT uc.level INTO user_level
    FROM `User` u
    JOIN UserClass uc ON u.id_user_class = uc.id_user_class
    WHERE u.id_user = p_user_id;

    IF user_level = 5 THEN
        -- Afficher les incidents liés au SCP demandé
        SELECT i.id_incident, i.title, i.date, i.description, scp.number AS scp_number
        FROM Incident i
        JOIN SCP scp ON i.id_scp = scp.id_scp
        WHERE scp.number = p_scp_number;
    ELSE
        -- Message d'alerte si l'utilisateur n'est pas Classe A
        SELECT 'Alerte : ce fichier dépasse votre niveau. Demandez une autorisation temporaire.' AS message;
    END IF;
END$$

DELIMITER ;

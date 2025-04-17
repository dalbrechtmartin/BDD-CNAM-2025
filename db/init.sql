-- Créer la base
CREATE DATABASE IF NOT EXISTS scp_db;
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
    id_scp_classFK INT,
    id_scp_classificationFK INT,
    id_siteFK INT,
    FOREIGN KEY (id_scp_classFK) REFERENCES SCPClass(id_scp_class),
    FOREIGN KEY (id_scp_classificationFK) REFERENCES SCPClassification(id_scp_classification),
    FOREIGN KEY (id_siteFK) REFERENCES Site(id_site)
);

CREATE TABLE `User` (
    id_user INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    user_name VARCHAR(100) UNIQUE,
    email VARCHAR(100) UNIQUE,
    id_user_classFK INT,
    FOREIGN KEY (id_user_classFK) REFERENCES UserClass(id_user_class)
);

CREATE TABLE Incident (
    id_incident INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    date DATE,
    description TEXT,
    id_scpFK INT,
    FOREIGN KEY (id_scpFK) REFERENCES SCP(id_scp)
);

CREATE TABLE Work (
    id_siteFK INT,
    id_userFK INT,
    PRIMARY KEY (id_siteFK, id_userFK),
    FOREIGN KEY (id_siteFK) REFERENCES Site(id_site),
    FOREIGN KEY (id_userFK) REFERENCES `User`(id_user)
);

CREATE TABLE Access (
    id_scpFK INT,
    id_userFK INT,
    date_access DATETIME,
    PRIMARY KEY (id_scpFK, id_userFK, date_access),
    FOREIGN KEY (id_scpFK) REFERENCES SCP(id_scp),
    FOREIGN KEY (id_userFK) REFERENCES `User`(id_user)
);

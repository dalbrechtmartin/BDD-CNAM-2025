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
INSERT INTO SCPClass (name, description, category) VALUES
('Safe', 'Contenus et sans risque immédiat.', 'Primaire'),
('Euclid', 'Imprévisibles, nécessitant une surveillance constante.', 'Primaire'),
('Keter', 'Dangereux et difficiles à contenir.', 'Primaire'),
('Thaumiel', 'Utilisés par la Fondation pour contenir d''autres SCP.', 'Secondaire'),
('Apollyon', 'Impossible à contenir.', 'Secondaire'),
('Archon', 'Peuvent être théoriquement contenus mais ne le sont pas pour certaines raisons.', 'Secondaire'),
('Ticonderoga', 'Impossible à contenir mais n''ayant pas besoin d''être contenus.', 'Secondaire');

-- SCPClassification
INSERT INTO SCPClassification (color, description) VALUES
('Vert', 'Danger minimal - Confinement simple et stable'),
('Jaune', 'Danger modéré - Surveillance régulière requise'),
('Orange', 'Danger élevé - Procédures de sécurité strictes'),
('Rouge', 'Danger critique - Confinement spécial et personnel hautement qualifié'),
('Noir', 'Danger existentiel - Confinement prioritaire, accès limité au niveau O5'),
('Bleu', 'Ressource stratégique - Utilisé pour le confinement d''autres SCP'),
('Violet', 'Anomalie surveillée - Non confiné mais sous observation');

-- Sites
INSERT INTO Site (address, description, cell)
VALUES ('Site-19, USA', 'Plus grande installation de la Fondation, spécialisée dans le confinement d''entités Euclide et Keter', 'Secteur B');

-- UserClass
INSERT INTO UserClass (level, description, authorization) VALUES
(5, 'Conseil O5 - Supervision de la Fondation, accès total à tous les fichiers', 'Classe A - Accès illimité'),
(4, 'Direction de site et hauts responsables, gestion des équipes et incidents critiques', 'Classe B - Accès élevé'),
(3, 'Chercheurs et agents de terrain, accès aux SCP liés à leurs travaux', 'Classe C - Accès moyen'),
(1, 'Personnel de classe D, majoritairement composé de prisonniers utilisés comme testeurs', 'Classe D - Accès minimal'),
(2, 'Personnel en quarantaine après exposition à des SCP', 'Classe E - Accès conditionnel'),
(0, 'Visiteurs et personnel non autorisé', 'Non classifié - Accès public uniquement');

-- SCPs
INSERT INTO SCP (
    number, title, description, image, threat_level, nationality,
    id_scp_class, id_scp_classification, id_site
) VALUES (
    'SCP-173',
    'La Sculpture',
    'Statue humanoïde en béton et barres d''armature recouverte de peinture acrylique. L''entité est animée et extrêmement hostile, mais ne peut bouger que lorsqu''elle n''est pas observée directement.',
    'scp173.jpg',
    'Élevé',
    'Inconnue',
    2,  -- id_scp_class (Euclid)
    4,  -- id_scp_classification (Rouge)
    1   -- id_site (Site-19)
),
(
    'SCP-001',
    '[DONNÉES EXPURGÉES]',
    '[ACCÈS RESTREINT - NIVEAU O5 UNIQUEMENT] Ce fichier contient des informations classifiées concernant [DONNÉES EXPURGÉES]. Toute tentative d''accès non autorisé sera sanctionnée conformément au Protocole de Sécurité Alpha.',
    'scp001_classified.jpg',
    'MAXIMUM',
    '[EXPURGÉ]',
    5,  -- id_scp_class (Apollyon)
    5,  -- id_scp_classification (Noir)
    1   -- id_site (Site-19)
),
(
    'SCP-3008',
    'L''IKEA Infini',
    'SCP-3008 est un grand magasin de meubles ayant l''apparence d''un IKEA typique. Toute personne entrant dans SCP-3008 pendant les heures d''ouverture devient incapable de sortir. L''intérieur de SCP-3008 s''étend apparemment à l''infini et contient une société humaine improvisée de personnes piégées.',
    'scp3008.jpg',
    'Élevé',
    'Nevada, USA',
    2,  -- id_scp_class (Euclid)
    3,  -- id_scp_classification (Orange)
    1   -- id_site (Site-19)
);

-- Utilisateurs
INSERT INTO `User` (first_name, last_name, user_name, email, id_user_class) VALUES
('Christofeur', 'GERARD', 'Christ0u', 'Christ0u.gerard@foundation.scp', 5),                 -- Classe A
('Elliot', 'CARTER', 'ecarter', 'elliot.carter@foundation.scp', 4),                         -- Classe B
('Paul', 'MARTIN', 'pmartin', 'paul.martin@foundation.scp', 3),                             -- Classe C
('Danaé', 'ALBRECHT--MARTIN', 'YumieY0ru', 'YumieY0ru.albrechtmartin@foundation.scp', 2),   -- Classe E
('Michael', 'THOMPSON', 'mthompson', 'michael.thompson@foundation.scp', 3),                 -- Classe C
('Dr. James', 'HAYWARD', 'jhayward', 'james.hayward@foundation.scp', 4),                    -- Classe B (décédé)
('Agent Maria', 'RAMIREZ', 'mramirez', 'maria.ramirez@foundation.scp', 3);                  -- Classe C
('D-5847', 'ROBINSON', 'd5847', 'd5847@foundation.scp', 1);                                 -- Classe D

-- Incidents
INSERT INTO Incident (title, date, description, id_scp) VALUES
('Attaque lors d''un test de surveillance', '2025-06-24', 'Un garde de classe C a été attaqué par SCP-173 alors qu''il prétendait ne jamais l''avoir quitté des yeux. Rapport marqué comme "Non vérifié".', 1),
('Découverte d''une nouvelle anomalie', '2025-06-23', 'SCP-173 a manifesté la capacité de se déplacer à travers des surfaces réfléchissantes. Rapport classé "Classe A - Accès restreint".', 1),
('Tentative d''accès non autorisé - INCIDENT CRITIQUE', '2025-06-27', 'ALERTE SÉCURITÉ : Détection d''une tentative d''accès au dossier SCP-001 par l''utilisateur jhayward (Dr. James Hayward), officiellement décédé il y a 3 ans lors d''un incident de confinement. Origine : Terminal-B7-Site19. Protocole de verrouillage automatique activé. Incident assigné à Michael Thompson (cybersécurité) pour investigation. Équipe de sécurité Classe A déployée.', 2),
('Disparitions inexpliquées - Nevada', '2025-06-26', 'Série de disparitions signalées dans une petite ville du Nevada. Les témoins mentionnent un magasin de meubles isolé. Investigation en cours par l''Agent Ramirez.', 3),
('Témoignage de survivant - Évasion SCP-3008', '2024-12-15', 'Témoignage de [CENSURÉ] : "J''ai trouvé une zone où les murs semblaient instables, comme s''ils scintillaient. J''ai poussé fort et soudain je me suis retrouvé dehors. Les employés d''IKEA ne m''ont pas suivi." Méthode d''évasion confirmée par 3 autres survivants.', 3),
('Attaque nocturne - Employés hostiles', '2024-08-10', 'Témoignage multiple : entités humanoïdes en uniforme IKEA attaquent systématiquement les survivants pendant la nuit. Recommandation : éviter les zones ouvertes après la fermeture des lumières du magasin.', 3);

-- Affectation chercheur -> site
INSERT INTO Work (id_site, id_user) VALUES 
(1, 2),  -- Elliot Carter au Site-19
(1, 5),  -- Michael Thompson au Site-19
(1, 7);  -- Agent Ramirez au Site-19

-- Données pour le scénario 2 : Tentatives d''accès suspectes
INSERT INTO Access (id_scp, id_user, date_access) VALUES 
(2, 6, '2025-06-27 14:32:17'),  -- Dr. Hayward tente d''accéder à SCP-001
(2, 6, '2025-06-27 14:32:45'),  -- Seconde tentative 28 secondes plus tard
(2, 6, '2025-06-27 14:33:02');  -- Troisième tentative bloquée par le système

-- Procédures stockées
DELIMITER $$

CREATE PROCEDURE GetSCPIncidentsIfClassA(
    IN p_user_id INT,
    IN p_scp_number VARCHAR(20)
)
BEGIN
    DECLARE user_level INT;

    -- Récupérer le niveau de classe de l''utilisateur
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
        -- Message d''alerte si l''utilisateur n''est pas Classe A
        SELECT 'Alerte : ce fichier dépasse votre niveau. Demandez une autorisation temporaire.' AS message;
    END IF;
END$$

-- Procédure pour analyser les accès suspects (Scénario 2)
CREATE PROCEDURE GetSuspiciousAccess(
    IN p_user_id INT
)
BEGIN
    DECLARE user_level INT;
    
    -- Récupérer le niveau de l''utilisateur
    SELECT uc.level INTO user_level
    FROM `User` u
    JOIN UserClass uc ON u.id_user_class = uc.id_user_class
    WHERE u.id_user = p_user_id;
    
    -- Seuls les utilisateurs de Classe C et plus peuvent consulter les accès suspects
    IF user_level >= 3 THEN
        SELECT 
            a.date_access,
            u.user_name,
            CONCAT(u.first_name, ' ', u.last_name) as full_name,
            s.number as scp_number,
            s.title as scp_title,
            uc.description as user_class,
            'ACCÈS SUSPECT' as alert_type
        FROM Access a
        JOIN `User` u ON a.id_user = u.id_user
        JOIN SCP s ON a.id_scp = s.id_scp
        JOIN UserClass uc ON u.id_user_class = uc.id_user_class
        WHERE s.number = 'SCP-001'
        ORDER BY a.date_access DESC;
    ELSE
        SELECT 'ACCÈS REFUSÉ: Niveau de sécurité insuffisant.' as message;
    END IF;
END$$

-- Procédure de recherche par mots-clés (Scénario 3)
CREATE PROCEDURE SearchSCPByKeywords(
    IN p_user_id INT,
    IN p_keywords VARCHAR(255)
)
BEGIN
    DECLARE user_level INT;
    
    -- Récupérer le niveau de l''utilisateur
    SELECT uc.level INTO user_level
    FROM `User` u
    JOIN UserClass uc ON u.id_user_class = uc.id_user_class
    WHERE u.id_user = p_user_id;
    
    -- Seuls les utilisateurs de Classe C et plus peuvent faire des recherches
    IF user_level >= 3 THEN
        SELECT 
            s.number,
            s.title,
            s.description,
            sc.name as scp_class,
            scl.color as classification,
            s.threat_level,
            s.nationality,
            'CORRESPONDANCE TROUVÉE' as search_result
        FROM SCP s
        JOIN SCPClass sc ON s.id_scp_class = sc.id_scp_class
        JOIN SCPClassification scl ON s.id_scp_classification = scl.id_scp_classification
        WHERE LOWER(s.description) LIKE CONCAT('%', LOWER(p_keywords), '%')
           OR LOWER(s.title) LIKE CONCAT('%', LOWER(p_keywords), '%')
           OR LOWER(s.nationality) LIKE CONCAT('%', LOWER(p_keywords), '%')
        ORDER BY s.threat_level DESC, s.number;
    ELSE
        SELECT 'ACCÈS REFUSÉ: Niveau de sécurité insuffisant pour effectuer des recherches.' as message;
    END IF;
END$$

-- Procédure pour obtenir les témoignages de survivants (Scénario 3)
CREATE PROCEDURE GetSurvivorTestimonies(
    IN p_user_id INT,
    IN p_scp_number VARCHAR(20)
)
BEGIN
    DECLARE user_level INT;
    
    -- Récupérer le niveau de l''utilisateur
    SELECT uc.level INTO user_level
    FROM `User` u
    JOIN UserClass uc ON u.id_user_class = uc.id_user_class
    WHERE u.id_user = p_user_id;
    
    -- Seuls les utilisateurs de Classe C et plus peuvent consulter les témoignages
    IF user_level >= 3 THEN
        SELECT 
            i.title,
            i.date,
            i.description,
            s.number as scp_number,
            'TÉMOIGNAGE' as incident_type
        FROM Incident i
        JOIN SCP s ON i.id_scp = s.id_scp
        WHERE s.number = p_scp_number
          AND (LOWER(i.title) LIKE '%témoignage%' 
               OR LOWER(i.title) LIKE '%survivant%'
               OR LOWER(i.description) LIKE '%témoignage%')
        ORDER BY i.date DESC;
    ELSE
        SELECT 'ACCÈS REFUSÉ: Niveau de sécurité insuffisant.' as message;
    END IF;
END$$

DELIMITER ;
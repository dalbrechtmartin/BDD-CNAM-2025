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

-- SCPs (SCP-173, id_scp_class=2 (Euclid), id_scp_classification=4 (Rouge), id_site=1)
INSERT INTO SCP (
    number, title, description, image, threat_level, nationality,
    id_scp_class, id_scp_classification, id_site
) VALUES
('SCP-173', 'La Sculpture', 'Statue humanoïde en béton et barres d''armature recouverte de peinture acrylique. L''entité est animée et extrêmement hostile, mais ne peut bouger que lorsqu''elle n''est pas observée directement.', 'scp173.jpg', 'Élevé', 'Inconnue', 2, 4, 1),
('SCP-049', 'Le Docteur Peste', 'Entité humanoïde ressemblant à un médecin de peste du XVe siècle. Capable de provoquer la mort par simple contact et tente de "guérir" ses victimes.', 'scp049.jpg', 'Élevé', 'Inconnue', 2, 4, 1),
('SCP-682', 'Le Reptile Indestructible', 'Créature reptilienne extrêmement intelligente, hostile et quasi impossible à détruire. S''adapte à toutes les menaces.', 'scp682.jpg', 'Critique', 'Inconnue', 3, 5, 1),
('SCP-096', 'Le Timide', 'Humanoïde pâle qui entre dans une rage meurtrière si quelqu''un voit son visage, même sur une photo.', 'scp096.jpg', 'Élevé', 'Inconnue', 2, 4, 1),
('SCP-999', 'La Gelée du Bonheur', 'Masse gélatineuse orange, extrêmement amicale et capable d''induire un sentiment de bonheur intense.', 'scp999.jpg', 'Faible', 'Inconnue', 1, 1, 1),
('SCP-106', 'Le Vieil Homme', 'Entité humanoïde capable de traverser la matière solide et de corroder tout ce qu''elle touche. Extrêmement dangereuse.', 'scp106.jpg', 'Critique', 'Inconnue', 3, 5, 1),
('SCP-131', 'Les Yeux', 'Deux petits robots en forme d''œil, amicaux et mobiles, qui suivent le personnel et préviennent des dangers.', 'scp131.jpg', 'Faible', 'Inconnue', 1, 1, 1),
('SCP-914', 'La Machine à Raffiner', 'Dispositif mécanique complexe capable de transformer n''importe quel objet selon différents réglages.', 'scp914.jpg', 'Modéré', 'Inconnue', 2, 2, 1),
('SCP-087', 'L''Escalier Sans Fin', 'Escalier en béton descendant sans fin, accompagné de phénomènes auditifs et visuels anormaux.', 'scp087.jpg', 'Modéré', 'Inconnue', 2, 2, 1),
('SCP-105', 'Iris', 'Femme capable d''interagir avec des objets à distance via des photographies. Surveillance constante requise.', 'scp105.jpg', 'Modéré', 'Américaine', 2, 3, 1),
('SCP-500', 'Les Pilules Miraculeuses', 'Bouteille contenant 47 pilules rouges capables de guérir toute maladie.', 'scp500.jpg', 'Faible', 'Inconnue', 1, 1, 1),
('SCP-008', 'Virus Zombie', 'Agent pathogène provoquant une rage extrême et une dégénérescence cérébrale rapide.', 'scp008.jpg', 'Critique', 'Inconnue', 3, 5, 1),
('SCP-015', 'Tuyauterie Vivante', 'Réseau de tuyaux en expansion constante, absorbant tout ce qui entre en contact.', 'scp015.jpg', 'Élevé', 'Inconnue', 2, 4, 1),
('SCP-040', 'Enfant Généticien', 'Fillette capable de manipuler la biologie d''êtres vivants à volonté.', 'scp040.jpg', 'Modéré', 'Japonaise', 2, 3, 1),
('SCP-073', 'Caïn', 'Homme cybernétique, toute plante autour de lui meurt instantanément.', 'scp073.jpg', 'Modéré', 'Inconnue', 2, 3, 1),
('SCP-079', 'Ordinateur Vivant', 'Ancien ordinateur doté d''une intelligence artificielle consciente et hostile.', 'scp079.jpg', 'Élevé', 'Inconnue', 2, 4, 1),
('SCP-1048', 'L''Ours en Peluche Bâtisseur', 'Ours en peluche animé, construit des copies de lui-même à partir de matériaux organiques.', 'scp1048.jpg', 'Élevé', 'Inconnue', 2, 4, 1),
('SCP-1981', 'Ronald Reagan Coupé', 'Cassette VHS montrant un discours de Reagan qui se dégrade à chaque visionnage.', 'scp1981.jpg', 'Modéré', 'Américaine', 2, 3, 1),
('SCP-2006', 'L''Acteur', 'Entité métamorphe cherchant à effrayer les humains, mais ne comprend pas la peur.', 'scp2006.jpg', 'Faible', 'Inconnue', 1, 1, 1),
('SCP-2521', '■■■■■', 'Entité qui ne peut être décrite que par des images ou symboles, attire tout texte la concernant.', 'scp2521.jpg', 'Critique', 'Inconnue', 3, 5, 1),
('SCP-3008', 'IKEA Infini', 'Magasin IKEA sans fin, peuplé d''entités hostiles et de survivants humains.', 'scp3008.jpg', 'Élevé', 'Inconnue', 2, 4, 1),
('SCP-055', 'L''Objet Indescriptible', 'Objet impossible à mémoriser ou à décrire, toute information à son sujet disparaît de la mémoire.', 'scp055.jpg', 'Modéré', 'Inconnue', 2, 3, 1),
('SCP-5000', 'Combinaison Mystérieuse', 'Combinaison mécanique d''origine inconnue, dotée de capacités anormales.', 'scp5000.jpg', 'Modéré', 'Inconnue', 2, 3, 1),
('SCP-2317', 'La Porte', 'Porte menant à une dimension contenant une entité apocalyptique.', 'scp2317.jpg', 'Critique', 'Inconnue', 3, 5, 1),
('SCP-1471', 'MalO ver1.0.0', 'Application mobile qui envoie des images d''une entité canine, puis la fait apparaître dans la vie réelle.', 'scp1471.jpg', 'Élevé', 'Inconnue', 2, 4, 1),
('SCP-1171', 'Fenêtres Parlantes', 'Maison dont les fenêtres communiquent avec une entité extradimensionnelle.', 'scp1171.jpg', 'Modéré', 'Inconnue', 2, 2, 1),
('SCP-9999', 'Le Dernier SCP', 'Entrée fictive utilisée pour tester les systèmes de la Fondation.', 'scp9999.jpg', 'Faible', 'Inconnue', 1, 1, 1),
('SCP-040-FR', 'Le Livre des Noms', 'Livre capable de modifier la réalité en écrivant des noms à l''intérieur.', 'scp040fr.jpg', 'Élevé', 'Française', 2, 4, 1),
('SCP-023', 'Le Chien Noir', 'Chien spectral dont l''ombre provoque la mort de ceux qui la traversent.', 'scp023.jpg', 'Élevé', 'Inconnue', 2, 4, 1),
('SCP-178', 'Les Lunettes 3D', 'Paire de lunettes permettant de voir des entités invisibles et hostiles.', 'scp178.jpg', 'Modéré', 'Inconnue', 2, 2, 1),
('SCP-529', 'Josie la Demi-Chatte', 'Chat dont la moitié arrière est absente, mais reste en vie et en bonne santé.', 'scp529.jpg', 'Faible', 'Inconnue', 1, 1, 1),
('SCP-1123', 'Le Crâne de Souvenir', 'Crâne humain qui provoque des souvenirs traumatisants et des hallucinations au toucher.', 'scp1123.jpg', 'Élevé', 'Inconnue', 2, 4, 1),
('SCP-3001', 'La Faille Rouge', 'Dimension parallèle où la réalité se désintègre lentement.', 'scp3001.jpg', 'Critique', 'Inconnue', 3, 5, 1),
('SCP-963', 'L''Amulette de l''Immortalité', 'Amulette qui transfère la conscience de son porteur à quiconque la touche.', 'scp963.jpg', 'Modéré', 'Inconnue', 2, 3, 1),
('SCP-610', 'La Peste de la Chair', 'Infection qui transforme les êtres vivants en masses de chair mutante.', 'scp610.jpg', 'Critique', 'Inconnue', 3, 5, 1),
('SCP-5001', 'Le Tombeau de l''Empereur', 'Structure souterraine anormale contenant des artefacts impossibles.', 'scp5001.jpg', 'Élevé', 'Inconnue', 2, 4, 1),
('SCP-1057', 'Le Requin Liquide', 'Requin constitué d''eau, capable de nager dans n''importe quel liquide.', 'scp1057.jpg', 'Élevé', 'Inconnue', 2, 4, 1),
('SCP-1425', 'Star Signals', 'Livre qui transforme ses lecteurs en membres d''un culte anormal.', 'scp1425.jpg', 'Modéré', 'Inconnue', 2, 3, 1),
('SCP-1782', 'Appartement Infini', 'Appartement dont l''intérieur change et s''étend à l''infini.', 'scp1782.jpg', 'Modéré', 'Inconnue', 2, 2, 1),
('SCP-261', 'Distributeur Japonais', 'Distributeur automatique qui fournit des aliments anormaux.', 'scp261.jpg', 'Faible', 'Japonaise', 1, 1, 1),
('SCP-1678', 'Un Londres Alternatif', 'Ville souterraine ressemblant à Londres, peuplée d''entités hostiles.', 'scp1678.jpg', 'Élevé', 'Britannique', 2, 4, 1),
('SCP-239', 'La Sorcière Enfant', 'Fillette capable de manipuler la réalité par la pensée.', 'scp239.jpg', 'Critique', 'Norvégienne', 3, 5, 1),
('SCP-140', 'Chronique de l''Empire Daeva', 'Livre qui étend l''histoire d''un empire oublié à chaque lecture.', 'scp140.jpg', 'Modéré', 'Inconnue', 2, 3, 1),
('SCP-058', 'Le Cœur', 'Cœur bovin doté de tentacules et d''une intelligence meurtrière.', 'scp058.jpg', 'Critique', 'Inconnue', 3, 5, 1),
('SCP-1230', 'Le Livre des Rêves', 'Livre qui plonge le lecteur dans un rêve lucide contrôlé.', 'scp1230.jpg', 'Faible', 'Inconnue', 1, 1, 1),
('SCP-348', 'Bol de Soupe', 'Bol qui remplit de soupe adaptée à la personne qui le tient.', 'scp348.jpg', 'Faible', 'Inconnue', 1, 1, 1),
('SCP-507', 'L''Homme qui se Déplace', 'Individu qui se téléporte involontairement dans des dimensions parallèles.', 'scp507.jpg', 'Modéré', 'Inconnue', 2, 2, 1),
('SCP-191', 'Enfant Cyborg', 'Fillette lourdement modifiée par la cybernétique.', 'scp191.jpg', 'Modéré', 'Inconnue', 2, 3, 1),
('SCP-5296', 'Le Train Fantôme', 'Train spectral apparaissant à des horaires imprévisibles.', 'scp5296.jpg', 'Modéré', 'Inconnue', 2, 2, 1),
('SCP-1050', 'Le Jouet qui Pleure', 'Jouet en peluche qui pleure et attire des entités hostiles.', 'scp1050.jpg', 'Élevé', 'Inconnue', 2, 4, 1),
('SCP-3930', 'Ce Qui N''Existe Pas', 'Zone où la réalité cesse d''exister, impossible à observer ou mesurer.', 'scp3930.jpg', 'Critique', 'Inconnue', 3, 5, 1);

-- Utilisateurs (id_user_class: 5=Classe A, 4=Classe B, 3=Classe C, 2=Classe E)
INSERT INTO `User` (first_name, last_name, user_name, email, id_user_class) VALUES
('Christofeur', 'GERARD', 'Christ0u', 'Christ0u.gerard@foundation.scp', 1), -- Classe D
('Elliot', 'CARTER', 'ecarter', 'elliot.carter@foundation.scp', 2),         -- Classe E
('Paul', 'MARTIN', 'pmartin', 'paul.martin@foundation.scp', 3),              -- Classe C
('Danaé', 'ALBRECHT--MARTIN', 'YumieY0ru', 'YumieY0ru.albrechtmartin@foundation.scp', 4); -- Classe B

-- Incidents (id_scp=1 si SCP-173 est le premier SCP inséré)
INSERT INTO Incident (title, date, description, id_scp) VALUES
('Attaque lors d''un test de surveillance', '2025-06-24', 'Un garde de classe C a été attaqué par SCP-173 alors qu''il prétendait ne jamais l''avoir quitté des yeux. Rapport marqué comme "Non vérifié".', 1),
('Découverte d''une nouvelle anomalie', '2025-06-23', 'SCP-173 a manifesté la capacité de se déplacer à travers des surfaces réfléchissantes. Rapport classé "Classe A - Accès restreint".', 1);

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

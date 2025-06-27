-- Encodage des caractères
SET
    NAMES utf8mb4;

SET
    CHARACTER
SET
    utf8mb4;

-- Créer la base
CREATE DATABASE IF NOT EXISTS scp_db CHARACTER
SET
    utf8mb4 COLLATE utf8mb4_unicode_ci;

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
CREATE TABLE
    SCPClass (
        id_scp_class INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(100) NOT NULL,
        description TEXT,
        category VARCHAR(50)
    );

CREATE TABLE
    SCPClassification (
        id_scp_classification INT PRIMARY KEY AUTO_INCREMENT,
        color VARCHAR(50),
        description TEXT
    );

CREATE TABLE
    Site (
        id_site INT PRIMARY KEY AUTO_INCREMENT,
        address VARCHAR(255),
        description TEXT,
        cell VARCHAR(50)
    );

CREATE TABLE
    UserClass (
        id_user_class INT PRIMARY KEY AUTO_INCREMENT,
        level INT,
        description TEXT,
        authorization VARCHAR(100)
    );

CREATE TABLE
    SCP (
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
        FOREIGN KEY (id_scp_class) REFERENCES SCPClass (id_scp_class),
        FOREIGN KEY (id_scp_classification) REFERENCES SCPClassification (id_scp_classification),
        FOREIGN KEY (id_site) REFERENCES Site (id_site)
    );

CREATE TABLE
    `User` (
        id_user INT PRIMARY KEY AUTO_INCREMENT,
        first_name VARCHAR(100),
        last_name VARCHAR(100),
        user_name VARCHAR(100) UNIQUE,
        email VARCHAR(100) UNIQUE,
        id_user_class INT,
        FOREIGN KEY (id_user_class) REFERENCES UserClass (id_user_class)
    );

CREATE TABLE
    Incident (
        id_incident INT PRIMARY KEY AUTO_INCREMENT,
        title VARCHAR(255),
        date DATE,
        description TEXT,
        id_scp INT,
        FOREIGN KEY (id_scp) REFERENCES SCP (id_scp)
    );

CREATE TABLE
    Work (
        id_site INT,
        id_user INT,
        PRIMARY KEY (id_site, id_user),
        FOREIGN KEY (id_site) REFERENCES Site (id_site),
        FOREIGN KEY (id_user) REFERENCES `User` (id_user)
    );

CREATE TABLE
    Access (
        id_scp INT,
        id_user INT,
        date_access DATETIME,
        PRIMARY KEY (id_scp, id_user, date_access),
        FOREIGN KEY (id_scp) REFERENCES SCP (id_scp),
        FOREIGN KEY (id_user) REFERENCES `User` (id_user)
    );

-- Insertion des données de bases
-- SCPClass
-- Safe
INSERT INTO
    SCPClass (name, description, category)
VALUES
    (
        'Safe',
        'Contenus et sans risque immédiat.',
        'Primaire'
    ),
    (
        'Euclid',
        'Imprévisibles, nécessitant une surveillance constante.',
        'Primaire'
    ),
    (
        'Keter',
        'Dangereux et difficiles à contenir.',
        'Primaire'
    ),
    (
        'Thaumiel',
        'Utilisés par la Fondation pour contenir d''autres SCP.',
        'Secondaire'
    ),
    (
        'Apollyon',
        'Impossible à contenir.',
        'Secondaire'
    ),
    (
        'Archon',
        'Peuvent être théoriquement contenus mais ne le sont pas pour certaines raisons.',
        'Secondaire'
    ),
    (
        'Ticonderoga',
        'Impossible à contenir mais n''ayant pas besoin d''être contenus.',
        'Secondaire'
    );

-- SCPClassification
INSERT INTO
    SCPClassification (color, description)
VALUES
    (
        'Vert',
        'Danger minimal - Confinement simple et stable'
    ),
    (
        'Jaune',
        'Danger modéré - Surveillance régulière requise'
    ),
    (
        'Orange',
        'Danger élevé - Procédures de sécurité strictes'
    ),
    (
        'Rouge',
        'Danger critique - Confinement spécial et personnel hautement qualifié'
    ),
    (
        'Noir',
        'Danger existentiel - Confinement prioritaire, accès limité au niveau O5'
    ),
    (
        'Bleu',
        'Ressource stratégique - Utilisé pour le confinement d''autres SCP'
    ),
    (
        'Violet',
        'Anomalie surveillée - Non confiné mais sous observation'
    );

-- Sites
INSERT INTO
    Site (address, description, cell)
VALUES
    (
        'Site-01, Localisation Classifiée',
        'Zone sécurisée utilisée comme sauvegarde des données de toutes les installations majeures de la Fondation et lieu de rencontre pour le Conseil O5. Aucune anomalie n''est autorisée à proximité.',
        'QG-O5'
    ),
    (
        'Site-06-3, Lorraine, France',
        'Installation de confinement pour entités humaines et humanoïdes à bas risques. Anciennement aux USA et en Allemagne, déplacée en France après destruction des précédents sites.',
        'Secteur Humanoïde'
    ),
    (
        'Site-11, Midwest, USA',
        'Grande installation formant une communauté auto-suffisante avec complexe souterrain de confinement et de recherche. Utilisée pour la protection du personnel nécessitant une sécurité accrue.',
        'Secteur Principal'
    ),
    (
        'Site-15, Côte Ouest, USA',
        'Spécialisé dans l''étude et le confinement d''anomalies électriques, électroniques ou informatiques. Installations isolées électromagnétiquement.',
        'Aile Électronique'
    ),
    (
        'Site-17, Localisation Confidentielle',
        'Importante installation spécialisée dans l''étude et le confinement d''entités humanoïdes à bas risque. Personnel majoritairement médical.',
        'Secteur Médical'
    ),
    (
        'Site-23, Localisation Confidentielle',
        'Installation abritant de nombreux objets et entités biologiques métamorphiques ou transfigurants.',
        'Secteur Biologique'
    ),
    (
        'Site-28, New York, USA',
        'Site de confinement spécialisé dans les œuvres d''art et artefacts anormaux, initialement conçu pour SCP-602.',
        'Aile Artefacts'
    ),
    (
        'Site-36, Inde',
        'Site régional de confinement et de soutien pour le personnel de terrain opérant en Inde.',
        'Secteur Régional'
    ),
    (
        'Site-38, Tennessee, USA',
        'Installation spécialisée dans l''étude du Groupe d''Intérêts 388-Alphan, "Université d''Alexylva".',
        'Secteur Recherche'
    ),
    (
        'Site-43, Ontario, Canada',
        'Site de recherche et confinement sous le Lac Huron, spécialisé dans les anomalies de risque faible et modéré.',
        'Aile Recherche'
    ),
    (
        'Site-45, Océan Indien',
        'Installation de recherche armée clandestine au large de l''Australie occidentale, point de départ pour les opérations océaniques.',
        'Secteur Océanique'
    ),
    (
        'Site-54, Leipzig, Allemagne',
        'Confinement d''anomalies "partiellement inconfinables", personnel hautement armé et entrainé.',
        'Secteur Sécurité'
    ),
    (
        'Site-56, Nevada, USA',
        'Site de confinement et d''administration dans le désert de Black Rock, structure labyrinthique.',
        'Secteur Administration'
    ),
    (
        'Site-62, Localisation Confidentielle',
        'Site dimensionnel construit autour de SCP-004, agrandi pour accueillir d''autres objets.',
        'Aile Dimensionnelle'
    ),
    (
        'Site-64, Portland, USA',
        'Installation de stockage de sécurité faible à moyenne pour objets anormaux mineurs et objets de classe Sûr et Euclide.',
        'Secteur Stockage'
    ),
    (
        'Site-66, Localisation Confidentielle',
        'Site de confinement biologique agrandi pour recherches sur anomalies organiques.',
        'Bio-Secteur'
    ),
    (
        'Site-73, Texas, USA',
        'Confinement et étude d''objets inertes, de classe Sûr ou sujets à des anomalies bénignes.',
        'Secteur Inerte'
    ),
    (
        'Site-76, USA',
        'Site reliquaire de recherche et de confinement pour anomalies supposément créées par l''homme.',
        'Secteur Reliquaire'
    ),
    (
        'Site-77, Italie',
        'Grande installation de stockage, centre de surveillance de la Région Européenne.',
        'Secteur Stockage'
    ),
    (
        'Site-81, Indiana, USA',
        'Centre principal de l''activité anormale dans le Midwest, abrite le Département des Classifications et un avant-poste FIM.',
        'Secteur Principal'
    ),
    (
        'Site-87, Sloth''s Pit, Wisconsin, USA',
        'Site de recherche établi pour superviser le confinement d''une anomalie majeure dans la ville de Sloth''s Pit, Nexus très actif. Sert aussi de quartier général du Département des Affaires Multi-Universelles.',
        'Secteur Recherche'
    ),
    (
        'Site-88, Comté de Baldwin, Alabama, USA',
        'Site de confinement des humanoïdes, abritant de nombreux objets SCP humanoïdes et objets anormaux de grande valeur.',
        'Secteur Humanoïde'
    ),
    (
        'Site-91, Yorkshire, Angleterre',
        'Site de confinement et de recherche xénobiologique, basé sur les fondations d''un manoir, spécialisé dans l''analyse thaumaturgique.',
        'Secteur Xénobiologie'
    ),
    (
        'Site-95, Localisation Confidentielle',
        'Site de recherche et de confinement biologique, utilisé pour contenir et étudier les anomalies biologiques et organiques.',
        'Bio-Secteur'
    ),
    (
        'Site-98, Philadelphie, USA',
        'Site de recherche dimensionnel à la pointe de la technologie, responsable des innovations et développements technologiques de la Fondation.',
        'Secteur Dimensionnel'
    ),
    (
        'Site-103, Localisation Confidentielle',
        'Site de confinement biologique disposant de vastes installations pour la recherche sur des anomalies végétales.',
        'Secteur Botanique'
    ),
    (
        'Site-104, Localisation Confidentielle',
        'Site de recherche biologique conçu pour l''étude d''anomalies biologiques à grande échelle.',
        'Secteur Recherche'
    ),
    (
        'Zone-02, Localisation Confidentielle',
        'Reliquaire armé et zone de confinement pour anomalies hautement dangereuses, équipé de plusieurs ogives nucléaires.',
        'Zone Armée'
    ),
    (
        'Zone-12, Midwest, USA',
        'Zone de recherche biologique contenant des spécimens vivants et des entités biologiques anormales.',
        'Zone Biologique'
    ),
    (
        'Zone-14, Chaîne de montagnes Ruby, Nevada, USA',
        'Zone de confinement biologique armée pour entités anormales de grande taille et dangereuses.',
        'Zone Armée'
    ),
    (
        'Zone-32, Mare Imbrium, Lune',
        'Zone lunaire utilisée pour confiner des anomalies immobiles présentes sur la surface lunaire.',
        'Zone Lunaire'
    ),
    (
        'Zone-179, Pennsylvanie, USA',
        'Zone de confinement provisoire devenue permanente, abritant plusieurs objets SCP.',
        'Zone Provisoire'
    );

-- UserClass
INSERT INTO
    UserClass (level, description, authorization)
VALUES
    (
        5,
        'Conseil O5 - Supervision de la Fondation, accès total à tous les fichiers',
        'Classe A - Accès illimité'
    ),
    (
        4,
        'Direction de site et hauts responsables, gestion des équipes et incidents critiques',
        'Classe B - Accès élevé'
    ),
    (
        3,
        'Chercheurs et agents de terrain, accès aux SCP liés à leurs travaux',
        'Classe C - Accès moyen'
    ),
    (
        1,
        'Personnel de classe D, majoritairement composé de prisonniers utilisés comme testeurs',
        'Classe D - Accès minimal'
    ),
    (
        2,
        'Personnel en quarantaine après exposition à des SCP',
        'Classe E - Accès conditionnel'
    ),
    (
        0,
        'Visiteurs et personnel non autorisé',
        'Non classifié - Accès public uniquement'
    );

-- SCPs (SCP-173, id_scp_class=2 (Euclid), id_scp_classification=4 (Rouge), id_site=1)
INSERT INTO
    SCP (
        number,
        title,
        description,
        image,
        threat_level,
        nationality,
        id_scp_class,
        id_scp_classification,
        id_site
    )
VALUES
    (
        'SCP-173',
        'La Sculpture',
        'Statue humanoïde en béton et barres d''armature recouverte de peinture acrylique. L''entité est animée et extrêmement hostile, mais ne peut bouger que lorsqu''elle n''est pas observée directement.',
        'scp173.jpg',
        'Élevé',
        'Inconnue',
        2,
        4,
        1
    ),
    (
        'SCP-049',
        'Le Docteur Peste',
        'Entité humanoïde ressemblant à un médecin de peste du XVe siècle. Capable de provoquer la mort par simple contact et tente de "guérir" ses victimes.',
        'scp049.jpg',
        'Élevé',
        'Inconnue',
        2,
        4,
        1
    ),
    (
        'SCP-682',
        'Le Reptile Indestructible',
        'Créature reptilienne extrêmement intelligente, hostile et quasi impossible à détruire. S''adapte à toutes les menaces.',
        'scp682.jpg',
        'Critique',
        'Inconnue',
        3,
        5,
        1
    ),
    (
        'SCP-096',
        'Le Timide',
        'Humanoïde pâle qui entre dans une rage meurtrière si quelqu''un voit son visage, même sur une photo.',
        'scp096.jpg',
        'Élevé',
        'Inconnue',
        2,
        4,
        1
    ),
    (
        'SCP-999',
        'La Gelée du Bonheur',
        'Masse gélatineuse orange, extrêmement amicale et capable d''induire un sentiment de bonheur intense.',
        'scp999.jpg',
        'Faible',
        'Inconnue',
        1,
        1,
        1
    ),
    (
        'SCP-106',
        'Le Vieil Homme',
        'Entité humanoïde capable de traverser la matière solide et de corroder tout ce qu''elle touche. Extrêmement dangereuse.',
        'scp106.jpg',
        'Critique',
        'Inconnue',
        3,
        5,
        1
    ),
    (
        'SCP-131',
        'Les Yeux',
        'Deux petits robots en forme d''œil, amicaux et mobiles, qui suivent le personnel et préviennent des dangers.',
        'scp131.jpg',
        'Faible',
        'Inconnue',
        1,
        1,
        1
    ),
    (
        'SCP-914',
        'La Machine à Raffiner',
        'Dispositif mécanique complexe capable de transformer n''importe quel objet selon différents réglages.',
        'scp914.jpg',
        'Modéré',
        'Inconnue',
        2,
        2,
        1
    ),
    (
        'SCP-087',
        'L''Escalier Sans Fin',
        'Escalier en béton descendant sans fin, accompagné de phénomènes auditifs et visuels anormaux.',
        'scp087.jpg',
        'Modéré',
        'Inconnue',
        2,
        2,
        1
    ),
    (
        'SCP-105',
        'Iris',
        'Femme capable d''interagir avec des objets à distance via des photographies. Surveillance constante requise.',
        'scp105.jpg',
        'Modéré',
        'Américaine',
        2,
        3,
        1
    ),
    (
        'SCP-500',
        'Les Pilules Miraculeuses',
        'Bouteille contenant 47 pilules rouges capables de guérir toute maladie.',
        'scp500.jpg',
        'Faible',
        'Inconnue',
        1,
        1,
        1
    ),
    (
        'SCP-008',
        'Virus Zombie',
        'Agent pathogène provoquant une rage extrême et une dégénérescence cérébrale rapide.',
        'scp008.jpg',
        'Critique',
        'Inconnue',
        3,
        5,
        1
    ),
    (
        'SCP-015',
        'Tuyauterie Vivante',
        'Réseau de tuyaux en expansion constante, absorbant tout ce qui entre en contact.',
        'scp015.jpg',
        'Élevé',
        'Inconnue',
        2,
        4,
        1
    ),
    (
        'SCP-040',
        'Enfant Généticien',
        'Fillette capable de manipuler la biologie d''êtres vivants à volonté.',
        'scp040.jpg',
        'Modéré',
        'Japonaise',
        2,
        3,
        1
    ),
    (
        'SCP-073',
        'Caïn',
        'Homme cybernétique, toute plante autour de lui meurt instantanément.',
        'scp073.jpg',
        'Modéré',
        'Inconnue',
        2,
        3,
        1
    ),
    (
        'SCP-079',
        'Ordinateur Vivant',
        'Ancien ordinateur doté d''une intelligence artificielle consciente et hostile.',
        'scp079.jpg',
        'Élevé',
        'Inconnue',
        2,
        4,
        1
    ),
    (
        'SCP-1048',
        'L''Ours en Peluche Bâtisseur',
        'Ours en peluche animé, construit des copies de lui-même à partir de matériaux organiques.',
        'scp1048.jpg',
        'Élevé',
        'Inconnue',
        2,
        4,
        1
    ),
    (
        'SCP-1981',
        'Ronald Reagan Coupé',
        'Cassette VHS montrant un discours de Reagan qui se dégrade à chaque visionnage.',
        'scp1981.jpg',
        'Modéré',
        'Américaine',
        2,
        3,
        1
    ),
    (
        'SCP-2006',
        'L''Acteur',
        'Entité métamorphe cherchant à effrayer les humains, mais ne comprend pas la peur.',
        'scp2006.jpg',
        'Faible',
        'Inconnue',
        1,
        1,
        1
    ),
    (
        'SCP-2521',
        '■■■■■',
        'Entité qui ne peut être décrite que par des images ou symboles, attire tout texte la concernant.',
        'scp2521.jpg',
        'Critique',
        'Inconnue',
        3,
        5,
        1
    ),
    (
        'SCP-3008',
        'IKEA Infini',
        'Magasin IKEA sans fin, peuplé d''entités hostiles et de survivants humains.',
        'scp3008.jpg',
        'Élevé',
        'Inconnue',
        2,
        4,
        1
    ),
    (
        'SCP-055',
        'L''Objet Indescriptible',
        'Objet impossible à mémoriser ou à décrire, toute information à son sujet disparaît de la mémoire.',
        'scp055.jpg',
        'Modéré',
        'Inconnue',
        2,
        3,
        1
    ),
    (
        'SCP-5000',
        'Combinaison Mystérieuse',
        'Combinaison mécanique d''origine inconnue, dotée de capacités anormales.',
        'scp5000.jpg',
        'Modéré',
        'Inconnue',
        2,
        3,
        1
    ),
    (
        'SCP-2317',
        'La Porte',
        'Porte menant à une dimension contenant une entité apocalyptique.',
        'scp2317.jpg',
        'Critique',
        'Inconnue',
        3,
        5,
        1
    ),
    (
        'SCP-1471',
        'MalO ver1.0.0',
        'Application mobile qui envoie des images d''une entité canine, puis la fait apparaître dans la vie réelle.',
        'scp1471.jpg',
        'Élevé',
        'Inconnue',
        2,
        4,
        1
    ),
    (
        'SCP-1171',
        'Fenêtres Parlantes',
        'Maison dont les fenêtres communiquent avec une entité extradimensionnelle.',
        'scp1171.jpg',
        'Modéré',
        'Inconnue',
        2,
        2,
        1
    ),
    (
        'SCP-9999',
        'Le Dernier SCP',
        'Entrée fictive utilisée pour tester les systèmes de la Fondation.',
        'scp9999.jpg',
        'Faible',
        'Inconnue',
        1,
        1,
        1
    ),
    (
        'SCP-040-FR',
        'Le Livre des Noms',
        'Livre capable de modifier la réalité en écrivant des noms à l''intérieur.',
        'scp040fr.jpg',
        'Élevé',
        'Française',
        2,
        4,
        1
    ),
    (
        'SCP-023',
        'Le Chien Noir',
        'Chien spectral dont l''ombre provoque la mort de ceux qui la traversent.',
        'scp023.jpg',
        'Élevé',
        'Inconnue',
        2,
        4,
        1
    ),
    (
        'SCP-178',
        'Les Lunettes 3D',
        'Paire de lunettes permettant de voir des entités invisibles et hostiles.',
        'scp178.jpg',
        'Modéré',
        'Inconnue',
        2,
        2,
        1
    ),
    (
        'SCP-529',
        'Josie la Demi-Chatte',
        'Chat dont la moitié arrière est absente, mais reste en vie et en bonne santé.',
        'scp529.jpg',
        'Faible',
        'Inconnue',
        1,
        1,
        1
    ),
    (
        'SCP-1123',
        'Le Crâne de Souvenir',
        'Crâne humain qui provoque des souvenirs traumatisants et des hallucinations au toucher.',
        'scp1123.jpg',
        'Élevé',
        'Inconnue',
        2,
        4,
        1
    ),
    (
        'SCP-3001',
        'La Faille Rouge',
        'Dimension parallèle où la réalité se désintègre lentement.',
        'scp3001.jpg',
        'Critique',
        'Inconnue',
        3,
        5,
        1
    ),
    (
        'SCP-963',
        'L''Amulette de l''Immortalité',
        'Amulette qui transfère la conscience de son porteur à quiconque la touche.',
        'scp963.jpg',
        'Modéré',
        'Inconnue',
        2,
        3,
        1
    ),
    (
        'SCP-610',
        'La Peste de la Chair',
        'Infection qui transforme les êtres vivants en masses de chair mutante.',
        'scp610.jpg',
        'Critique',
        'Inconnue',
        3,
        5,
        1
    ),
    (
        'SCP-5001',
        'Le Tombeau de l''Empereur',
        'Structure souterraine anormale contenant des artefacts impossibles.',
        'scp5001.jpg',
        'Élevé',
        'Inconnue',
        2,
        4,
        1
    ),
    (
        'SCP-1057',
        'Le Requin Liquide',
        'Requin constitué d''eau, capable de nager dans n''importe quel liquide.',
        'scp1057.jpg',
        'Élevé',
        'Inconnue',
        2,
        4,
        1
    ),
    (
        'SCP-1425',
        'Star Signals',
        'Livre qui transforme ses lecteurs en membres d''un culte anormal.',
        'scp1425.jpg',
        'Modéré',
        'Inconnue',
        2,
        3,
        1
    ),
    (
        'SCP-1782',
        'Appartement Infini',
        'Appartement dont l''intérieur change et s''étend à l''infini.',
        'scp1782.jpg',
        'Modéré',
        'Inconnue',
        2,
        2,
        1
    ),
    (
        'SCP-261',
        'Distributeur Japonais',
        'Distributeur automatique qui fournit des aliments anormaux.',
        'scp261.jpg',
        'Faible',
        'Japonaise',
        1,
        1,
        1
    ),
    (
        'SCP-1678',
        'Un Londres Alternatif',
        'Ville souterraine ressemblant à Londres, peuplée d''entités hostiles.',
        'scp1678.jpg',
        'Élevé',
        'Britannique',
        2,
        4,
        1
    ),
    (
        'SCP-239',
        'La Sorcière Enfant',
        'Fillette capable de manipuler la réalité par la pensée.',
        'scp239.jpg',
        'Critique',
        'Norvégienne',
        3,
        5,
        1
    ),
    (
        'SCP-140',
        'Chronique de l''Empire Daeva',
        'Livre qui étend l''histoire d''un empire oublié à chaque lecture.',
        'scp140.jpg',
        'Modéré',
        'Inconnue',
        2,
        3,
        1
    ),
    (
        'SCP-058',
        'Le Cœur',
        'Cœur bovin doté de tentacules et d''une intelligence meurtrière.',
        'scp058.jpg',
        'Critique',
        'Inconnue',
        3,
        5,
        1
    ),
    (
        'SCP-1230',
        'Le Livre des Rêves',
        'Livre qui plonge le lecteur dans un rêve lucide contrôlé.',
        'scp1230.jpg',
        'Faible',
        'Inconnue',
        1,
        1,
        1
    ),
    (
        'SCP-348',
        'Bol de Soupe',
        'Bol qui remplit de soupe adaptée à la personne qui le tient.',
        'scp348.jpg',
        'Faible',
        'Inconnue',
        1,
        1,
        1
    ),
    (
        'SCP-507',
        'L''Homme qui se Déplace',
        'Individu qui se téléporte involontairement dans des dimensions parallèles.',
        'scp507.jpg',
        'Modéré',
        'Inconnue',
        2,
        2,
        1
    ),
    (
        'SCP-191',
        'Enfant Cyborg',
        'Fillette lourdement modifiée par la cybernétique.',
        'scp191.jpg',
        'Modéré',
        'Inconnue',
        2,
        3,
        1
    ),
    (
        'SCP-5296',
        'Le Train Fantôme',
        'Train spectral apparaissant à des horaires imprévisibles.',
        'scp5296.jpg',
        'Modéré',
        'Inconnue',
        2,
        2,
        1
    ),
    (
        'SCP-1050',
        'Le Jouet qui Pleure',
        'Jouet en peluche qui pleure et attire des entités hostiles.',
        'scp1050.jpg',
        'Élevé',
        'Inconnue',
        2,
        4,
        1
    ),
    (
        'SCP-3930',
        'Ce Qui N''Existe Pas',
        'Zone où la réalité cesse d''exister, impossible à observer ou mesurer.',
        'scp3930.jpg',
        'Critique',
        'Inconnue',
        3,
        5,
        1
    );

-- Utilisateurs (id_user_class: 5=Classe A, 4=Classe B, 3=Classe C, 2=Classe E)
INSERT INTO
    `User` (
        first_name,
        last_name,
        user_name,
        email,
        id_user_class
    )
VALUES
    (
        'Christofeur',
        'GERARD',
        'Christ0u',
        'Christ0u.gerard@foundation.scp',
        5
    ), -- Classe A
    (
        'Elliot',
        'CARTER',
        'ecarter',
        'elliot.carter@foundation.scp',
        4
    ), -- Classe B
    (
        'Paul',
        'MARTIN',
        'pmartin',
        'paul.martin@foundation.scp',
        3
    ), -- Classe C
    (
        'Danaé',
        'ALBRECHT--MARTIN',
        'YumieY0ru',
        'YumieY0ru.albrechtmartin@foundation.scp',
        2
    ), -- Classe E
    (
        'Michael',
        'THOMPSON',
        'mthompson',
        'michael.thompson@foundation.scp',
        3
    ), -- Classe C
    (
        'Dr. James',
        'HAYWARD',
        'jhayward',
        'james.hayward@foundation.scp',
        4
    ), -- Classe B (décédé)
    (
        'Agent Maria',
        'RAMIREZ',
        'mramirez',
        'maria.ramirez@foundation.scp',
        3
    ), -- Classe C
    (
        'D-5847',
        'ROBINSON',
        'd5847',
        'd5847@foundation.scp',
        1
    ); -- Classe D

-- Incidents
INSERT INTO
    Incident (title, date, description, id_scp)
VALUES
    (
        'Attaque lors d''un test de surveillance',
        '2025-06-24',
        'Un garde de classe C a été attaqué par SCP-173 alors qu''il prétendait ne jamais l''avoir quitté des yeux. Rapport marqué comme "Non vérifié".',
        1
    ),
    (
        'Découverte d''une nouvelle anomalie',
        '2025-06-23',
        'SCP-173 a manifesté la capacité de se déplacer à travers des surfaces réfléchissantes. Rapport classé "Classe A - Accès restreint".',
        1
    ),
    (
        'Tentative d''accès non autorisé - INCIDENT CRITIQUE',
        '2025-06-27',
        'ALERTE SÉCURITÉ : Détection d''une tentative d''accès au dossier SCP-001 par l''utilisateur jhayward (Dr. James Hayward), officiellement décédé il y a 3 ans lors d''un incident de confinement. Origine : Terminal-B7-Site19. Protocole de verrouillage automatique activé. Incident assigné à Michael Thompson (cybersécurité) pour investigation. Équipe de sécurité Classe A déployée.',
        2
    ),
    (
        'Disparitions inexpliquées - Nevada',
        '2025-06-26',
        'Série de disparitions signalées dans une petite ville du Nevada. Les témoins mentionnent un magasin de meubles isolé. Investigation en cours par l''Agent Ramirez.',
        3
    ),
    (
        'Témoignage de survivant - Évasion SCP-3008',
        '2024-12-15',
        'Témoignage de [CENSURÉ] : "J''ai trouvé une zone où les murs semblaient instables, comme s''ils scintillaient. J''ai poussé fort et soudain je me suis retrouvé dehors. Les employés d''IKEA ne m''ont pas suivi." Méthode d''évasion confirmée par 3 autres survivants.',
        3
    ),
    (
        'Attaque nocturne - Employés hostiles',
        '2024-08-10',
        'Témoignage multiple : entités humanoïdes en uniforme IKEA attaquent systématiquement les survivants pendant la nuit. Recommandation : éviter les zones ouvertes après la fermeture des lumières du magasin.',
        3
    );

-- Affectation chercheur -> site
INSERT INTO
    Work (id_site, id_user)
VALUES
    (1, 2), -- Elliot Carter au Site-19
    (1, 5), -- Michael Thompson au Site-19
    (1, 7); -- Agent Ramirez au Site-19

-- Access
INSERT INTO
    Access (id_scp, id_user, date_access)
VALUES
    (1, 1, '2025-06-25 09:15:00'),
    (1, 2, '2025-06-25 10:00:00'),
    (2, 3, '2025-06-25 11:30:00'),
    (3, 2, '2025-06-25 13:45:00'),
    (4, 4, '2025-06-25 14:10:00'),
    (5, 1, '2025-06-25 15:00:00'),
    (6, 3, '2025-06-25 16:20:00'),
    (7, 2, '2025-06-25 17:05:00'),
    (8, 4, '2025-06-25 18:00:00'),
    (9, 1, '2025-06-25 19:30:00'),
    (10, 2, '2025-06-25 20:00:00'),
    (11, 3, '2025-06-25 21:10:00'),
    (12, 4, '2025-06-25 22:00:00'),
    (13, 1, '2025-06-26 08:00:00'),
    (14, 2, '2025-06-26 09:00:00'),
    (15, 3, '2025-06-26 10:00:00'),
    (16, 4, '2025-06-26 11:00:00'),
    (17, 1, '2025-06-26 12:00:00'),
    (18, 2, '2025-06-26 13:00:00'),
    (19, 3, '2025-06-26 14:00:00');

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
# SCP Database Setup and Query Guide

## 🚀 **Introduction**

Ce projet utilise **Docker** pour déployer une base de données **MySQL** qui contient des informations sur les SCPs, les utilisateurs, les incidents, etc. Ce guide explique comment démarrer le conteneur MySQL et interagir avec la base.

### 📊 **Schéma de la base de données**

Voici le schéma complet de la base de données `scp_db` montrant les relations entre les tables :

![Schéma de la base de données](img/schema.png)

La base de données est organisée autour des entités principales :

- **SCP** : Les objets anormaux avec leurs classifications et sites de confinement
- **User** : Le personnel de la Fondation avec leurs niveaux d'autorisation
- **Incident** : Les événements liés aux SCPs
- **Access** : Les logs d'accès aux dossiers SCP
- **Work** : Les affectations du personnel aux sites

## 🛠️ **Prérequis**

- **Docker** installé sur votre machine
- **docker-compose** installé (si nécessaire)

## 📁 **Structure du projet**

```
BDD-CNAM-2025/
├── Cahier_des_charges_Projet_libre.pdf  # Cahier des charges du projet
├── docker-compose.yml                   # Configuration Docker
├── README.md                            # Guide d'utilisation
├── db/
│   └── init.sql                         # Script d'initialisation de la base
└── img/
    ├── schema.png                       # Schéma de la base de données
    └── ...                              # Autres images
```

---

## 🧑‍💻 **Lancer la base de données MySQL**

### 1. **Cloner le projet**

Si vous ne l'avez pas encore fait, clonez ce projet sur votre machine :

```bash
git clone https://github.com/votre-utilisateur/mon-projet-scp.git
cd mon-projet-scp
```

### 2. **Démarrer MySQL avec Docker**

Dans le dossier du projet, exécutez :

```bash
docker-compose up --build
```

Cela va :

- Lancer un conteneur Docker avec MySQL
- Créer la base de données `scp_db`
- Exécuter le script d'initialisation (`init.sql`)

Le conteneur sera disponible sur le port `3306` de votre machine locale.

---

## 🔑 **Se connecter à la base de données**

Il y a plusieurs façons de se connecter à la base de données et de faire des requêtes SQL.

### 1. **Se connecter via le terminal Docker**

Exécutez cette commande pour accéder à MySQL à l’intérieur du conteneur Docker :

```bash
docker exec -it scp-mysql mysql -u scp_user -p
```

Il vous demandera le mot de passe : `scp_password`.

Une fois connecté, vous pouvez choisir la base de données avec :

```sql
USE scp_db;
```

Ensuite, vous pouvez exécuter des requêtes SQL. Par exemple :

```sql
SELECT * FROM SCP;
```

Pour quitter le shell MySQL, utilisez :

```sql
exit;
```

---

### 2. **Se connecter avec un outil graphique (ex. : DBeaver)**

Vous pouvez utiliser un outil graphique comme **MySQL Workbench**, **DBeaver**, ou **TablePlus** pour interagir avec la base de données.

#### **Paramètres de connexion :**

- **Host** : `127.0.0.1`
- **Port** : `3306`
- **User** : `scp_user`
- **Password** : `scp_password`
- **Database** : `scp_db`

Une fois connecté, vous pouvez exécuter vos requêtes SQL directement depuis l'interface graphique.

---

## 📊 **Exemples de requêtes SQL**

Voici quelques exemples de requêtes SQL que vous pouvez exécuter sur la base `scp_db` :

### 1. **Lister tous les SCPs**

```sql
SELECT * FROM SCP;
```

**Résultat attendu :**

| id_scp | number   | title          | classification | threat_level | nationality  | description                                                                   | containment_procedures                                               |
| ------ | -------- | -------------- | -------------- | ------------ | ------------ | ----------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| 1      | SCP-173  | La Sculpture   | Euclide        | 4            | Non spécifié | Sculpture béton et fer. Extrêmement hostile. Ne bouge que si non observée.    | Confinement dans une cellule de 5m³. Surveillance constante requise. |
| 2      | SCP-001  | La Proposition | Apollyon       | 5            | Global       | Menace de classe Apollyon. Informations confidentielles Classe A uniquement.  | Protocoles de confinement classifiés niveau maximal.                 |
| 3      | SCP-3008 | L'IKEA Infini  | Euclide        | 3            | Nevada, USA  | Magasin de meubles apparemment infini. Contient des entités hostiles la nuit. | Périmètre de sécurité. Accès strictement interdit au public.         |

---

### 2. **Trouver les incidents liés à un SCP spécifique**

```sql
SELECT * FROM Incident WHERE id_scp = 1;
```

**Résultat attendu :**

| id_incident | id_scp | title                           | date       | description                                                                                   |
| ----------- | ------ | ------------------------------- | ---------- | --------------------------------------------------------------------------------------------- |
| 1           | 1      | Incident de confinement SCP-173 | 2024-01-15 | Rupture de confinement due à une panne de courant. 2 victimes confirmées avant reconfinement. |
| 2           | 1      | Maintenance préventive SCP-173  | 2024-01-20 | Nettoyage et inspection de routine. Aucun incident signalé.                                   |

---

### 3. **Lister tous les utilisateurs avec leur classe d'utilisateur**

```sql
SELECT u.first_name, u.last_name, uc.level
FROM `User` u
JOIN UserClass uc ON u.id_user_class = uc.id_user_class;
```

**Résultat attendu :**

| first_name  | last_name        | level |
| ----------- | ---------------- | ----- |
| Christofeur | GERARD           | 5     |
| Elliot      | CARTER           | 4     |
| Dr. James   | HAYWARD          | 4     |
| Paul        | MARTIN           | 3     |
| Michael     | THOMPSON         | 3     |
| Agent Maria | RAMIREZ          | 3     |
| Danaé       | ALBRECHT--MARTIN | 2     |

---

### 4. **Lister tous les accès d'un utilisateur à un SCP**

```sql
SELECT a.date_access, s.number, s.title
FROM Access a
JOIN SCP s ON a.id_scp = s.id_scp
WHERE a.id_user = 1;
```

**Résultat attendu :**

| date_access         | number  | title        |
| ------------------- | ------- | ------------ |
| 2024-01-10 14:30:00 | SCP-173 | La Sculpture |
| 2024-01-12 09:15:00 | SCP-173 | La Sculpture |

---

### 5. **Consulter les accès suspects pour détecter des activités anormales**

```sql
SELECT
    a.date_access,
    CONCAT(u.first_name, ' ', u.last_name) as user_name,
    s.number as scp_accessed,
    uc.description as user_class
FROM Access a
JOIN `User` u ON a.id_user = u.id_user
JOIN SCP s ON a.id_scp = s.id_scp
JOIN UserClass uc ON u.id_user_class = uc.id_user_class
WHERE s.number = 'SCP-001'
ORDER BY a.date_access DESC;
```

**Résultat attendu :**

| date_access         | user_name         | scp_accessed | user_class                                                                          |
| ------------------- | ----------------- | ------------ | ----------------------------------------------------------------------------------- |
| 2025-06-27 14:33:02 | Dr. James HAYWARD | SCP-001      | Direction de site et hauts responsables, gestion des équipes et incidents critiques |
| 2025-06-27 14:32:45 | Dr. James HAYWARD | SCP-001      | Direction de site et hauts responsables, gestion des équipes et incidents critiques |
| 2025-06-27 14:32:17 | Dr. James HAYWARD | SCP-001      | Direction de site et hauts responsables, gestion des équipes et incidents critiques |

> ⚠️ **Alerte de sécurité** : L'accès de Dr. Hayward est suspect car il est censé être décédé depuis 3 ans.

---

### 6. **Vérifier les incidents de sécurité récents**

```sql
SELECT i.title, i.date, i.description, s.number as scp_number
FROM Incident i
JOIN SCP s ON i.id_scp = s.id_scp
WHERE i.title LIKE '%accès non autorisé%' OR i.title LIKE '%CRITIQUE%'
ORDER BY i.date DESC;
```

**Résultat attendu :**

| title                                              | date       | description                                                                                                                                                                                                                  | scp_number |
| -------------------------------------------------- | ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| Tentative d'accès non autorisé - INCIDENT CRITIQUE | 2025-06-27 | ALERTE SÉCURITÉ : Détection d'une tentative d'accès au dossier SCP-001 par l'utilisateur jhayward (Dr. James Hayward), officiellement décédé il y a 3 ans lors d'un incident de confinement. Origine : Terminal-B7-Site19... | SCP-001    |

---

### 7. **Rechercher des SCPs par localisation géographique**

```sql
SELECT number, title, nationality, threat_level, description
FROM SCP
WHERE nationality LIKE '%Nevada%' OR nationality LIKE '%USA%'
ORDER BY threat_level DESC;
```

**Résultat attendu :**

| number   | title         | nationality | threat_level | description                                                             |
| -------- | ------------- | ----------- | ------------ | ----------------------------------------------------------------------- |
| SCP-3008 | L'IKEA Infini | Nevada, USA | 3            | Magasin de meubles apparemment infini. Contient des entités hostiles... |

---

### 8. **Consulter les témoignages de survivants pour un SCP spécifique**

```sql
SELECT i.title, i.date, i.description
FROM Incident i
JOIN SCP s ON i.id_scp = s.id_scp
WHERE s.number = 'SCP-3008'
  AND (i.title LIKE '%témoignage%' OR i.title LIKE '%survivant%')
ORDER BY i.date DESC;
```

**Résultat attendu :**

| title                                      | date       | description                                                                                                            |
| ------------------------------------------ | ---------- | ---------------------------------------------------------------------------------------------------------------------- |
| Témoignage de survivant - Évasion SCP-3008 | 2024-12-15 | Témoignage de [CENSURÉ] : "J'ai trouvé une zone où les murs semblaient instables, comme s'ils scintillaient..."        |
| Attaque nocturne - Employés hostiles       | 2024-08-10 | Témoignage multiple : entités humanoïdes en uniforme IKEA attaquent systématiquement les survivants pendant la nuit... |

### 9. **Vérifier les autorisations et affectations du personnel**

```sql
SELECT u.first_name, u.last_name, uc.authorization, s.address
FROM `User` u
JOIN UserClass uc ON u.id_user_class = uc.id_user_class
LEFT JOIN Work w ON u.id_user = w.id_user
LEFT JOIN Site s ON w.id_site = s.id_site
ORDER BY uc.level DESC;
```

**Résultat attendu :**

| first_name  | last_name        | authorization                 | address      |
| ----------- | ---------------- | ----------------------------- | ------------ |
| Christofeur | GERARD           | Classe A - Accès illimité     | NULL         |
| Elliot      | CARTER           | Classe B - Accès élevé        | Site-19, USA |
| Dr. James   | HAYWARD          | Classe B - Accès élevé        | NULL         |
| Paul        | MARTIN           | Classe C - Accès moyen        | NULL         |
| Michael     | THOMPSON         | Classe C - Accès moyen        | Site-19, USA |
| Agent Maria | RAMIREZ          | Classe C - Accès moyen        | Site-19, USA |
| Danaé       | ALBRECHT--MARTIN | Classe E - Accès conditionnel | NULL         |

---

## 📊 **Exemples de scénarios d'utilisation**

Voici quelques scénarios plus concrets pour l'utilisation de la base `scp_db` :

### 📝 **Scénario 1 – Accès aux incidents selon la classe utilisateur**

**Contexte :**  
Un chercheur (Elliot Carter, Classe B) souhaite consulter les incidents liés à un SCP (ex : SCP-173).  
Grâce au moteur de recherche, il filtre les rapports selon la classification du personnel.  
Si un incident est classé au-dessus de son niveau (Classe A), il reçoit une alerte :

> "Alerte : ce fichier dépasse votre niveau. Demandez une autorisation temporaire."

---

### ⚙️ **Utiliser la procédure stockée du scénario 1**

Elliot Carter peut tenter d'utiliser la procédure `GetSCPIncidentsIfClassA` pour consulter les incidents de SCP-173 :

```sql
-- Elliot Carter (Classe B) tente d'accéder aux incidents de SCP-173
CALL GetSCPIncidentsIfClassA(2, 'SCP-173');
```

**Résultat pour Elliot Carter :**

| message                                                                         |
| ------------------------------------------------------------------------------- |
| Alerte : ce fichier dépasse votre niveau. Demandez une autorisation temporaire. |

**Consulter les incidents de SCP-173 en tant qu'utilisateur Classe A :**

```sql
-- Christofeur (Classe A) accède aux incidents de SCP-173
CALL GetSCPIncidentsIfClassA(1, 'SCP-173');
```

**Résultat pour utilisateur Classe A :**

| id_incident | title                                  | date       | description                                                                                                                                  | scp_number |
| ----------- | -------------------------------------- | ---------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| 1           | Attaque lors d'un test de surveillance | 2025-06-24 | Un garde de classe C a été attaqué par SCP-173 alors qu'il prétendait ne jamais l'avoir quitté des yeux. Rapport marqué comme "Non vérifié". | SCP-173    |
| 2           | Découverte d'une nouvelle anomalie     | 2025-06-23 | SCP-173 a manifesté la capacité de se déplacer à travers des surfaces réfléchissantes. Rapport classé "Classe A - Accès restreint".          | SCP-173    |

**Trouver l'ID d'un utilisateur :**

```sql
SELECT id_user, first_name, last_name, id_user_class FROM `User`;
```

**Résultat attendu :**

| id_user | first_name  | last_name        | id_user_class |
| ------- | ----------- | ---------------- | ------------- |
| 1       | Christofeur | GERARD           | 5             |
| 2       | Elliot      | CARTER           | 4             |
| 3       | Paul        | MARTIN           | 3             |
| 4       | Danaé       | ALBRECHT--MARTIN | 2             |
| 5       | Michael     | THOMPSON         | 3             |
| 6       | Dr. James   | HAYWARD          | 4             |
| 7       | Agent Maria | RAMIREZ          | 3             |
| 8       | D-5847      | ROBINSON         | 1             |

> **Note** : id_user_class 5 = Classe A, 4 = Classe B, 3 = Classe C, 2 = Classe E, 1 = Classe D

**Voir tous les incidents disponibles (requête standard sans restriction) :**

```sql
-- Alternative : voir les incidents sans restriction de classe
SELECT i.title, i.date, s.number, s.title as scp_title
FROM Incident i
JOIN SCP s ON i.id_scp = s.id_scp
WHERE s.number IN ('SCP-173', 'SCP-3008')
ORDER BY i.date DESC;
```

**Résultat attendu :**

| title                                      | date       | number   | scp_title     |
| ------------------------------------------ | ---------- | -------- | ------------- |
| Disparitions inexpliquées - Nevada         | 2025-06-26 | SCP-3008 | L'IKEA Infini |
| Attaque lors d'un test de surveillance     | 2025-06-24 | SCP-173  | La Sculpture  |
| Découverte d'une nouvelle anomalie         | 2025-06-23 | SCP-173  | La Sculpture  |
| Témoignage de survivant - Évasion SCP-3008 | 2024-12-15 | SCP-3008 | L'IKEA Infini |
| Attaque nocturne - Employés hostiles       | 2024-08-10 | SCP-3008 | L'IKEA Infini |

> ⚠️ **Note importante** : Seuls les utilisateurs de niveau 5 (Classe A) peuvent voir les détails des incidents via la procédure `GetSCPIncidentsIfClassA`. Dans notre base de données, Christofeur GERARD (id_user = 1) est le seul utilisateur avec ce niveau d'autorisation maximal.

---

### 🚨 **Scénario 2 – Tentative d'intrusion dans la base de données**

**Contexte :**  
Michael Thompson, technicien en cybersécurité de Classe C, reçoit une alerte urgente : une activité suspecte a été détectée sur la base de données SCP.

🚨 **"Tentative d'accès non autorisé détectée. Fichier ciblé : SCP-001. Source : inconnue."**

Michael consulte les logs de connexion et remarque quelque chose d'étrange : la tentative ne vient pas d'un hacker extérieur, mais d'un terminal situé à l'intérieur du Site-19. Encore plus troublant, l'utilisateur semble être le Dr. Hayward, un chercheur de Classe B supposé être décédé il y a trois ans lors d'un incident de confinement.

Le système de sécurité enclenche immédiatement un protocole de verrouillage, empêchant toute autre tentative d'accès. Michael déclenche une procédure d'alerte et une équipe de sécurité de Classe A est envoyée pour identifier l'origine de cette activité... et découvrir si le Dr. Hayward est vraiment mort.

---

### ⚙️ **Utiliser la procédure stockée du scénario 2**

Michael Thompson peut utiliser la procédure `GetSuspiciousAccess` pour analyser les tentatives d'accès suspects :

#### **Analyser les accès suspects**

```sql
-- Michael Thompson (id_user = 5) vérifie les accès suspects
CALL GetSuspiciousAccess(5);
```

**Résultat attendu :**

| date_access         | user_name | full_name         | scp_number | scp_title           | user_class                                 | alert_type    |
| ------------------- | --------- | ----------------- | ---------- | ------------------- | ------------------------------------------ | ------------- |
| 2025-06-27 14:33:02 | jhayward  | Dr. James HAYWARD | SCP-001    | [DONNÉES EXPURGÉES] | Direction de site et hauts responsables... | ACCÈS SUSPECT |
| 2025-06-27 14:32:45 | jhayward  | Dr. James HAYWARD | SCP-001    | [DONNÉES EXPURGÉES] | Direction de site et hauts responsables... | ACCÈS SUSPECT |
| 2025-06-27 14:32:17 | jhayward  | Dr. James HAYWARD | SCP-001    | [DONNÉES EXPURGÉES] | Direction de site et hauts responsables... | ACCÈS SUSPECT |

> 🚨 **Analyse critique** : 3 tentatives d'accès en moins d'une minute par un utilisateur décédé officiellement !

#### **Vérifier les détails de l'incident**

```sql
-- Consulter l'incident lié à cette tentative d'intrusion
SELECT i.title, i.date, i.description, s.number as scp_number
FROM Incident i
JOIN SCP s ON i.id_scp = s.id_scp
WHERE i.title LIKE '%CRITIQUE%' AND s.number = 'SCP-001'
ORDER BY i.date DESC;
```

**Résultat attendu :**

| title                                              | date       | description                                                                                                                                                                                                                  | scp_number |
| -------------------------------------------------- | ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| Tentative d'accès non autorisé - INCIDENT CRITIQUE | 2025-06-27 | ALERTE SÉCURITÉ : Détection d'une tentative d'accès au dossier SCP-001 par l'utilisateur jhayward (Dr. James Hayward), officiellement décédé il y a 3 ans lors d'un incident de confinement. Origine : Terminal-B7-Site19... | SCP-001    |

#### **Test avec un utilisateur non autorisé**

```sql
-- Test avec un utilisateur de Classe D (niveau insuffisant)
CALL GetSuspiciousAccess(1);
```

**Résultat pour utilisateur Classe D :**

| message                                       |
| --------------------------------------------- |
| ACCÈS REFUSÉ: Niveau de sécurité insuffisant. |

#### **Requêtes d'investigation supplémentaires pour le scénario 2**

**Vérifier tous les accès récents à des SCPs classifiés :**

```sql
-- Analyser tous les accès aux SCPs de haute sécurité
SELECT
    a.date_access,
    CONCAT(u.first_name, ' ', u.last_name) as utilisateur,
    s.number,
    s.title,
    uc.description as niveau_autorisation
FROM Access a
JOIN `User` u ON a.id_user = u.id_user
JOIN SCP s ON a.id_scp = s.id_scp
JOIN UserClass uc ON u.id_user_class = uc.id_user_class
WHERE s.threat_level IN ('MAXIMUM', 'Élevé')
ORDER BY a.date_access DESC;
```

**Résultat attendu :**

| date_access         | utilisateur       | number  | title               | niveau_autorisation                                                                 |
| ------------------- | ----------------- | ------- | ------------------- | ----------------------------------------------------------------------------------- |
| 2025-06-27 14:33:02 | Dr. James HAYWARD | SCP-001 | [DONNÉES EXPURGÉES] | Direction de site et hauts responsables, gestion des équipes et incidents critiques |
| 2025-06-27 14:32:45 | Dr. James HAYWARD | SCP-001 | [DONNÉES EXPURGÉES] | Direction de site et hauts responsables, gestion des équipes et incidents critiques |
| 2025-06-27 14:32:17 | Dr. James HAYWARD | SCP-001 | [DONNÉES EXPURGÉES] | Direction de site et hauts responsables, gestion des équipes et incidents critiques |

**Identifier les patterns d'accès suspects :**

```sql
-- Détecter les utilisateurs avec plusieurs tentatives d'accès rapprochées
SELECT
    u.user_name,
    CONCAT(u.first_name, ' ', u.last_name) as nom_complet,
    COUNT(*) as nombre_tentatives,
    MIN(a.date_access) as premiere_tentative,
    MAX(a.date_access) as derniere_tentative,
    TIMESTAMPDIFF(SECOND, MIN(a.date_access), MAX(a.date_access)) as duree_en_secondes
FROM Access a
JOIN `User` u ON a.id_user = u.id_user
GROUP BY u.id_user
HAVING COUNT(*) > 1
ORDER BY nombre_tentatives DESC;
```

**Résultat attendu :**

| user_name | nom_complet       | nombre_tentatives | premiere_tentative  | derniere_tentative  | duree_en_secondes |
| --------- | ----------------- | ----------------- | ------------------- | ------------------- | ----------------- |
| jhayward  | Dr. James HAYWARD | 3                 | 2025-06-27 14:32:17 | 2025-06-27 14:33:02 | 45                |

> ⚠️ **Alerte critique** : 3 tentatives d'accès en seulement 45 secondes par un utilisateur officiellement décédé !

---

### 🔍 **Scénario 3 – Agent de terrain utilisant la base pour survivre**

**Contexte :**  
L'Agent Ramirez, membre du personnel de Classe C, est envoyé en mission sur le terrain pour enquêter sur une série de disparitions inexpliquées dans une petite ville du Nevada. Les habitants parlent d'un étrange phénomène touchant certains voyageurs qui s'arrêtent dans un magasin de meubles isolé.

Avant d'entrer dans le magasin, Ramirez consulte la base de données via son terminal sécurisé. Il entre les mots-clés :

🔎 **"magasin de meubles"**

Un résultat remonte immédiatement : **SCP-3008 "L'IKEA Infini"**

- **Classe** : Euclide
- **Effet principal** : Toute personne entrant dans SCP-3008 devient incapable d'en ressortir. L'intérieur s'étend apparemment à l'infini.
- **Menace secondaire** : Entités humanoïdes hostiles ("employés d'IKEA") qui attaquent pendant la nuit.

Grâce à la base de données, Ramirez consulte les témoignages de survivants et découvre qu'une seule méthode d'évasion a fonctionné : certains ont trouvé des zones où la structure semblait instable, permettant parfois une sortie.

Ramirez fait demi-tour et contacte la Fondation. Une équipe de récupération est envoyée pour contenir le phénomène.

---

### ⚙️ **Utiliser les procédures stockées du scénario 3**

Le scénario 3 permet aux agents de terrain d'effectuer des recherches par mots-clés et de consulter les témoignages de survivants.

#### **Recherche par mots-clés**

La procédure `SearchSCPByKeywords` permet aux utilisateurs de Classe C et plus de rechercher des SCPs par mots-clés :

```sql
-- Recherche par mots-clés (Agent Ramirez, id_user = 7)
CALL SearchSCPByKeywords(7, 'magasin de meubles');
CALL SearchSCPByKeywords(7, 'disparition');
CALL SearchSCPByKeywords(7, 'infini');
```

**Exemples de résultats pour différentes recherches :**

_Recherche "magasin de meubles" :_

| number   | title         | classification | threat_level |
| -------- | ------------- | -------------- | ------------ |
| SCP-3008 | L'IKEA Infini | Euclide        | 3            |

_Recherche "sculpture" :_

| number  | title        | classification | threat_level |
| ------- | ------------ | -------------- | ------------ |
| SCP-173 | La Sculpture | Euclide        | 4            |

#### **Consulter les témoignages de survivants**

La procédure `GetSurvivorTestimonies` affiche les témoignages et méthodes d'évasion documentées :

```sql
-- Voir les témoignages pour SCP-3008
CALL GetSurvivorTestimonies(7, 'SCP-3008');
```

**Résultat attendu :**

| title                                          | date       | description_courte                                    |
| ---------------------------------------------- | ---------- | ----------------------------------------------------- |
| Témoignage survivant SCP-3008 - Méthode sortie | 2024-02-10 | Méthode d'évasion découverte près du rayon cuisine... |
| Témoignage survivant SCP-3008 - Entités nuit   | 2024-02-08 | Description des entités hostiles nocturnes...         |

**Exemple de scénario complet :**

1. L'Agent Ramirez effectue une recherche par mots-clés :

   ```sql
   CALL SearchSCPByKeywords(7, 'magasin de meubles');
   ```

   **Résultat attendu :**

   | number   | title         | classification | threat_level | description                                                             |
   | -------- | ------------- | -------------- | ------------ | ----------------------------------------------------------------------- |
   | SCP-3008 | L'IKEA Infini | Euclide        | 3            | Magasin de meubles apparemment infini. Contient des entités hostiles... |

2. Il consulte les témoignages de survivants pour SCP-3008 :

   ```sql
   CALL GetSurvivorTestimonies(7, 'SCP-3008');
   ```

   **Résultat attendu :**

   | title                                          | date       | description                                                                |
   | ---------------------------------------------- | ---------- | -------------------------------------------------------------------------- |
   | Témoignage survivant SCP-3008 - Méthode sortie | 2024-02-10 | Survivant Marcus K. : "J'ai trouvé une zone où les murs semblaient..."     |
   | Témoignage survivant SCP-3008 - Entités nuit   | 2024-02-08 | Survivante Sarah L. : "La nuit, ils arrivent. Des employés sans visage..." |

3. Il peut aussi vérifier tous les incidents récents liés à SCP-3008 :

   ```sql
   SELECT i.title, i.date, i.description
   FROM Incident i
   JOIN SCP s ON i.id_scp = s.id_scp
   WHERE s.number = 'SCP-3008'
   ORDER BY i.date DESC;
   ```

   **Résultat attendu :**

   | title                                          | date       | description                                                                |
   | ---------------------------------------------- | ---------- | -------------------------------------------------------------------------- |
   | Témoignage survivant SCP-3008 - Méthode sortie | 2024-02-10 | Survivant Marcus K. : "J'ai trouvé une zone où les murs semblaient..."     |
   | Témoignage survivant SCP-3008 - Entités nuit   | 2024-02-08 | Survivante Sarah L. : "La nuit, ils arrivent. Des employés sans visage..." |
   | Incident de disparition SCP-3008               | 2024-01-30 | Groupe de touristes disparu après avoir visité le magasin de meubles...    |

4. Recherche géographique pour localiser les zones à risque :

   ```sql
   SELECT number, title, nationality, threat_level
   FROM SCP
   WHERE nationality LIKE '%Nevada%' OR nationality LIKE '%USA%'
   ORDER BY threat_level DESC;
   ```

   **Résultat attendu :**

   | number   | title         | nationality | threat_level |
   | -------- | ------------- | ----------- | ------------ |
   | SCP-3008 | L'IKEA Infini | Nevada, USA | 3            |

---

## ⚙️ **Dépannage**

- **Erreur de connexion MySQL** : Vérifiez que le conteneur MySQL est bien en cours d'exécution avec `docker ps`. Si le conteneur est arrêté, relancez-le avec `docker-compose up`.
- **Problèmes de requêtes SQL** : Si vous rencontrez des erreurs lors de l'exécution des requêtes, assurez-vous d'être bien connecté à la base de données `scp_db` avec la commande `USE scp_db;`.

---

## 🧑‍💻 **Gestion des migrations et modifications de schéma**

Si vous devez modifier le schéma ou ajouter de nouvelles tables :

1. Modifiez le fichier `init.sql` avec les nouvelles instructions.
2. Redémarrez le conteneur avec `docker-compose down` puis `docker-compose up --build`.

Cela permettra de **recréer la base de données** avec les nouvelles modifications. (Note : toutes les données existantes seront perdues si vous redémarrez ainsi.)

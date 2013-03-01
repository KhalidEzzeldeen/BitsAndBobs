# euchre.sql

# Tables to illustrate many-to-many relationship

# euchre - the nonnormal table that contains team/player information
# euchre_team - normalized team table
# euchre_player - normalized player table
# euchre_link - table that links teams and players

# euchre table is created here, but populated below from the result of
# a join between the euchre_{team,player,link} tables.

DROP TABLE IF EXISTS euchre;
#@ _CREATE_EUCHRE_TABLE_
CREATE TABLE euchre
(
  team        CHAR(10) NOT NULL,      # name of team
  year        YEAR NOT NULL,          # year of tournament
  wins        INT UNSIGNED NOT NULL,  # team record, wins and losses
  losses      INT UNSIGNED NOT NULL,
  player      CHAR(20) NOT NULL,      # player name, city
  player_city CHAR(20) NOT NULL
);
#@ _CREATE_EUCHRE_TABLE_

DROP TABLE IF EXISTS euchre_team;
#@ _CREATE_EUCHRE_TEAM_TABLE_
CREATE TABLE euchre_team
(
  id      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name    CHAR(10) NOT NULL,      # name of team
  year    YEAR NOT NULL,          # year of tournament
  wins    INT UNSIGNED NOT NULL,  # team record, wins and losses
  losses  INT UNSIGNED NOT NULL,
  PRIMARY KEY (id)
);
#@ _CREATE_EUCHRE_TEAM_TABLE_

INSERT INTO euchre_team (name,year,wins,losses)
  VALUES
    ('Kings',2005,10,2),
    ('Crowns',2005,7,5),
    ('Stars',2005,4,8),
    ('Sceptres',2005,3,9),
    ('Kings',2006,8,4),
    ('Crowns',2006,9,3),
    ('Stars',2006,5,7),
    ('Sceptres',2006,2,10)
;

SELECT * FROM euchre_team;

# make sure that wins = losses for each year (consistency check)
SELECT year, SUM(wins),SUM(losses) FROM euchre_team GROUP BY year;

DROP TABLE IF EXISTS euchre_player;
#@ _CREATE_EUCHRE_PLAYER_TABLE_
CREATE TABLE euchre_player
(
  id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name  CHAR(20) NOT NULL,    # player name and city
  city  CHAR(20) NOT NULL,
  PRIMARY KEY (id)
);
#@ _CREATE_EUCHRE_PLAYER_TABLE_

INSERT INTO euchre_player (name,city)
  VALUES
    ('Ben','Cork'),
    ('Billy','York'),
    ('Tony','Derry'),
    ('Melvin','Dublin'),
    ('Franklin','Bath'),
    ('Wallace','Cardiff'),
    ('Nigel','London'),
    ('Maurice','Leeds')
;

SELECT * FROM euchre_player;

DROP TABLE IF EXISTS euchre_link;
#@ _CREATE_EUCHRE_LINK_TABLE_
CREATE TABLE euchre_link
(
  team_id   INT UNSIGNED NOT NULL,
  player_id INT UNSIGNED NOT NULL,
  UNIQUE (team_id, player_id)
);
#@ _CREATE_EUCHRE_LINK_TABLE_

INSERT INTO euchre_link (team_id,player_id)
  VALUES
    (1,1),
    (1,2),
    (2,3),
    (2,4),
    (3,5),
    (3,6),
    (4,7),
    (4,8),
    (5,5),
    (5,7),
    (6,1),
    (6,3),
    (7,4),
    (7,8),
    (8,2),
    (8,6)
;

SELECT * FROM euchre_link;

SELECT t.name, t.year, t.wins, t.losses, p.name, p.city
FROM euchre_team AS t, euchre_link AS l, euchre_player AS p
WHERE t.id = l.team_id AND p.id = l.player_id
ORDER BY t.year, t.name, p.name;

INSERT INTO euchre
(team,year,wins,losses,player,player_city)
SELECT t.name, t.year, t.wins, t.losses, p.name, p.city
FROM euchre_team AS t, euchre_link AS l, euchre_player AS p
WHERE t.id = l.team_id AND p.id = l.player_id
ORDER BY t.year, t.name, p.name;

USE sys;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS team_rank;
DROP TABLE IF EXISTS Register;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS team_bar;

-- Create tables
CREATE TABLE team_rank (
    TEAM_ID INT,
    win INT, 
    draw INT,
    lose INT,
    points INT
);

CREATE TABLE Register (
    fname VARCHAR(255),
    lname VARCHAR(255),
    pswd VARCHAR(255),
    Confirms_pswd VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE matches (
    match_id INT PRIMARY KEY,
    date_ CHAR(20), 
    venue CHAR(20),
    result CHAR(20),
    hometeam_id INT,
    awayteam_id INT
);

CREATE TABLE team_bar (
    TEAM_ID INT PRIMARY KEY,
    TEAM_NAME CHAR(20)
);

CREATE TABLE players (
    player_id INT PRIMARY KEY,
    team_id INT,
    fname CHAR(20),
    lname CHAR(20),
    position CHAR(20),
    jerseyno INT
);

-- Insert teams into the team_bar table
INSERT INTO team_bar (TEAM_ID, TEAM_NAME) VALUES
(1, 'Barcelona'),
(2, 'Real Madrid'),
(3, 'PSG');

-- Insert players for Barcelona
INSERT INTO players (player_id, team_id, fname, lname, position, jerseyno) VALUES
(1, 1, 'Marc-Andre', 'ter Stegen', 'Goalkeeper', 1),
(2, 1, 'Gerard', 'Pique', 'Defender', 3),
(3, 1, 'Jordi', 'Alba', 'Defender', 18),
(4, 1, 'Sergio', 'Busquets', 'Midfielder', 5),
(5, 1, 'Frenkie', 'de Jong', 'Midfielder', 21),
(6, 1, 'Pedri', 'Gonzalez', 'Midfielder', 16),
(7, 1, 'Ansu', 'Fati', 'Forward', 10),
(8, 1, 'Ousmane', 'Dembele', 'Forward', 7),
(9, 1, 'Memphis', 'Depay', 'Forward', 9),
(10, 1, 'Sergi', 'Roberto', 'Midfielder', 20),
(11, 1, 'Ronald', 'Araujo', 'Defender', 4);

-- Insert players for Real Madrid
INSERT INTO players (player_id, team_id, fname, lname, position, jerseyno) VALUES
(12, 2, 'Thibaut', 'Courtois', 'Goalkeeper', 1),
(13, 2, 'Dani', 'Carvajal', 'Defender', 2),
(14, 2, 'Sergio', 'Ramos', 'Defender', 4),
(15, 2, 'Raphael', 'Varane', 'Defender', 5),
(16, 2, 'Marcelo', 'Vieira', 'Defender', 12),
(17, 2, 'Casemiro', 'Henrique', 'Midfielder', 14),
(18, 2, 'Toni', 'Kroos', 'Midfielder', 8),
(19, 2, 'Luka', 'Modric', 'Midfielder', 10),
(20, 2, 'Karim', 'Benzema', 'Forward', 9),
(21, 2, 'Eden', 'Hazard', 'Forward', 7),
(22, 2, 'Vinicius', 'Junior', 'Forward', 20);

-- Insert players for PSG
INSERT INTO players (player_id, team_id, fname, lname, position, jerseyno) VALUES
(23, 3, 'Keylor', 'Navas', 'Goalkeeper', 1),
(24, 3, 'Achraf', 'Hakimi', 'Defender', 2),
(25, 3, 'Marquinhos', '', 'Defender', 5),
(26, 3, 'Sergio', 'Ramos', 'Defender', 4),
(27, 3, 'Juan', 'Bernat', 'Defender', 14),
(28, 3, 'Marco', 'Verratti', 'Midfielder', 6),
(29, 3, 'Leandro', 'Paredes', 'Midfielder', 8),
(30, 3, 'Ander', 'Herrera', 'Midfielder', 21),
(31, 3, 'Neymar', 'Jr', 'Forward', 10),
(32, 3, 'Kylian', 'Mbappe', 'Forward', 7),
(33, 3, 'Lionel', 'Messi', 'Forward', 30);

-- Add foreign key constraints
ALTER TABLE players
ADD CONSTRAINT fk_team_id
FOREIGN KEY (team_id)
REFERENCES team_bar(TEAM_ID);

ALTER TABLE matches
ADD CONSTRAINT fk_h_id
FOREIGN KEY (hometeam_id)
REFERENCES team_bar(TEAM_ID);

ALTER TABLE matches
ADD CONSTRAINT fk_a_id
FOREIGN KEY (awayteam_id)
REFERENCES team_bar(TEAM_ID);

ALTER TABLE team_rank
ADD CONSTRAINT fk_tr_id
FOREIGN KEY (TEAM_ID)
REFERENCES team_bar(TEAM_ID);

--Querying with Joins To display all players along with their team names:

SELECT players.player_id, players.fname, players.lname, team_bar.team_name
FROM players
INNER JOIN team_bar
ON players.team_id = team_bar.team_id;

--Aggregate Query - To calculate total wins, draws, and losses for each team:
SELECT team_id, 
       SUM(win) AS total_wins, 
       SUM(draw) AS total_draws, 
       SUM(lose) AS total_losses
FROM team_rank
GROUP BY team_id;



--Stored Procedure to Insert Player

DELIMITER //
CREATE PROCEDURE insert_player(
    IN playerID INT,
    IN teamID INT,
    IN firstName CHAR(20),
    IN lastName CHAR(20),
    IN position CHAR(20),
    IN jerseyNo INT
)
BEGIN
    INSERT INTO players (player_id, team_id, fname, lname, position, jerseyno)
    VALUES (playerID, teamID, firstName, lastName, position, jerseyNo);
END;
//
DELIMITER ;

-- Example Call to insert_player Procedure
CALL insert_player(32, 3, 'Kylian', 'Mbappe', 'Forward', 7);



-- Create trigger for checking player count
DELIMITER //
CREATE TRIGGER check_player_count
BEFORE INSERT ON players
FOR EACH ROW
BEGIN
    DECLARE player_count INT;

    SELECT COUNT(*) INTO player_count
    FROM players
    WHERE team_id = NEW.team_id;

    IF player_count >= 11 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert more than 11 players in the same team.';
    END IF;
END;
//
DELIMITER ;

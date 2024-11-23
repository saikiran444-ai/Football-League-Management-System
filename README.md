# Football-League-Management-System

Overview
This project is a GUI-based system developed to manage player information for a database. It incorporates features for data insertion, validation, and dynamic data constraints, utilizing a MySQL backend.

Features Implemented
Player Information Management:
The system allows the insertion of player details, including:

First Name
Last Name
Player ID
Jersey Number
Position
Team ID
Stored Procedure for Player Insertion:

A stored procedure ensures that no more than 11 players can be inserted with the same team_id.
Trigger for Team Player Limit:

A trigger is implemented to validate the insertion process and prevent adding more than 11 players to a team, generating an error if the limit is exceeded.
GUI Integration:

The system is built using Python, providing a user-friendly interface to interact with the database.
Tools and Technologies
Database: MySQL
Frontend: Python (GUI framework)
Development Environment: MySQL Workbench, Terminal (macOS)

Primary Table:
Players table with fields:

player_id (Primary Key)
first_name
last_name
jersey_number
position
team_id
Getting Started
Clone this repository.
Set up the database using MySQL with the schema provided.
Run the Python GUI to manage player information.
Future Scope
Adding more advanced data validation techniques.
Introducing additional features like player performance tracking and team statistics.

CREATE DATABASE user_db;
USE user_db;

CREATE TABLE users (
  id integer PRIMARY KEY AUTO_INCREMENT,
  wallet_address VARCHAR(255) NOT NULL,
  first_name TEXT NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO users (wallet_address, first_name)
VALUES 
('My First Note', 'A note about something'),
('My Second Note', 'A note about something else');
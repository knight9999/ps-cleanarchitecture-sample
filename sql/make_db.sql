DROP TABLE IF EXISTS users;

CREATE TABLE users
  ( id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE
  , firstName Text
  , lastName Text
  );

INSERT INTO users (firstName, lastName) VALUES ('Patricia', 'Smith');
INSERT INTO users (firstName, lastName) VALUES ('Linda', 'Johnson');
INSERT INTO users (firstName, lastName) VALUES ('Mary', 'William');
INSERT INTO users (firstName, lastName) VALUES ('Robert', 'Jones');
INSERT INTO users (firstName, lastName) VALUES ('James', 'Brown');
INSERT INTO users (firstName, lastName) VALUES ('Susan', 'Taylor');



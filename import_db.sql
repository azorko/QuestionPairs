CREATE TABLE users (
  user_id INTEGER PRIMARY KEY, 
  fname VARCHAR(30) NOT NULL,
  lname VARCHAR(20) NOT NULL
);
 
CREATE TABLE questions (
  question_id INTEGER PRIMARY KEY, 
  title VARCHAR(30) NOT NULL,
  body VARCHAR(255) NOT NULL,
  user_id INTEGER REFERENCES users(user_id)
);
  
CREATE TABLE question_followers
(questionfollower_id INTEGER PRIMARY KEY,
question_id INTEGER REFERENCES questions (question_id),
user_id INTEGER REFERENCES users (user_id)
);

CREATE TABLE replies
(reply_id INTEGER PRIMARY KEY,
question_id INTEGER REFERENCES questions (question_id),
parent_id INTEGER REFERENCES replies (reply_id),
user_id INTEGER REFERENCES users (user_id),
body VARCHAR(250) NOT NULL
);

CREATE TABLE question_likes (
  questionlike_id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions (question_id),
  user_id INTEGER REFERENCES users (user_id),
);

-- Users
INSERT INTO
  users
  (fname, lname)
VALUES 
  ('Anastasia', 'Zorko');

INSERT INTO
  users
  (fname, lname)
VALUES
  ('Danny', 'Burt');
INSERT INTO
  users
  (fname, lname)
VALUES
  ('CJ', 'Burt-Zorko');
INSERT INTO
  users
  (fname, lname)
VALUES
  ('Gilly', 'Burt-Zorko');

--Questions
INSERT INTO 
  questions 
  (title, body, user_id)
VALUES 
  ("What's the weather?", 'Is it hot?',
    (SELECT
      user_id
    FROM
      users
    WHERE
      fname = 'Anastasia'
    )
  );
INSERT INTO 
  questions 
  (title, body, user_id)
VALUES 
  ("What's your favorite color?", 'Is it red?',
    (SELECT
      user_id
    FROM
      users
    WHERE
      fname = 'Anastasia'
    )
  );
INSERT INTO 
  questions 
  (title, body, user_id)
VALUES 
  ("What's your IQ?", 'Is it zero?',
    (SELECT
      user_id
    FROM
      users
    WHERE
      fname = 'Anastasia'
    )
  );
INSERT INTO 
  questions 
  (title, body, user_id)
VALUES 
  ("What's the weather?", 'Is it hot?',
    (SELECT
      user_id
    FROM
      users
    WHERE
      fname = 'Danny'
    )
  );
INSERT INTO 
  questions 
  (title, body, user_id)
VALUES 
  ("What's your favorite color?", 'Is it red?',
    (SELECT
      user_id
    FROM
      users
    WHERE
      fname = 'Danny'
    )
  );
INSERT INTO 
  questions 
  (title, body, user_id)
VALUES 
  ("What's your IQ?", 'Is it zero?',
    (SELECT
      user_id
    FROM
      users
    WHERE
      fname = 'Danny'
    )
  );

--Question Followers
INSERT INTO 
  question_followers 
  (question_id, user_id)
VALUES 
  ((SELECT question_id FROM questions WHERE question_id = 1), (SELECT user_id FROM users WHERE fname = 'CJ'));
INSERT INTO 
  question_followers 
  (question_id, user_id)
VALUES 
  ((SELECT question_id FROM questions WHERE question_id = 2), (SELECT user_id FROM users WHERE fname = 'Gilly'));
INSERT INTO 
  question_followers 
  (question_id, user_id)
VALUES 
  ((SELECT question_id FROM questions WHERE question_id = 1), (SELECT user_id FROM users WHERE fname = 'Gilly'));


--Replies
INSERT INTO 
  replies 
  (question_id, parent_id, user_id, body)
VALUES 
  ((SELECT question_id FROM questions WHERE question_id = 1), NULL, (SELECT user_id FROM users WHERE fname = 'CJ'), "It's not freezing; It's raining and hailing. Idk I'm a kid.");

INSERT INTO 
  replies 
  (question_id, parent_id, user_id, body)
VALUES 
  ((SELECT question_id FROM questions WHERE question_id = 1), (SELECT reply_id FROM replies WHERE reply_id = 1), (SELECT user_id FROM users WHERE fname = 'Gilly'), "You're an idiot.");

--Question Likes
INSERT INTO 
  question_likes 
  (question_id, user_id)
VALUES 
  ((SELECT question_id FROM questions WHERE question_id = 1), (SELECT user_id FROM users WHERE fname = 'CJ'));
INSERT INTO 
  question_likes  
  (question_id, user_id)
VALUES 
  ((SELECT question_id FROM questions WHERE question_id = 1), (SELECT user_id FROM users WHERE fname = 'Gilly'));
INSERT INTO 
  question_likes  
  (question_id, user_id)
VALUES 
  ((SELECT question_id FROM questions WHERE question_id = 1), (SELECT user_id FROM users WHERE fname = 'Danny'));
INSERT INTO 
  question_likes  
  (question_id, user_id)
VALUES 
  ((SELECT question_id FROM questions WHERE question_id = 2), (SELECT user_id FROM users WHERE fname = 'Anastasia'));
INSERT INTO 
  question_likes  
  (question_id, user_id)
VALUES 
  ((SELECT question_id FROM questions WHERE question_id = 1), (SELECT user_id FROM users WHERE fname = 'Anastasia'));
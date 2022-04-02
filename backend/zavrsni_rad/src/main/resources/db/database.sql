CREATE TABLE role
(
  id SERIAL,
  role_name VARCHAR(20) NOT NULL,
  UNIQUE(role_name),
  PRIMARY KEY (id)
);

CREATE TABLE users
(
  e_mail VARCHAR(100) NOT NULL,
  password CHAR(60) NOT NULL,
  username VARCHAR(50) NOT NULL,
  id SERIAL,
  profile_picture VARCHAR(100) NOT NULL,
  is_banned BOOLEAN NOT NULL,
  role_id INT NOT NULL,
  is_confirmed BOOLEAN NOT NULL,
  UNIQUE(username,e_mail),
  PRIMARY KEY (id),
  FOREIGN KEY (role_id) REFERENCES Role(id)
);

CREATE TABLE recipe
(
  cover_picture VARCHAR(100) NOT NULL,
  recipe_name VARCHAR(50) NOT NULL,
  description VARCHAR(500) NOT NULL,
  id SERIAL,
  is_approoved BOOLEAN NOT NULL,
  cooking_duration INT NOT NULL,
  user_id INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE recipe_step
(
  id SERIAL,
  step_description VARCHAR(500) NOT NULL,
  order_number INT NOT NULL,
  recipe_id INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (recipe_id) REFERENCES Recipe(id)
);

CREATE TABLE image
(
  id SERIAL,
  order_number INT NOT NULL,
  link VARCHAR(100) NOT NULL,
  recipe_id INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (recipe_id) REFERENCES Recipe(id)
);

CREATE TABLE ingredient
(
  id SERIAL,
  ingredient_name VARCHAR(50) NOT NULL,
  quantity INT NOT NULL,
  measure VARCHAR(50) NOT NULL,
  recipe_id INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (recipe_id) REFERENCES Recipe(id)
);

CREATE TABLE video
(
  id SERIAL,
  order_number INT NOT NULL,
  link VARCHAR(100) NOT NULL,
  recipe_id INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (recipe_id) REFERENCES Recipe(id)
);

CREATE TABLE favorite
(
  user_id INT NOT NULL,
  recipe_id INT NOT NULL,
  PRIMARY KEY (user_id, recipe_id),
  FOREIGN KEY (user_id) REFERENCES Users(id),
  FOREIGN KEY (recipe_id) REFERENCES Recipe(id)
);

CREATE TABLE rating
(
  rating_value INT NOT NULL,
  user_id INT NOT NULL,
  recipe_id INT NOT NULL,
  PRIMARY KEY (user_id, recipe_id),
  FOREIGN KEY (user_id) REFERENCES Users(id),
  FOREIGN KEY (recipe_id) REFERENCES Recipe(id)
);

CREATE TABLE comments
(
  comment_text VARCHAR(200) NOT NULL,
  user_id INT NOT NULL,
  recipe_id INT NOT NULL,
  PRIMARY KEY (user_id, recipe_id),
  FOREIGN KEY (user_id) REFERENCES Users(id),
  FOREIGN KEY (recipe_id) REFERENCES Recipe(id)
);
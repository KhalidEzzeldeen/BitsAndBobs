# strength.sql

# strength-test experimental results

DROP TABLE IF EXISTS strength;
CREATE TABLE strength
(
  date    DATE,         # date of test
  subject VARCHAR(20),  # subject name
  arm     VARCHAR(5),   # arm tested
  weight  INT           # amount lifted
);

INSERT INTO strength (date,subject,arm,weight)
VALUES ('2005-04-03','Marvin','right',19);
INSERT INTO strength (date,subject,arm,weight)
VALUES ('2005-04-04','Frank','left',25);
INSERT INTO strength (date,subject,arm,weight)
VALUES ('2005-04-04','Frank','right',25);
INSERT INTO strength (date,subject,arm,weight)
VALUES ('2005-04-05','Jane','left',10);
INSERT INTO strength (date,subject,arm,weight)
VALUES ('2005-04-06','Marvin','left',21);
INSERT INTO strength (date,subject,arm,weight)
VALUES ('2005-04-07','Willis','left',25);
INSERT INTO strength (date,subject,arm,weight)
VALUES ('2005-04-08','Jane','right',12);
INSERT INTO strength (date,subject,arm,weight)
VALUES ('2005-04-09','Willis','right',25);

SELECT * FROM strength;

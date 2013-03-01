# employee.sql

DROP TABLE IF EXISTS employee;
CREATE TABLE employee
(
  name        CHAR(20),
  department  CHAR(20)
);

INSERT INTO employee (name,department)
  VALUES
    ('Fred','accounting'),
    ('Fred','accounting'),
    ('Fred','accounting'),
    ('Fred','accounting'),
    ('Bob','shipping'),
    ('Mary Ann','shipping'),
    ('Mary Ann','shipping'),
    ('Mary Ann','sales'),
    ('Mary Ann','sales'),
    ('Mary Ann','sales'),
    ('Mary Ann','sales'),
    ('Mary Ann','sales'),
    ('Mary Ann','sales'),
    ('Boris',NULL),
    ('Boris',NULL)
;

SELECT * FROM employee;

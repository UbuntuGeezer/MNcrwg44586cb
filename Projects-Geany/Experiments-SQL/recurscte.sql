.open '/media/ubuntu/Windows/Users/Bill/Territories/FL/SARA/86777/Projects-Geany/Experiments-SQL/Recurs.db'
drop table if exists employees;
-- This first segment builds a table 'employees'
--   first_name, last_name, boss_id and populates it;
create table employees
(id INTEGER, first_name TEXT, last_name TEXT,
 boss_id INTEGER);
INSERT INTO employees
VALUES(1,'Domenic','Leaver',5);
INSERT INTO employees
VALUES(2,'Cleveland','Hewins',1);
INSERT INTO employees
VALUES(3,'Kakalita','Atherton',8);
INSERT INTO employees
VALUES(4,'Roxanna','Fairlee',NULL);
INSERT INTO employees
VALUES(5,'Hermie','Comsty',4);
INSERT INTO employees
VALUES(6,'Pooh','Goss',8);
INSERT INTO employees
VALUES(7,'Faulkner','Challiss',5);
INSERT INTO employees
VALUES(8,'Bob','Blakeway',4);
INSERT INTO employees
VALUES(9,'Laurene','Burchill',1);
INSERT INTO employees
VALUES(10,'August','Gosdin',8);

-- * this second segment processes the 'employees' table
-- * using a recursive table 'company_heirarchy' that
-- *
-- * the first select, only selects the record with the
-- * boss_id NULL adding the field heirarchy_level with
-- * value 0; 
WITH RECURSIVE company_hierarchy AS (
  SELECT    id,
            first_name,
            last_name,
            boss_id,
        0 AS hierarchy_level
  FROM employees
  WHERE boss_id IS NULL
 
  UNION ALL
   
  SELECT    e.id,
            e.first_name,
            e.last_name,
            e.boss_id,
        hierarchy_level + 1
  FROM employees e, company_hierarchy ch
  WHERE e.boss_id = ch.id
)
 
SELECT   ch.first_name AS employee_first_name,
       ch.last_name AS employee_last_name,
       e.first_name AS boss_first_name,
       e.last_name AS boss_last_name,
       hierarchy_level
FROM company_hierarchy ch
LEFT JOIN employees e
ON ch.boss_id = e.id
ORDER BY ch.hierarchy_level, ch.boss_id;


-- * the first select is a recursive build.. that
-- * sets up the company_heirarchy table for the main
-- * query.
-- * The UNION ALL keeps extracting records;
--* the first "secondary" select...;
--*  FROM employees e, company_heirarchy.ch is shorthand
-- * for FROM employees AS e, company_heirarchy AS ch
-- * which allows the query to abbreviate the tablenames
-- * to single letters:
-- * WHERE e.boss_id = ch.id gathers all records for a
-- *   given boss_id
-- * into the company_heirarchy table;

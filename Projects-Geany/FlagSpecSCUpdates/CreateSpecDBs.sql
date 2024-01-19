-- * CreateSpecDBs - Create SpecialDBs.db database.
-- * 1/30/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 1/30/23.	wmk.	original code.
-- *
-- * Notes. The SpecialDBs.db.DBNames table is a table of database names and
-- * date last modified. The records are populated by UpdateDBNames.sql which
-- * uses *ls and *awk to create a .csv of database names and last date modified.
-- *;
.open '$pathbase/RawData/SCPA/SCPA-Downloads/Special/SpecialDBs.db'
DROP TABLE IF EXISTS DBNames;
CREATE TABLE DBNames(
 DBName TEXT, LastModified TEXT,
 Status INTEGER,
 PRIMARY KEY (Status));
.quit
 -- ** END CreateSpecDBs;

-- * UpdateDBNames.sql - Update DBNames.db records.
-- * 1/30/23.	wmk.
-- *
-- * Entry.	/SCPA-Downloads/Special/SpecialDBs.db.DBNames is table of SC special
-- *		 databases
-- *		DBNameDates.csv is the record data for updating DBNames
-- * 
-- * Exit.	DBNames.db entries are updated with entries from the .csv
-- *		 file DBNameDates.csv
-- *
-- * Modification History.
-- * ---------------------
-- * 1/30/23.	wmk.	original code.
-- *
-- * Notes. The shell UpdateDBNames.sh has preamble code that generates the
-- * DBNameDates.csv file using *ls and *awk utilities.
-- *
-- * When *ls produces a list using -lh, the date modified field will
-- * either be <monthname> <day> <timestamp> or <monthname> <day> <year>
-- * the <year> and <timestamp> are differentiated with ':' being present
-- * in the <timestamp>. The <year> will only be present if it differs
-- * from the current year. *awk formats the .csv field the same as the
-- * RecordDate field <year>-<month>-<day>.
-- *;

.open '$pathbase/RawData/SCPA/SCPA-Downloads/Special/SpecialDBs.db'
.headers off
.mode csv
.separator ,
DROP TABLE IF EXISTS NameUpdates;
CREATE TABLE NameUpDates(
 SpecDB TEXT,
 ModDate TEXT, 
 base_status INTEGER DEFAULT 0, 
 Status INTEGER DEFAULT 0,
 PRIMARY KEY(Status));
.import '$pathbase/RawData/SCPA/SCPA-Downloads/Special/DBNameDates.csv' NameUpdates
DROP TABLE IF EXISTS DBNames;
CREATE TABLE DBNames(
 DBName TEXT, ModDate TEXT, base_status INTEGER, Status INTEGER,
 PRIMARY KEY(Status) );
 
INSERT OR REPLACE INTO DBNames
SELECT SpecDB, ModDate, (rowid-1)*2, (rowid-1)*2 FROM NameUpdates;

with a AS (SELECT * FROM OutofDates),
b AS (SELECT DBName,base_status FROM DBNames)
INSERT INTO NewOutOfDates
SELECT a.DBName, a.PropiD, b.base_status FROM a
INNER JOIN b
ON b.DBName IS a.DBName;

.quit
-- * END UpdateDBNames.sql;

-- * UPDATE Status field in DBNames (and OutOfDates);
with a as (select distinct DBName DName from OUtofDates)
UPDATE DBNames
SET Status =
CASE WHEN DBName in (select DName from a)
 THEN Status+1
ELSE Status
END;
-- * At this point in OutOfDates, if Status is odd, propiD is 
-- * out-of-date in database DBName;

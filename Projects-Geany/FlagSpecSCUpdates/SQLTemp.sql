-- * UpdateDBNames.sql - Update DBNames.db records.
-- * 1/30/23.	wmk.
-- *
-- * Entry.	/SCPA-Downlaods/Special/SpecialDBs.db.DBNames is table of SC special
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

.open '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Special/SpecialDBs.db'
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
.import '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Special/DBNameDates.csv' NameUpdates
DROP TABLE IF EXISTS DBNames;
CREATE TABLE DBNames(
 DBName TEXT, ModDate TEXT, base_status INTEGER, Status INTEGER,
 PRIMARY KEY(Status) );
 
INSERT OR REPLACE INTO DBNames
SELECT SpecDB, ModDate, (rowid-1)*2, (rowid-1)*2 FROM NameUpdates;
.quit
-- * END UpdateDBNames.sql;

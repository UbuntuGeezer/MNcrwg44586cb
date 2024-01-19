-- * AddForeignDNC.sql - Add foreign language DNC(s) to TerrIDData.db.DoNotCalls.
-- * 	7/12/22.	wmk.
-- *
-- * Entry. DNCReport/NewForeignDNCs.csv = '|' separated values records
-- *		 to be added to TerrIDData.DoNotCalls; the "Foreign" field
-- *		 in each record will be set to the record *ROWID field.
-- *
-- * Exit DB and table results.
-- *   TerrIDData.db - main, territory ID database
-- *		DoNotCalls - main Do Not Calls table; updated with new
-- *		   foreign language Do Not Calls
-- *		FLAddress - updated with new entries for foreign language(s)
-- *		FLInfo - updated with new entries for foreign language(s)
-- *;

-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * AddForeignDNC - Add foreign language DNC to DoNotCalls.
-- *;

-- ** AttachDBs **********
-- *	7/12/22.	wmk.
-- *--------------------------
-- *
-- * AttachDBs - Attach required databases.
-- *
-- * Entry DB and table dependencies.
-- *   TerrIDData.db - main, territory ID database
-- *		DoNotCalls - main Do Not Calls table; this table is used by
-- *		   the territory generation code for the Territory
-- *		FLAddress - the "parent" table for foreign language reporting
-- *		FLInfo - the relevant details of foreign language DNCs
-- *
-- * NewForeignDNCs.csv - .csv of new "Do Not Call" entries for foreign
-- *    language(s).
-- *		
-- * Exit DB and table results.
-- *   TerrIDData.db - main, territory ID database
-- *		DoNotCalls - main Do Not Calls table; updated with new
-- *		   foreign language Do Not Calls
-- *		FLAddress - updated with new entries for foreign language(s)
-- *		FLInfo - updated with new entries for foreign language(s)
-- *
-- * Modification History.
-- * ---------------------
-- * 7/12/22.	wmk.	original code;
-- *
-- * Notes. This is set up to add a record to the DoNotCalls table,
-- * then integrate that record into the FLAddress and FLInfo tables.
-- * The FLCong table has the congregation information for those
-- * congregations whose territories intersect the English congregation
-- * assigned territory.
-- *;
-- pragma foreign_keys=ON;
-- TerrIDData - main;

.open '$pathbase/DB-Dev/TerrIDData.db'
  
-- ** END AttachDBs **********;

-- ** AddForeignDNC **********
-- *	7/12/22.	wmk.
-- *--------------------------
-- *
-- * AddForeignDNC - Add foreign language DNC to DoNotCalls.
-- *
-- * Entry DB and table dependencies.
-- *   
-- * NewForeignDNCs.csv - .csv of new "Do Not Call" entries for foreign
-- *    language(s).
-- *
-- * Exit DB and table results.
-- *
-- * Modification History.
-- * ---------------------
-- * 7/12/22.	wmk.	original code.
-- *
-- * Notes. Table definition for DoNotCalls (.csv record)
-- * CREATE TABLE "DoNotCalls" ( `TerrID` TEXT NOT NULL, `Name` TEXT,
-- * `UnitAddress` TEXT NOT NULL, `Unit` TEXT, `Phone` TEXT, `Notes` TEXT,
-- * `RecDate` TEXT, `RSO` INTEGER, `Foreign` INTEGER, `PropID` TEXT,
-- * `ZipCode` TEXT, `DelPending` INTEGER, `DelDate` TEXT,
-- * `Initials` TEXT );
-- * The .csv records contain all of the above fields EXCEPT:
-- *  RSO, "Foreign", PropID, DelPending, DelDate.
-- * The RecDate field should be entered in the form 'yyyy-mm-dd.
-- * The .csv field separator is '|' to allow commas in the notes and
-- *  elsewhere.
-- * Currently there is no protection against entering duplicate DNC
-- *  records.
-- *;

DROP TABLE IF EXISTS NewForeign;
CREATE TABLE NewForeign
(TerrID TEXT NOT NULL, Name TEXT, UnitAddress TEXT NOT NULL, Unit TEXT,
 Phone TEXT, ZipCode TEXT, Notes TEXT, RecDate TEXT, Initials TEXT);

.separator |
.mode csv
.import '$pathbase/DoNotCalls/NewForeignDNCs.csv' NewForeign

-- * insert from NewForeign into DoNotCalls;
insert into DoNotCalls
SELECT TerrID, Name, UnitAddress, Unit, Phone,
Notes, RecDate, '', '', '', ZipCode,
'', '', Initials
FROM NewForeign;

-- * delete duplicates, keeping oldest since 'Foreign' set;
DELETE FROM DoNotCalls
WHERE rowid NOT IN (SELECT MIN(rowid) FROM DoNotCalls
 GROUP BY TerrID, Name, Address, Unit, ZipCode);

-- * update 'Foreign' with rowid as FLid;
UPDATE DoNotCalls
SET "Foreign" = rowid
WHERE RecDate LIKE '2022%';

-- * set property ID from Terr86777;
UPDATE DoNotCalls
WHERE LENGTH(PropID) = 0;

-- * select records that will directly match in Terr86777;
with a AS (SELECT "ACCOUNT #" Acct, 
"situs address (property address)" Situs
FROM db2.Terr86777)
SELECT * FROM DoNotCalls
WHERE UPPER(TRIM(UNitaddress))
 IN (SELECT TRIM(SUBSTR(Situs,1,35)) FROM a)
 AND LENGTH(PropID) = 0;

-- * update records that will directly match in Terr86777;
with a AS (SELECT "ACCOUNT #" Acct, 
"situs address (property address)" Situs
FROM db2.Terr86777)
UPDATE DoNotCalls
set PropID =
case 
when UPPER(TRIM(UNitaddress))
 IN (SELECT TRIM(SUBSTR(Situs,1,35)) FROM a)
then (select Acct FROM a
 WHERE TRIM(SUBSTR(Situs,1,35))
   IS UPPER(TRIM(UnitAddress)))
else PropID
end
WHERE Length(PROPid) = 0;
-- ** END AddForeignDNC **********;

-- ** subquery **********
-- *	<date>.	wmk.
-- *--------------------------
-- *
-- * subquery_name - simple description.
-- *
-- * Entry DB and table dependencies.
-- *   <list main DB and ATTACHed DBs and tables>
-- *
-- * Exit DB and table results.
-- *
-- * Modification History.
-- * ---------------------
-- * 7/12/22.	wmk.	original code.
-- *
-- * Notes.
-- *;

-- ** END subquery_name **********;

-- ** END query **********;

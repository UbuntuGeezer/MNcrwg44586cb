-- * RUSpecV86777.psq/sql - Compare <spec-db> record dates against Terr86777.db dates.
-- * 3/22/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 3/22/23.	wmk.	original code.
-- *
-- * Notes. CheckRUSpecVTerr86777 gets the OwningParcel and RecordDate fields 
-- * from the <spec-db>.db.Spec_RUBridge table and compares them against the 
-- * "Account #" and DownloadDate fields from Terr86777 where 
-- * OwningParcel = "Account #". If any corresponding Terr86777 record is newer,
-- * the <spec-db>.db will be considered out-of-date because the SC data has
-- * been udpated since the last <spec-db>.db download.
-- *;

.open '$pathbase/$rupath/Special/<spec-db>.db'
ATTACH '$pathbase/DB-Dev/Terr86777.db'
 AS db2;
-- PRAGMA table_info(Terr86777);

DROP TABLE IF EXISTS OutofDates;
CREATE TEMP TABLE OutofDates(
 PropID TEXT,
 RUDate TEXT,
 SCDate TEXT,
 Mismatches INTEGER );

INSERT INTO OutofDates(PropID, RUDate, SCDate)
SELECT OwningParcel, RecordDate, Terr86777.DownloadDate
FROM Spec_RUBridge
INNER JOIN db2.Terr86777
ON "Account #" IS OwningParcel
 AND DownloadDate > RecordDate;

-- somehow output the below select...;

.headers off
.mode list
.output '/home/vncwmk3/temp/RUoodResults.sh'
SELECT CASE WHEN LENGTH(PropID) > 0
 THEN 'dbokay=0'
 ELSE 'dbokay=1'
 END valid8
 FROM OutofDates LIMIT 1;

-- * END RUSpecV86777.sql;

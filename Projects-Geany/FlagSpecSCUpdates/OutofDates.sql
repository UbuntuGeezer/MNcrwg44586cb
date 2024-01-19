-- * OutOfDates.sql - search DBList databases for out-of-date records.
-- * 1/31/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 1/31/23.	wmk.	original code.
-- *
-- * Notes. OutOfDates compares records from <special-db> against the corresponding
-- * records in Terr86777, building an OutofDates table in SCPA.Special/SpecialDBs.db.
-- *;
.open '$pathbase/RawData/SCPA/SCPA-Downloads/Special/SpecialDBs.db'
ATTACH '$pathbase/DB-Dev/Terr86777.db'
 AS db2;
ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads/Special/WhitePineTreeRd.db'
 AS db29;
CREATE TABLE IF NOT EXISTS OutOfDates(
 DBName TEXT, PropID TEXT,
 PRIMARY KEY(PropID) );

WITH a AS (SELECT OwningParcel PropiD,
 RecordDate RecDate FROM db29.Spec_SCBridge)
INSERT OR REPLACE INTO OutOfDates
SELECT "WhitePineTreeRd.db", "Account #" Acct 
from db2.Terr86777
 INNER JOIN a ON a.PropiD = Acct
 WHERE DownloadDate > a.RecDate
 ;
.quit
-- * END OutOfDates.sql; 

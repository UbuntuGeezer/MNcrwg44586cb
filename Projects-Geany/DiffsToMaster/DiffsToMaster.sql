-- * DiffsToMaster.psq/sql - Update master territory database with new differences.
-- *	1/23/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 1/23/23.	wmk.	original code.
-- *
-- * Notes. DiffsToMaster uses the INSERT/REPLACE INTO sql command to bring the
-- * Terr86777.db/Terr86777 table up-to-date. The parcel ID (Account #) field is
-- * the primary key for the Terr86777 table, so a new parcel ID will add a
-- * record, while an existing parcel ID will replace a record.
-- *;

-- * open databases;
.open '$pathbase/DB-Dev/Terr86777.db'
ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads'
 || '/SCPADiff_01-13.db'
 AS db15;
-- PRAGMA db15.table_info(Diff0113);

-- * update Terr86777 from Diff0113 table;
INSERT OR REPLACE INTO Terr86777
SELECT * FROM db15.Diff0113;

.quit
-- ** END DiffsToMaster.sql

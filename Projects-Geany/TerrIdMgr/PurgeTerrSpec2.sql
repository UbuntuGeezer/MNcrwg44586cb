-- * PurgeTerrSpec2.psq/sql - module description.
-- * 6/3/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 6/3/23.	wmk.	original code.
-- *
-- * Notes. This query removes all records from the special territory
-- * Woodlands.db.db in both SCPA-Downloads and RefUSA-Downloads/Special
-- * that have territory ID 964.
-- *
-- *;

-- * attach databases;
.open '$pathbase/DB-Dev/junk.db'

ATTACH '$pathbase/$scpath/Special/Woodlands.db'
 AS db29;
--pragma db29.table_info(Spec_SCBridge);

-- * clear records from SC/Special db;
DELETE FROM db29.Spec_SCBridge
WHERE CongTerrID IS '964';

.quit
-- * END PurgeTerrSpec2.sql;

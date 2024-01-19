-- * PurgeTerrSpec1.psq/sql - module description.
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

ATTACH '$pathbase/$rupath/Special/Woodlands.db'
  AS db30;
--pragma db30.table_info(Spec_RUBridge);

-- * clear records from RU/Spec_SCBridge;
DELETE FROM db30.Spec_RUBridge
WHERE CongTerrID IS '964';

.quit
-- * END PurgeTerrSpec.sql;

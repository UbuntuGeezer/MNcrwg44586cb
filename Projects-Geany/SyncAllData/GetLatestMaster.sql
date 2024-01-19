-- * GetLatestMaster.sql - Get date of latest Terr86777.db record matching db table.
-- * 3/22/23.	wmk.
-- *
-- * Entry.	*DoSed1 has set the following fields:
-- *
-- * < db-path > = database path (e.g. *pathbase/*rupath/Special)
-- * < db-name > = database name (e.g. CapriIslesBvd.db)
-- * < db-table > = database table (e.g. Spec_RUBridge)
-- *
-- * Exit. .csv record:
-- *		*TEMP_PATH/LatestMasterDate.txt = "< db-name >", yyyy-mm-dd 
-- *
-- * Modification History.
-- * ---------------------
-- * 2/18/23.	wmk.	original code.
-- * 3/22/23.	wmk.	DoSed1 comment updated.
-- *
-- * Notes. Spec_RUBridge must have DownloadDate field.
-- *;
-- * open TheEsplanade having Spec_RUBridge;
-- * attach Terr86777 as db2;
.open '/home/vncwmk3/Territories/FL/SARA/86777/RawData/RefUSA/RefUSA-Downloads/Special/TheEsplanade'
--PRAGMA table_info(Spec_RUBridge);

ATTACH '$pathbase/DB-Dev/Terr86777.db'
 AS db2;
--PRAGMA db2.table_info(Terr86777);

-- * output to file *TEMP_PATH/LatestMasterDate.txt;
.mode csv
.headers off
.separator ,
.output '$TEMP_PATH/LatestMasterDate.txt'

-- * select latest download date of any common record;
WITH a AS (SELECT OwningParcel FROM Spec_RUBridge)
SELECT 'TheEsplanade',MAX(DownloadDate) FROM db2.Terr86777
 WHERE "Account #" IN (SELECT OwningParcel FROM a);
.quit
 -- * END GetLatestMaster.sql;-- * .open <spec-db>.db;


-- * TestSQLErr.psq/sql - module description.
-- * 2/6/23.	wmk.
-- *
-- * Entry. /DB-Dev/Terr86777.db has latest county download data
-- *		//home/vncwmk3/Territories/FL/SARA/86777/RawData/RefUSA/RefUSA-Downloads/Special/WhitePineTreeRd.db.Spec_RUBridge has field "OwningParcel" present
-- *		 (i.e. is a Bridge table)
-- *
-- * Exit. *TEMP_PATH/TestSQLErr = MAX(DownloadDate) in Terr86777.Terr86777
-- *		 set of records that is in WhitePineTreeRd.db.Spec_RUBridge 
-- *
-- * Modification History.
-- * ---------------------
-- * 2/6/23.	wmk.	original code.
-- *
-- * Notes. TestSQLErr extracts the latest *DownloadDate* field from
-- * Terr86777.Terr86777 records whose *Account #" field is in the set
-- * of Spec_SCBridge.OwningParcel fields of some <spec-db>.db.
-- *
-- * TestSQLErr.psq depends upon *sed editing the *db-path*,
-- * *db-name*, and db-table placeholders to be the path, db name and table
-- * of the database having the records of interest in Terr86777.db.
-- * (Note. The *sed that performs this edit is in preamble1.sh
-- *;
.open '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/Terr86777.db'
ATTACH '/home/vncwmk3/Territories/FL/SARA/86777/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/GoobleDeeDook.db'
 AS db19;
.mode csv
.headers off
.output '/home/vncwmk3/temp/TestSQLErr.txt'
WITH a AS (SELECT OwningParcel PropID FROM db19.Spec_RUBridge)
SELECT MAX(DownloadDate), " WhitePineTreeRd.db" FROM Terr86777
 WHERE "Account #" IN (SELECT PropID FROM a);
-- * END TestSQLErr.sql;
.quit

-- * DNCDetail.sql - Generate DNCDetail.csv in Tracking folder.
-- *	5/17/23.	wmk.
-- *
-- * Entry.	*pathbase/DB-Dev/TerrIDData.db.DoNotCalls table has all
-- *	DO NOT CALL entries.
-- *
-- * Exit.  *pathbase/Projects-Geany/DoTerrsWithCalc/Tracking/DNCDetail.csv
-- * 	has count of RSOs by territory. This can easily be imported into a
-- *	spreadsheet for a general format report.
-- *
-- * Modification History.
-- * ---------------------
-- * 7/10/22.	wmk.	original code.
-- * 5/17/23.	wmk.	target path corrected to use *codebase.
-- *
-- * This query should be run through the AnySQLtoSH project to produce the
-- * DNCDetail.sh shell. That shell will produce the output described in the
-- * Exit conditions above.
-- *;
.open '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/TerrIDData.db'
ATTACH '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/Terr86777.db'
 AS db2;
--pragma db2.table_info(Terr86777);
DROP TABLE IF EXISTs DNCDetail;
create temp table DNCDetail
(TID  TEXT, Address TEXT, Unit TEXT, Name TEXT, Phone TEXT,
 RecDate TEXT, CntyDate TEXT,
 RSO TEXT, FL TEXT, ZIP TEXT, Notes TEXT);
WITH b AS (SELECT "Account #" Acct, DownloadDate CountyDate
 FROM db2.Terr86777 WHERE Acct IN (SELECT PropID FROM DoNotCalls))
insert into DNCDetail
SELECT TERRID, UnitAddress, Unit, Name, Phone, RecDate, b.CountyDate, RSO,
 "Foreign", ZipCode, Notes
FROM donotcalls
INNER JOIN b
ON b.Acct IS PropID
order by TERRID;
.mode csv
.headers on
.separator ,
.output '/home/vncwmk3/GitHub/TerritoriesCB/Projects-Geany/DoTerrsWithCalc/Tracking/DNCDetail.csv'
select * from DNCDetail;
.quit
-- ** END DNCDetail **********;

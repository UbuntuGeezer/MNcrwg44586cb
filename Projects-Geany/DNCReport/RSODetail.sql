-- * RSODetail.sql - Generate RSODetail.csv in Tracking folder.
-- *	7/10/22.	wmk.
-- *
-- * Entry.	*pathbase/DB-Dev/TerrIDData.db.DoNotCalls table has all
-- *	DO NOT CALL entries.
-- *
-- * Exit.  *pathbase/Projects-Geany/DoTerrsWithCalc/Tracking/RSODetail.csv
-- * 	has count of RSOs by territory. This can easily be imported into a
-- *	spreadsheet for a general format report.
-- *
-- * This query should be run through the AnySQLtoSH project to produce the
-- * RSODetail.sh shell. That shell will produce the output described in the
-- * Exit conditions above.
-- *;
.open '$pathbase/DB-Dev/TerrIDData.db'
DROP TABLE IF EXISTs RSODetail;
create temp table RSODetail
(TID  TEXT, Address TEXT, Unit TEXT, Name TEXT, Phone TEXT, Notes TEXT,
  SODate TEXT);
insert into RSODetail
SELECT TERRID, UnitAddress, Unit, Name, Phone, Notes, RecDate 
fROM donotcalls
 WHERE RSO > 0
  AND LENGTH(RSO) > 0
order by TERRID;
.mode csv
.headers on
.separator ,
.output '$pathbase/Projects-Geany/DoTerrsWithCalc/Tracking/RSODetail.csv'
select * from RSODetail;
.quit
-- ** END RSODetail **********;

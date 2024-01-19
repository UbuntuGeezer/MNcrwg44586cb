-- * RSOSummary.sql - Generate RSOSummary.csv in Tracking folder.
-- *	7/10/22.	wmk.
-- *
-- * Entry.	*pathbase/DB-Dev/TerrIDData.db.DoNotCalls table has all
-- *	DO NOT CALL entries.
-- *
-- * Exit.  *pathbase/Projects-Geany/DoTerrsWithCalc/Tracking/RSOSummary.csv
-- * 	has count of RSOs by territory. This can easily be imported into a
-- *	spreadsheet for a general format report.
-- *
-- * This query should be run through the AnySQLtoSH project to produce the
-- * RSOSummary.sh shell. That shell will produce the output described in the
-- * Exit conditions above.
-- *;
.open '$pathbase/DB-Dev/TerrIDData.db'
DROP TABLE IF EXISTs RSOCount;
create temp table RSOCount
(TID  TEXT, NRSOs  integer, OldestRSO TEXT, NewestRSO TEXT);
insert into RSOCount
SELECT DISTINCT TERRID, '0', '', '' fROM donotcalls
order by TERRID;
with a as (SELECT TerrID,DelPending, 
  RecDate NumDate, RSO from donotcalls)
update RSOCount
set nRSOs =
case
when TID IN (SELECT TerrID from a)
 THEN (SELECT COUNT() TERRID from a
  where TERRID IS TID
  and DelPending IS NOT 1
  AND RSO > 0
  AND LENGTH(RSO) > 0)
else nRSOs
end,
OldestRSO = (SELECT NumDate FROM a 
 WHERE NumDate IN (SELECT MIN(NumDate) FROM a
   WHERE TerrID IS TID
     AND RSO > 0
     AND LENGTH(RSO) > 0)),
NewestRSO =  (SELECT NumDate FROM a 
 WHERE NumDate IN (SELECT MAX(NumDate) FROM a
   WHERE TerrID IS TID
     AND RSO > 0
     AND LENGTH(RSO) > 0));
DELETE FROM RSOCount
WHERE nRSOS = 0;
.mode csv
.headers on
.separator ,
.output '$pathbase/Projects-Geany/DoTerrsWithCalc/Tracking/RSOSummary.csv'
select * from RSOcount;
.quit
-- ** END RSOSummary **********;

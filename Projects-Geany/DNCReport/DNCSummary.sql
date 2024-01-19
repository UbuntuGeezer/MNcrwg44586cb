-- * DNCSummary.sql - Generate DNCSummary.csv in Tracking folder.
-- *	7/10/22.	wmk.
-- *
-- * Entry.	*pathbase/DB-Dev/TerrIDData.db.DoNotCalls table has all
-- *	DO NOT CALL entries.
-- *
-- * Exit.  *pathbase/Projects-Geany/DoTerrsWithCalc/Tracking/DNCSummary.csv
-- * 	has count of DNCs by territory. This can easily be imported into a
-- *	spreadsheet for a general format report.
-- *
-- * This query should be run through the AnySQLtoSH project to produce the
-- * DNCSummary.sh shell. That shell will produce the output described in the
-- * Exit conditions above.
-- *;
.open '$pathbase/DB-Dev/TerrIDData.db'
DROP TABLE IF EXISTs DncCount;
create temp table DncCount
(TID  TEXT, Ndncs  integer, OldestDNC TEXT, NewestDNC TEXT);
insert into DNCCount
SELECT DISTINCT TERRID, '0', '', '' fROM donotcalls
order by TERRID;
with a as (SELECT TerrID,DelPending, 
  RecDate NumDate from donotcalls)
update DncCount
set ndncs =
case
when TID IN (SELECT TerrID from a)
 THEN (SELECT COUNT() TERRID from a
  where TERRID IS TID
  and DelPending IS NOT 1)
else ndncs
end,
OldestDNC = (SELECT NumDate FROM a 
 WHERE NumDate IN (SELECT MIN(NumDate) FROM a
   WHERE TerrID IS TID)),
NewestDNC =  (SELECT NumDate FROM a 
 WHERE NumDate IN (SELECT MAX(NumDate) FROM a
   WHERE TerrID IS TID));
.mode csv
.headers on
.separator ,
.output '$pathbase/Projects-Geany/DoTerrsWithCalc/Tracking/DNCSummary.csv'
select * from dnccount;
.quit
-- ** END DNCSummary **********;

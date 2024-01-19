-- * DumpRSOLog.sql - Dump RSOLog table to RSOLog.csv for spreadsheet.
-- *	6/14/23.	wmk.
-- *
-- * Entry.	/DB-Dev/TerrIDData.RSOLog = Territory RSO operations log.
-- *
-- * Exit.	/DNCMgr/RSOLog.csv = .csv export of RSOLog table entries.
-- *
-- * Modification History.
-- * ---------------------
-- * 6/12/23.	wmk.	original code; adapted from DumpDNCLog.
-- * 6/14/23.	wmk.	header corrected.
-- * Legacy mods.
-- * 4/26/23.	wmk.	original code.
-- * 5/3/23.	wmk.	name change to ReportOrphans; results on OrphansIDs.csv.
-- *
-- * Notes.
-- *;
.open '$pathbase/DB-Dev/TerrIDData.db'
.headers on
.mode csv
.separator "|"
.output '$codebase/Projects-Geany/DNCMgr/RSOLog.csv'
select * FROM RSOLog; 
.quit

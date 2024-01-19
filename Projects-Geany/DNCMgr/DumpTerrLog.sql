-- * DumpTerrLog.sql - Dump TerrLog table to TerrLog.csv for spreadsheet.
-- *	6/12/23.	wmk.
-- *
-- * Entry.	/DB-Dev/TerrIDData.TerrLog = Territory operations log.
-- *
-- * Exit.	/DNCMgr/TerrLog.csv = .csv export of TerrLog table entries.
-- *
-- * Modification History.
-- * ---------------------
-- * 6/12/23.	wmk.	original code; adapted from DumpDNCLog.
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
.output '$codebase/Projects-Geany/DNCMgr/TerrLog.csv'
select * FROM TerrLog; 
.quit

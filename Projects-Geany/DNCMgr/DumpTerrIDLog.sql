-- * DumpTerrIDLog.sql - Dump DNCLog table to DNCLog.csv for spreadsheet.
-- *	6/12/23.	wmk.
-- *
-- * Entry.	/DB-Dev/TerrIDData.DNCLog = DNC operations log.
-- *
-- * Exit.	/DNCMgr/DNCLog.csv = .csv export of DNCLog table entries.
-- *
-- * Modification History.
-- * ---------------------
-- * 6/12/23.	wmk.	original code; adapted from DumpDNCLog.
-- * Legacy mods.
-- * 4/26/23.	wmk.	original code.
-- * 5/3/23.	wmk.	name change to ReportOrphans; results on OrphansIDs.csv.
-- *
-- * Notes. modified by DoSed with m 2, d 2 changed to month/day of current download.
-- * Cannot use mm, dd since it would alter SitusAddressPropertyAddress.
-- *;
.open '$pathbase/DB-Dev/TerrIDData.db'
.headers on
.mode csv
.separator "|"
.output '$codebase/Projects-Geany/DNCMgr/Log.csv'
select * FROM DNCLog; 
.quit

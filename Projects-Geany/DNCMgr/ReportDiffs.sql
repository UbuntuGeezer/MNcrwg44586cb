-- * ReportDiffs.sql - Report from DNCDiffs table to DNCDiffs.csv for spreadsheet.
-- *	6/11/23.	wmk.
-- *
-- * Entry.	/DB-Dev/TerrIDData.DNCDiffs = differences table of Territories data
-- *	vs. all_dncs_report.pdf entries
-- *
-- * Exit.	/DNCMgr/DNCDiffs.csv = .csv export of DNCDiffs table entries.
-- *
-- * Modification History.
-- * ---------------------
-- * 6/11/23.	wmk.	original code; adapted from ReportOrphans.
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
.output '$codebase/Projects-Geany/DNCMgr/DNCDiffs.csv'
select * FROM DNCDiffs; 
.quit

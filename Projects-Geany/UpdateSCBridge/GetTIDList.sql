-- GetTIDList.psq/sql - Get list of territories affected by SC download.
--	11/22/22.	wmk.
--
-- * Modification History.
-- * ----------------------
-- * 11/22/22.	wmk.	*codebase support.
-- * Legacy mods.
-- * 4/25/22.	wmk.	edited for FL/SARA/86777;*pathbase* support.
-- * 5/1/22.	wmk.	modified to output list to TIDList0528.csv
-- * 7/1/22.	wmk.	documentation/comments updated.
-- * Legacy mods.
-- * 6/26/21.	wmk.	original code.
-- *
-- * Notes. This .psq is modified by DoSed1, changing @ @   z z to the month
-- * and day of the new download. Since this is not linked to any specific
-- * territory, DoSed1 is used to make the changes. The *make* file
-- * MakeGetTIDList needs no modification, since the SQL code does all the work.
-- *;

-- * subquery list.
-- * --------------
-- * GetSCUpdateList - Get list of territories affected by SC download.
-- *;

-- ** GetSCUpdateList ********
-- *	11/22/22.	wmk.
-- *--------------------------
-- *
-- * GetSCUpdateList - Get list of territories affected by SC download.
-- *
-- * Entry DB and table dependencies.
-- *   <list main DB and ATTACHed DBs and tables>
-- *
-- * Exit DB and table results.
-- *
-- * Notes. DoSed substitutes the month and day of the SCPADiff_mm-dd.db
-- * into @ @ and z z fields.
-- *;
.open '$pathbase/DB-Dev/junk.db'
ATTACH '$pathbase'
 || '/RawData/SCPA/SCPA-Downloads/SCPADiff_05-28.db'
  AS db16;
.mode csv
.headers on
.output '$codebase/Projects-Geany/UpdateSCBridge/TIDList0528.csv'
SELECT distinct TerrID FROM db16.DiffAccts
where length(TerrID) > 0
 ORDER BY TerrID;
.quit
-- ** END GetSCUpdateList **********

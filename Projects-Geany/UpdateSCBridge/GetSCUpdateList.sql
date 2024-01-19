-- GetSCUpdateList.sql - Get list of territories affected by SC download.
--	11/22/22.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 11/22/22.	wmk.	*codebase support.
-- * Legacy mods.
-- * 6/26/21.	wmk.	original code.
-- * 5/2/22.	wmk.	*pathbase* support; added code to also check
-- *			 PolyTerri.db.
-- * 5/27/22.	wmk.	*pathbase* actually added.
-- *;

-- * subquery list.
-- * --------------
-- * GetSCUpdateList - Get list of territories affected by SC download.
-- *;

-- ** GetSCUpdateList **********
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
-- * Notes.
-- *;
.open '$pathbase/DB-Dev/junk.db'
ATTACH '$pathbase'
 || '/RawData/SCPA/SCPA-Downloads/SCPADiff_05-28.db'
  AS db16;
ATTACH '$pathbase'
 || '/DB-Dev/MultiMail.db'
 AS db3;
.mode csv
.headers on
.output '$codebase/Projects-Geany/UpdateSCBridge/TIDListOOD.csv'
with a AS (SELECT "Account #" AS Acct FROM Diff0528 )
SELECT DISTINCT OwningParcel AS PropID, CongTerrID AS TerrID
FROM SplitProps
 WHERE PropID IN (SELECT Acct FROM a)
 AND rowid IN (SELECT rowid FROM SplitProps 
  WHERE rowid IN (SELECT MAX(rowid) FROM SplitProps
   GROUP BY  OwningParcel,CongTerrID))
   ORDER BY TerrID;

-- ** END GetSCUpdateList **********

-- SCNewVsCongTerr.psq.sql- Difference SC download with Terr86777.
-- * 4/26/23.	wmk.
-- *
-- * Exit. 
-- *    SCNVenDiff_mm-dd.db - database of differences between
-- *	  SCPA_mm-dd.db and VeniceNTerritory.db records
-- *		Diffmmdd - extracted new records from SCPA_mm-dd
-- *		DiffAccts - table of difference property IDs
-- *	Terr86777.db - active territories database
-- *		Terr86777 - udpated with newer records from SCPA_mm-dd.db.Datammdd
-- *
-- * Dependencies.
-- * 	sed must perform the following modifications to this query:
-- *
-- *		m m and d d replaced with month and day of latest SCPA download
-- *	
-- *	the sed-edited query will reside in file SCNewVsNVenall.sql

-- * Modification History.
-- * ---------------------
-- * 11/27/22.	wmk.	CB code review; comments tidied.
-- * 4/26/23.	wmk.	bug fix DiffAccts/DiffAcct field name corrected to PropID;
-- *			 DelFlag defaulted to '0' in DiffAccts table; INSERT mode changed
-- *			 to INSERT or REPLACE into Diffmmdd; comments updated to reflect
-- *			 SCPADiff_mm-dd.db.
-- * Legacy mods.
-- * 4/27/22.	wmk.	modified for general use; name change to SCNewVsCongTerr
-- *			 from SCNewVsNvenall; FL/SARA/86777.
-- * 5/27/22.	wmk.	bug fix "Account #" not being SELECTed from Terr86777;
-- *		 Terr86777 table reference qualified with .db2; TerrID field added
-- *		 to DifAccts table.
-- * Legacy mods.
-- * 4/26/22.	wmk.	*pathbase* support.
-- * Legacy mods.
-- * 2/28/21.	wmk.	original code.
-- * 6/25/21.	wmk.	multihost support.
-- * 11/3/21.	wmk.	name change to SCNewVsNVenall.psq; revert to
-- *					using $ prefix with folderbase;
-- *
-- * subquery list.
-- * --------------
-- * SCNewVsCongTerr.sql - Difference SC download with Terr86777.
-- *;

-- ** SCNewVsCongTerr **********
-- *	4/26/23.	wmk.
-- *------------------------
-- *
-- * SCNewVsCongTerr.sql - Difference SC download with Terr86777.
-- *
-- * Entry DB and table dependencies.
-- *    SCPADiff_mm-dd.db - as main, empty .db for difference records
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	SCPA_mm-dd.db - as db15, SCPA (new) full download from date 05/28/2021
-- *		Datammdd - SCPA download records from date 05/28/2021
-- *
-- * Exit DB and table results
-- *    SCNVenDiff_mm-dd.db - as main, populated .db with difference records
-- *		Diffmmdd - table of differences between db2, db15
-- *
-- * Modification History.
-- * ---------------------
-- * 4/27/22.	wmk.	modified for CongTerr/Terr86777.
-- * 4/26/23.	wmk.	comments updated to reflect SCPADiff_mm-dd.db.
-- * Legacy mods.
-- * 2/28/21.	wmk.	original code.
-- * 6/25/21.	wmk.	multihost support.
-- * 11/3/21.	wmk.	rewrite using MiscQueries; revert folderbase to
-- *					use leading $.
-- *
-- * Notes. The Diffmmdd table is the latest differences (assuming that
-- * things have been kept up-to-date) that can be INSERT OR REPLACEd
-- * into the Terr86777 SCPA data used for the territories. Diff05md
-- * contains all records that need to be updated for the entire county.
-- * The table "Accts86777" in the AuxSCPAData.db provides the criteria
-- * for any accounts within the VeniceNTerritory.db NVenAll territory.
-- *;

.open '$pathbase/RawData/SCPA/SCPA-Downloads/SCPADiff_mm-dd.db'
attach '$pathbase/RawData/SCPA/SCPA-Downloads'
|| '/SCPA_mm-dd.db'
as db15;
attach '$pathbase'
|| '/DB-Dev/Terr86777.db'
as db2;

-- * create DiffAccts;
DROP TABLE IF EXISTS DiffAccts;
CREATE TABLE DiffAccts
(PropID TEXT,
 DiffHstead TEXT,
 DiffYr TEXT,
 DiffMo TEXT,
 DiffDa TEXT,
 DelFlag INTEGER DEFAULT 0,
 TerrID TEXT,
 PRIMARY KEY(PropID) );
-- * populate DiffAccts;
WITH a AS (SELECT "Account #" AS Account FROM db2.Terr86777)
INSERT INTO DiffAccts
SELECT "ACCOUNT#" AS PropID,
 "homesteadexemption(yesorno)" AS DiffAcct,
 cast(substr("lastsaledate",7,4) AS INTEGER)
 AS DiffYr,
 cast(substr("lastsaledate",1,2) AS INTEGER)
 AS DiffMo,
 cast(substr("lastsaledate",4,2) AS INTEGER)
 AS DiffDa, 1 AS DelFlag,
 '000'
 FROM db15.Datammdd
 WHERE PropID IN (SELECT Account FROM a);

-- * change DelFlag to 0 in order to
-- * undelete changed homesteads;
 WITH a AS (SELECT "Account #" AS Acct,
 "homestead exemption" AS OldHStead,
 cast(substr( "last sale date",7,4) AS INTEGER)
  as OldYr,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldMo,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldDa
  FROM Terr86777
 )
  UPDATE DiffAccts
  SET DelFlag = 0
  WHERE DiffHStead IS NOT (SELECT OldHstead FROM A
   WHERE Acct IS DiffAcct);
  
-- * change DelFlag to 0 in order to
-- * undelete changed sale dates;
WITH a AS (SELECT "Account #" AS Acct,
 "homestead exemption" AS OldHStead,
 cast(substr( "last sale date",7,4) AS INTEGER)
  as OldYr,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldMo,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldDa
  FROM Terr86777
 )
  UPDATE DiffAccts
  SET DelFlag = 0
  WHERE DiffYr = 2021
  AND (DiffYr IS NOT (SELECT OldYr FROM A
   WHERE Acct IS DiffAcct)
   OR DiffMo IS NOT (SELECT OldMo FROM a
   WHERE Acct IS DiffAcct)
   OR DiffDa IS NOT (SELECT OldDa FROM a
   WHERE Acct IS NOT DiffAcct) )
   ;

-- * Add difference records into Diffmmdd;
WITH a AS (SELECT DiffAcct FROM DiffAccts
  WHERE DelFlag = 0)
INSERT OR REPLACE INTO Diffmmdd
select * from db15.Datammdd
where "Account#" in
 (select DiffAcct FROM a);

.quit
-- ** END SCNewVsCongTerr.psq/sql **********;

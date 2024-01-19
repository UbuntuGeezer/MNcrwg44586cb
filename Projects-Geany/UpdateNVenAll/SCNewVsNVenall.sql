--SCNewVsNVenall.psq.sql- Difference SC download with NVenAll.
--	11/3/21.	wmk.
-- *
-- * Exit 
-- *    SCNVenDiff_03-19.db - database of differences between
-- *	  SCPA_03-19.db and VeniceNTerritory.db records
-- *		Diff0319 - extracted new records from SCPA_03-19
-- *		DiffAccts - table of difference property IDs
-- *	VeniceNTerritory.db - active territories database
-- *		NVenAll - udpated with newer records from SCPA_03-19.db.Data0319
-- *
-- * Dependencies.
-- * 	sed must perform the following modifications to this query:
-- *
-- *		m m and d d replaced with month and day of latest SCPA download
-- *	
-- *	the sed-edited query will reside in file SCNewVsNVenall.sql

-- * Modification History.
-- * ---------------------
-- * 2/28/21.	wmk.	original code.
-- * 6/25/21.	wmk.	multihost support.
-- * 11/3/21.	wmk.	name change to SCNewVsNVenall.psq; revert to
-- *					using $ prefix with folderbase;
-- *
-- * subquery list.
-- * --------------
-- * SCNewVsNVenall.sql - Difference SC download with NVenAll.
-- *;

-- ** SCNewVsNVen **********
-- *	11/3/21.	wmk.
-- *------------------------
-- *
-- * SCNewVsNVen.sql - Difference SC download with NVenAll.
-- *
-- * Entry DB and table dependencies.
-- *    SCNVenDiff_03-19.db - as main, empty .db for difference records
-- *	VeniceNTerritory.db - as db2, SCPA data for NV territory
-- *		NVenAll - SCPA property records
-- *	SCPA_03-19.db - as db15, SCPA (new) full download from date m2/d2/2021
-- *		Data0319 - SCPA download records from date m2/d2/2021
-- *
-- * Exit DB and table results
-- *    SCNVenDiff_03-19.db - as main, populated .db with difference records
-- *		Diff0319 - table of differences between db2, db15
-- *
-- * Modification History.
-- * ---------------------
-- * 2/28/21.	wmk.	original code.
-- * 6/25/21.	wmk.	multihost support.
-- * 11/3/21.	wmk.	rewrite using MiscQueries; revert folderbase to
-- *					use leading $.
-- *
-- * Notes. The Diff0319 table is the latest differences (assuming that
-- * things have been kept up-to-date) that can be INSERT OR REPLACEd
-- * into the NVenAll SCPA data used for the territories. Diffm2md
-- * contains all records that need to be updated for the entire county.
-- * The table "AcctsNVen" in the AuxSCPAData.db provides the criteria
-- * for any accounts within the VeniceNTerritory.db NVenAll territory.
-- *;

.open '$folderbase/Territories/RawData/SCPA/SCPA-Downloads/SCPADiff_03-19.db'
attach '$folderbase/Territories/RawData/SCPA/SCPA-Downloads'
|| '/SCPA_03-19.db'
as db15;
attach '$folderbase/Territories'
|| '/DB-Dev/VeniceNTerritory.db'
as db2;

-- * create DiffAccts;
DROP TABLE IF EXISTS DiffAccts;
CREATE TABLE DiffAccts
(DiffAcct TEXT,
 DiffHstead TEXT,
 DiffYr TEXT,
 DiffMo TEXT,
 DiffDa TEXT,
 DelFlag INTEGER DEFAULT 1,
 PRIMARY KEY(DiffAcct) );
-- * populate DiffAccts;
WITH a AS (SELECT Account FROM NVenAccts)
INSERT INTO DiffAccts
SELECT "ACCOUNT#" AS PropID,
 "homesteadexemption(yesorno)" AS DiffAcct,
 cast(substr("lastsaledate",7,4) AS INTEGER)
 AS DiffYr,
 cast(substr("lastsaledate",1,2) AS INTEGER)
 AS DiffMo,
 cast(substr("lastsaledate",4,2) AS INTEGER)
 AS DiffDa, 1 AS DelFlag
 FROM db15.Data0319
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
  FROM NVenAll
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
  FROM NVenAll
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

-- * A19 difference records into Diff1102;
WITH a AS (SELECT DiffAcct FROM DiffAccts
  WHERE DelFlag = 0)
INSERT OR IGNORE INTO Diff0319
select * from db15.Data0319
where "Account#" in
 (select DiffAcct FROM a);

.quit
-- ** END SCNewVsNVenall.psq/sql **********;
--***********************************************;
-- code moved to DiffsToNVenAll.psq..;
-- move to DiffsToNVenAll.psq...
-- * Update NVenAll with Diff1102 differences;
.open 'SCPADiff_03-19.db'
--attach '$folderbase/Territories/RawData/SCPA/SCPA-Downloads'
--|| '/SCPA_03-19.db'
--as db15;
WITH a AS (Select DiffAcct FROM DiffActs
WHERE DelFlag = 0)
INSERT OR REPLACE INTO NVenAll
SELECT * FROM Data0319
WHERE "Account#" IN (SELECT DiffAcct from a);

-- * select same fields from NVenAll;
SELECT "Account #" AS Acct,
 "homestead exemption" AS OldHStead,
 cast(substr( "last sale date",7,4) AS INTEGER)
  as OldYr,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldMo,
 cast(substr("last sale date",1,2) AS INTEGER)
  as OldDa
  FROM NVenAll
;


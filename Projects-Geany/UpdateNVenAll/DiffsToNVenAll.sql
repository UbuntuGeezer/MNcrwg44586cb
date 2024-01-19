--DiffsToNVenAll.psq/sql - Integrate SC download differences into NVenAll.
--	2/9/22.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 2/28/21.	wmk.	original code.
-- * 6/26/21.	wmk.	multihost support.
-- * 8/25/21.	wmk.	spaces removed from Diffxxxx field names.
-- * 11/3/21.	wmk.	total rewrite.
-- * 12/3/21.	wmk.	DiffAcct field corrected to PropID.
-- * 2/9/22.	wmk.	DelFlag test bug fix; NVenAll qualified with db2;
-- *			 db15.SCPA_03-19.db eliminated from queries.
-- *
-- * Notes. This query is expected to be integrated into a shell which
-- * will inherit or explicitly set ($)folderbase environment var to
-- * properly access the host's Territory file system.
-- *;

-- * subquery list.
-- * --------------
-- * DiffsToNVenAll - Integrate SC download differences into NVenAll.
-- *;

-- ** DiffsToNVenAll **********
-- *	1/9/22.	wmk.
-- *---------------------------
-- *
-- * DiffsToNVenAll - Integrate SC download differences into NVenAll.
-- *
-- * Entry DB and table dependencies.
-- *	VeniceNTerritory.db - as db2, SCPA data for NV territory
-- *		NVenAll - SCPA property records
-- *	SCPADiff_m2-d2.db as db16,  Difference collection of new/updated
-- *	  property records between current and past SCPA downloads
-- *		Diff0319 - table of differences new/updated SCPA records
-- *		  where either last sale date or homestead exemption field(s)
-- *		  have changed
-- *		DiffAccts (future) table of property ids and territory ids of
-- *		  parcels in Diffm2md table {PropID, TerrID}
-- *
-- * Exit DB and table results.
-- *	VeniceNTerritory.db - as db2, SCPA data for NV territory
-- *		NVenAll - records with new from Diffm2d2 replacing records
-- *		  where parcel ID (Account #) matches.
-- *
-- * Modification History.
-- * ---------------------
-- * 2/28/21.	wmk.	original code.
-- * 6/20/21.	wmk.	revert to full field names; multihost support.
-- * 6/26/21.	wmk.	multihost code co03ented; ensure proper refs
-- * 					to Diff field names.
-- * 11/3/21.	wmk.	total rewrite.
-- * 12/3/21.	wmk.	DiffAcct field corrected to PropID.
-- * 2/9/22.	wmk.	DelFlag test bug fix; NVenAll qualified with db2;
-- *					db15.SCPA_03-19.db eliminated from queries.
-- *
-- * Notes. All of the differences work has already been performed by
-- * SCNewVsNVenAll.sh;

-- * open junk as main, then open other dbs;
.open '$folderbase/Territories/DB-Dev/junk.db'

-- move to DiffsToNVenAll.psq...
-- * Update NVenAll with Diff1102 differences;
attach '$folderbase/Territories/RawData/SCPA/SCPA-Downloads'
|| '/SCPADiff_03-19.db'
as db14;
attach '$folderbase/Territories/DB-Dev'
|| '/VeniceNTerritory.db'
as db2;

WITH a AS (Select PropID FROM db14.DiffAccts
WHERE DelFlag is not '1')
INSERT OR REPLACE INTO db2.NVenAll
SELECT * FROM db14.Diff0319
WHERE "Account#" IN (SELECT PropID from a);

.quit
-- ** END DiffsToNVenAll **********;

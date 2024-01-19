-- * DiffsToCongTerr.psq/sql - Integrate SC download differences into Terr86777.
-- *	4/26/23.	wmk.
-- *
-- * DoSed must modify this query with m 2 and d 2 of the month/day of the
-- * current download.
-- *
-- * Modification History.
-- * ---------------------
-- * 11/27/22.	wmk.	bug fix; DiffAcct corrected to PropID in DiffAccts
-- *			 query.
-- * 2/4/23.	wmk.	comments corrected to CongTerr from NVenAll.
-- * 4/25/23.	wmk.	PropID corrected to DiffAcct in query.
-- * 4/26/23.	wmk.	DiffAcct changed back to PropID.
-- * Legacy mods.
-- * 4/27/22.	wmk.	modified for general use FL/SARA/86777.
-- * Legacy mods.
-- * 4/26/22.    wmk.   *pathbase* support.
-- * Legacy mods.
-- * 2/28/21.	wmk.	original code.
-- * 6/26/21.	wmk.	multihost support.
-- * 8/25/21.	wmk.	spaces removed from Diffxxxx field names.
-- * 11/3/21.	wmk.	total rewrite.
-- * 12/3/21.	wmk.	DiffAcct field corrected to PropID.
-- * 2/9/22.	wmk.	DelFlag test bug fix; NVenAll qualified with db2;
-- *			 db15.SCPA_mm-dd.db eliminated from queries.
-- *
-- * Notes. This query is expected to be integrated into a shell which
-- * will inherit or explicitly set ($)folderbase environment var to
-- * properly access the host's Territory file system.
-- *;

-- * subquery list.
-- * --------------
-- * DiffsToCongTerr - Integrate SC download differences into Terr86777.
-- *;

-- ** DiffsToCongTerr **********
-- *	4/26/23.	wmk.
-- *---------------------------
-- *
-- * DiffsToCongTerr - Integrate SC download differences into Terr86777.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	SCPADiff_05-28.db as db16,  Difference collection of new/updated
-- *	  property records between current and past SCPA downloads
-- *		Diffmmdd - table of differences new/updated SCPA records
-- *		  where either last sale date or homestead exemption field(s)
-- *		  have changed
-- *		DiffAccts (future) table of property ids and territory ids of
-- *		  parcels in Diff05md table {DiffAcct, TerrID}
-- *
-- * Exit DB and table results.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - records with new from Diff0528 replacing records
-- *		  where parcel ID (Account #) matches.
-- *
-- * Modification History.
-- * ---------------------
-- * 11/27/22.	wmk.	bug fix; DiffAcct corrected to PropID in DiffAccts
-- *			 query; bug fix; no DelFlag field in DiffAccts.
-- * 2/4/23.	wmk.	comments corrected to CongTerr from NVenAll.
-- * 4/25/23.	wmk.	PropID corrected to DiffAcct in query.
-- * 4/26/23.	wmk.	DiffAcct changed back to PropID.
-- * Legacy mods.
-- * 4/27/22.	wmk.	modified for general use FL/SARA/86777; *pathbase*
-- *			 support included.
-- * Legacy mods.
-- * 2/28/21.	wmk.	original code.
-- * 6/20/21.	wmk.	revert to full field names; multihost support.
-- * 6/26/21.	wmk.	multihost code commented; ensure proper refs
-- * 					to Diff field names.
-- * 11/3/21.	wmk.	total rewrite.
-- * 12/3/21.	wmk.	DiffAcct field corrected to PropID.
-- * 2/9/22.	wmk.	DelFlag test bug fix; NVenAll qualified with db2;
-- *					db15.SCPA_mm-dd.db eliminated from queries.
-- *
-- * Notes. All of the differences work has already been performed by
-- * SCNewVsCongTerr.sh;

-- * open junk as main, then open other dbs;
.open '$pathbase/DB-Dev/junk.db'

-- move to DiffsToCongTerr.psq...
-- * Update Terr86777 with Diff0528 differences;
attach '$pathbase/RawData/SCPA/SCPA-Downloads'
|| '/SCPADiff_05-28.db'
as db14;
attach '$pathbase/DB-Dev'
|| '/Terr86777.db'
as db2;

--WITH a AS (Select PropID FROM db14.DiffAccts)
--WHERE DelFlag is not '1')
WITH a AS (Select PropID FROM db14.DiffAccts)
INSERT OR REPLACE INTO db2.Terr86777
SELECT * FROM db14.Diff0528
WHERE "Account#" IN (SELECT PropID from a);

.quit
-- ** END DiffsToCongTerr **********;

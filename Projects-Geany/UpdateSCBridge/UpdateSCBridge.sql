-- * UpdateSCBridge.psq/sql - Update SC Bridge table for territory 141.
-- *	12/26/22.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 12/26/22.	wmk.	bug fix; comments tidied.
-- * Legacy mods.
-- * 4/25/22.	wmk.	modified for general use;*pathbase* support.
-- * 5/28/22.	wmk.	added code to build Diff0528 within Terr141_SCdb
-- *			 since it was missing in 0426 and 0526 builds.
-- * Legacy mods.
-- * 11/3/21.	Total rewrite; change to use Diffsmmd within Terr141_SC.db
-- *			containing change records; Integrate change records fields
-- *			into Terr141_SCBridge;
-- * Legacy mods.
-- * 3/1/21.	Original code.
-- * 3/11/21.	Documentation; bug fix where populating query for diff
-- *			using "property use code" for "propertyusecode" field.
-- * 5/27/21.	modified for use with Kay's system.
-- * 6/18/21.	multihost code generalized.
-- * 6/19/21.	Notes updated with terrbase placeholder.
-- * 6/20/21.	revert to full field names.
-- * 6/27/21.	bug fix where INSERT did not have "Download Date" field;
-- *			P records not updating "Record Date" field.
-- * 9/6/21.	use $ folderbase in place of terrbase.
-- * 9/30/21.	use " in place of reverse single quote for fields.
-- *
-- * Notes. t errbase is used as a placeholder in file paths to
-- * facilitate sed stream editing, substituting ($)folderbase for the
-- * shell script to pick up.

-- * subquery list.
-- * --------------
-- * UpdateSCBridge - Update SC Bridge table for territory 141.
-- *;

-- ** UpdateSCBridge **********
-- *	4/25/22.	wmk.
-- *--------------------------
-- *
-- * UpdateSCBridge - Update SC Bridge table for territory 141.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db - as main, scratch db
-- *	Terr141_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr141_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 141
-- *	folderbase = environment var set before this query is executed from
-- *	  a shell by being written via echo statements
-- *
-- * Exit DB and table results.
-- *
-- * Modification History.
-- * ---------------------
-- * 3/1/21.	Original code.
-- * 3/11/21.	Documentation; bug fix where populating query for diff
-- *			using "property use code" for "propertyusecode" field.
-- * 5/27/21.	modified for use with Kay's system.
-- * 6/27/21.	bug fix where INSERT did not have "Download Date" field.
-- * 9/30/21.	use " in place of reverse single quote for fields.
-- *
-- * Notes. UpdateSCBridge takes both the UpdtP.csv and UpdtM.csv file
-- * data, places the records into temp tables, then uses the temp tables
-- * to update the Resident1, Phone2 (Homestead), and PropUse fields
-- * in the SC Bridge table for the territory where the OwningParcel
-- * matches the Account # field on the temp table(s).
-- *;

.open "$pathbase/DB-Dev/junk.db"

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/SCPADiff_05-28.db'
  AS db19;

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/Terr141/Terr141_SC.db'
  AS db11;
--  PRAGMA db11.table_info(Terr141_SCBridge);
--  PRAGMA db11.table_info(Diffs0528);

-- * create and populate Diffs0528 from SCPADiff_05-DD.db.Diffs05DD for
-- * this territory;
DROP TABLE IF EXISTS db11.Diffs0528;
CREATE TABLE db11.Diffs0528
( "Account#" TEXT, Owner1 TEXT, Owner2 TEXT, Owner3 TEXT,
MailingAddress1 TEXT, MailingAddress2 TEXT, MailingCity TEXT, 
MailingState TEXT, MailingZipCode TEXT, MailingCountry TEXT, 
"SitusAddress(PropertyAddress)" TEXT, SitusCity TEXT, SitusState TEXT, 
SitusZipCode TEXT, PropertyUseCode TEXT, Neighborhood TEXT, 
Subdivision TEXT, TaxingDistrict TEXT, Municipality TEXT, 
WaterfrontCode TEXT, "HomesteadExemption(YESorNO)" TEXT, 
HomesteadExemptionGrantYear TEXT, Zoning TEXT, ParcelDesc1 TEXT, 
ParcelDesc2 TEXT, ParcelDesc3 TEXT, ParcelDesc4 TEXT, 
"Pool(YESorNO)" TEXT, TotalLivingUnits TEXT, "LandAreaS.F." TEXT, 
GrossBldgArea TEXT, LivingArea TEXT, Bedrooms TEXT, Baths TEXT, 
HalfBaths TEXT, YearBuilt TEXT, LastSaleAmount TEXT, LastSaleDate TEXT, 
LastSaleQualCode TEXT, PriorSaleAmount TEXT, PriorSaleDate TEXT, 
PriorSaleQualCode TEXT, JustValue TEXT, AssessedValue TEXT, 
TaxableValue TEXT, LinktoPropertyDetailPage TEXT, ValueDataSource TEXT, 
ParcelCharacteristicsData TEXT, Status TEXT, DownloadDate TEXT, 
PRIMARY KEY ("Account#") );
WITH a AS (SELECT OwningParcel AS PropID
 FROM db11.Terr141_SCBridge)
INSERT OR REPLACE INTO db11.Diffs0528
SELECT * FROM db19.Diff0528
 WHERE "ACCOUNT#" IN (SELECT PropID FROM a);

-- * Now Update records using information from each table; start with PDiff.;
WITH a AS (SELECT "Account#" AS Acct,
 CASE 
 WHEN "HomesteadExemption(YesorNo)" IS "YES"
  THEN "*" 
 ELSE " "
 END AS Hstead,
 "propertyusecode" AS UseType, 
  CASE
  WHEN LENGTH("Owner3") > 0
   THEN TRIM(SUBSTR("Owner1",1,25)) || ", "
     || TRIM("Owner2") || ", " 
     || TRIM("Owner3")
  WHEN LENGTH("Owner2") > 0 
   THEN TRIM(SUBSTR("Owner1",1,25)) || ", "
     || TRIM("Owner2")
  ELSE TRIM(SUBSTR("Owner1",1,25))
  END AS Owners,
  DownloadDate AS DownDate
  FROM db11.Diffs0528 )
UPDATE db11.Terr141_SCBridge
SET Resident1 =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN (SELECT Owners from a 
  WHERE Acct IS OwningParcel
 )
ELSE Resident1 
END,
 Phone2 = 
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN (SELECT Hstead from a 
  WHERE Acct IS OwningParcel
 )
ELSE Phone2
END,
 PropUse = 
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN (SELECT UseType from a 
  WHERE Acct IS OwningParcel
 )
ELSE PropUse
END,
RecordDate = 
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN (SELECT DownDate from a
  WHERE Acct IS OwningParcel
 )
ELSE RecordDate
END;
--WHERE OwningParcel IN (SELECT Acct FROM a);

.quit
-- ** END UpdateSCBridge **********;


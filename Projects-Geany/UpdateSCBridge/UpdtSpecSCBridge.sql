--UpdtSpecSCBridge.psq/sql - Update SC Bridge table for TrianoCir.
--	2/5/23.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 4/25/22.	wmk.	modified for general use;*pathbase* support.
-- * 2/5/23.	wmk.	superfluous '.db' removed from ATTACH.
-- * Legacy mods.
-- * 11/6/21.	wmk.	original code; adapted from UpdateSCBridge;
-- *					integrate change records fields into
-- *					TrianoCir.db.Spec_SCBridge; @ @ and z z used
-- *					for mm dd in SCPADiff db name.
-- * 3/20/22.	wmk.	remove DownDate criteria from 11/6.
-- *
-- * Legacy mods.
-- * 11/3/21.	Total rewrite; change to use Diffsmmd within Terrxxx_SC.db
-- *			containing change records; Integrate change records fields
-- *			into Terrxxx_SCBridge;
-- *
-- * Notes. t errrbase is used as a placeholder in file paths to
-- * facilitate sed stream editing, substituting ($)folderbase for the
-- * shell script to pick up.
-- * <s pecial-db> is used as a placeholder in filepaths and database
-- * table name(s) to facilitate stream editing by sed. These strings
-- * will be fixed by DoSed1 from the Build menu.

-- * subquery list.
-- * --------------
-- * UpdtSpecSCBridge - Update Special SC Bridge table.
-- *;

-- *-------------------------------------------------------------
-- * UpdtSpecSCBridge - Update Special SC Bridge table.
-- *	2/5/23.	wmk.
-- *-------------------------------------------------------------
-- *
-- * UpdtSpecSCBridge - Update SC Bridge table for territory xxx.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db - as main, scratch db
-- *	TrianoCir.db - as db29, Special download of SC records
-- *		Spec_SCBridge - Bridge formatted records extracted from SCPA
-- *			for street/area TrianoCir.
-- *	folderbase = environment var set before this query is executed from
-- *	  a shell by being written via echo statements
-- *
-- * Exit DB and table results.
-- *
-- * Modification History.
-- * ---------------------
-- * 4/25/22.	wmk.	*pathbase* replaces *folderbase* stuff.
-- * 2/5/23.	wmk.	superfluous '.db' suffix removed from ATTACH.
-- * Legacy mods.
-- * 11/6/21.	wmk.	original code; adapted from UpdateSCBridge;
-- *					integrate change records fields into
-- *					vvvvv.db.Spec_SCBridge.
-- * 11/6/21.	wmk.	mod to include DownDate in update criteria.
-- * 3/20/22.	wmk.	remove DownDate criteria from 11/6.
-- *
-- * Notes. UpdtSpecSCBridge takes both the UpdtP.csv and UpdtM.csv file
-- * data, places the records into temp tables, then uses the temp tables
-- * to update the Resident1, Phone2 (Homestead), and PropUse fields
-- * in the SC Bridge table for the territory where the OwningParcel
-- * matches the Account # field on the temp table(s).
-- *;

.open '$pathbase/DB-Dev/junk.db'

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/Special/TrianoCir.db'
  AS db29;
--  PRAGMA db29.table_info(Spec_SCBridge);
ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads'
  || '/SCPADiff_05-28.db'
as db11;
--  PRAGMA db11.table_info(Diff0528);

-- * Now Update records using information from Diffs0528.;
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
  FROM db11.Diff0528 )
UPDATE db29.Spec_SCBridge
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
-- ** END UpdtSpecSCBridge **********;

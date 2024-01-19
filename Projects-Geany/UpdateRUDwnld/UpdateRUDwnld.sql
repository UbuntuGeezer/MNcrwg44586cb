--UpdateRUDwnld.sql - Update Terrxxx RU download from SC Bridge.
--	4/25/22.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 4/25/22.	wmk.	generalized for FL/SARA/86777;*pathbase* support.
-- * Legacy mods.
-- * 2/28/21.	wmk.	original for make; changed Terryyy references to
-- *					Terrxxx too facilitate sed placing territory ID
-- *				 in sql.
-- * 3/1/21.	wmk.	modified to use SC Bridge to update records (see
-- *					Notes).
-- * 3/9/21.	wmk.	bug fix; ATTACH using RefUSA corrected to SCPA.
-- * 6/6/21.	wmk.	documentation updated; multihost not supported.
-- *
-- * Notes. Originally coded to use the Previous RU.db to update. There
-- * were problems with this method when a multi-unit building was on
-- * a street with directional not properly picking up units. By changing
-- * to update from the SC data, all the fields can be picked up correctly
-- * since the SC download is updated first.
-- * subquery list.
-- *
-- * --------------
-- * SetParcels - Set Terrxxx RU download parcels from prior RUBridge.
-- * UpdateDwnldRecs - Update downloaded record fields from prior info.
-- *;

-- ** SetParcelsFromSC **********
-- *	3/1/21.	wmk.
-- *-----------------------------
-- *
-- * SetParcels - Set Terrxxx RU download parcels from SCBridge.
-- *
-- * Entry DB and table dependencies.
-- *	Terrxxx_SC.db - as db11, updated territory records from SCPA polygon
-- *		Terrxxx_SCBridge - updated Bridge formatted records from SCPA
-- *			from latest SC download for territory xxx
-- *	Terrxxx_RU.db - as main, newly downloaded territory records from
-- *	  RefUSA polygon needing to be filled
-- *		Terrxxx_RUBridge - sorted Bridge formatted records extracted 
-- *			from latest RefUSA polygon, but missing key fields
-- *	user runs sed to change all occurrences of 3ys below to terr ID
-- *
-- * Exit DB and table results.
-- *	Terrxxx_RU.db - as main, new territory records from RefUSA polygon
-- *		Terrxxx_RUBridge - OwningParcel set in new records from
-- *		  SCBridge data where missing 
-- *
-- * Modification History.
-- * ---------------------
-- * 2/28/21.	wmk.	original code.
-- * 3/1/21.	wmk.	modified to use INNER JOIN for more accurate
-- *					updates.
-- * 3/9/21.	wmk.	bug fix; ATTACH using RefUSA corrected to SCPA.
-- * Notes.;

-- * db11. - /Terrxxx/Terrxxx_SC.db
-- * main - /Terrxxx/Terrxxx_RU.db

.cd '$pathbase/RawData'
-- * .open ~/Terrxxx_RU.db;
.open './RefUSA/RefUSA-Downloads/Terrxxx/Terrxxx_RU.db'

ATTACH '$pathbase'
 ||		'/DB-Dev/TerrIDData.db'
  AS db4;
--  PRAGMA db4.table_info(DoNotCalls);


ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/Terrxxx/Terrxxx_SC.db'
  AS db11;
--  PRAGMA db11.table_info(Terrxxx_SCBridge);


--ATTACH '$pathbase'
-- ||		'/RawData/SCPA/SCPA-Downloads/Terrxxx/Previous/Terrxxx_RU.db'
--  AS db11;
--  PRAGMA db12.table_info(Terrxxx_RUBridge);

pragma database_list;
-- * Set all of them not set by RUTidyTerr_db.sh
WITH a AS
(SELECT main.Terrxxx_RUBridge.OWNINGPARCEL,
 db11.Terrxxx_SCBridge.OwningParcel AS Previous,
 main.Terrxxx_RUBridge.UNITADDRESS,
 main.Terrxxx_RUBridge.UNIT
FROM Terrxxx_RUBridge
INNER JOIN db11.Terrxxx_SCBridge 
 ON db11.Terrxxx_SCBridge.UnitAddress
 = main.Terrxxx_RUBridge.UnitAddress
   AND db11.Terrxxx_SCBridge.Unit
   = main.Terrxxx_RUBridge.Unit 
)
UPDATE main.Terrxxx_RUBridge 
SET OwningParcel = 
CASE 
WHEN main.Terrxxx_RUBridge.UnitAddress
 IN (SELECT UnitAddress FROM a 
 WHERE a.Unit IS main.Terrxxx_RUBridge.Unit)
THEN 
 (SELECT Previous from a 
 WHERE a.UnitAddress IS main.Terrxxx_RUBridge.UnitAddress
  AND a.Unit IS main.Terrxxx_RUBridge.Unit)
ELSE OwningParcel 
END
WHERE OwningParcel IS "-";
 
-- ** END SetParcels **********;


-- * UpdateDwnldRecs - Update missing fields in downloaded records.
-- *
-- * Entry DB and table dependencies.
-- *	Terrxxx_SC.db - as db11, updated territory records from SCPA polygon
-- *		Terrxxx_SCBridge - updated Bridge formatted records from SCPA
-- *			from latest SC download for territory xxx
-- *	Terrxxx_RU.db - as main, newly downloaded territory records from
-- *	  RefUSA polygon needing to be filled
-- *		Terrxxx_RUBridge - sorted Bridge formatted records extracted 
-- *			from latest RefUSA polygon, but missing key fields
-- *
-- * Exit DB and table results.
-- *	Terrxxx_RU.db - as main, new territory records from RefUSA polygon
-- *		Terrxxx_RUBridge - OwningParcel set in new records from
-- *		  SCBridge data where missing 
-- *
-- * Exit DB and table results.
-- *	Terrxxx_RU.db - as main, new territory records from RefUSA polygon
-- *		Terrxxx_RUBridge - Phone2 (Homestead), SitusAddress, DoNotCall,
-- *		  PropUse, RecordType set in new records where missing 
-- *
-- * Notes.;

-- * .open ~/Terrxxx_RU.db

--ATTACH '$pathbase'
-- ||		'/RawData/SCPA/SCPA-Downloads/Terrxxx/Terrxxx_SC.db'
--  AS db11;
--  PRAGMA db11.table_info(Terrxxx_SCBridge);
--ATTACH '$pathbase'
-- ||		'/RawData/RefUSA/RefUSA-Downloads/Terrxxx/Previous/Terrxxx_RU.db'
--  AS db12;
--  PRAGMA db12.table_info(Terrxxx_RUBridge);


-- * update all the homestead flags, and anything else relevant;
with a AS (SELECT OwningParcel AS Acct, 
UnitAddress AS StreetAddr, Unit AS DBUnit,
Phone2 AS Hstead, DoNotCall AS DNC, SitusAddress AS Situs, 
PropUse AS UseType, RecordType AS RecType
FROM db11.Terrxxx_SCBridge
)
UPDATE Terrxxx_RUBridge 
SET Phone2 = 
CASE 
WHEN OwningParcel IN (SELECT Acct from a) 
 THEN (SELECT Hstead FROM a
  WHERE Acct IS OwningParcel
 )
ELSE Phone2
END ,
 SitusAddress = 
CASE 
WHEN OwningParcel IN (SELECT Acct from a) 
 THEN (SELECT Situs FROM a
  WHERE Acct IS OwningParcel
 )
ELSE SitusAddress
END ,
 DoNotCall = 
CASE 
WHEN OwningParcel IN (SELECT Acct from a) 
 THEN (SELECT DNC FROM a
  WHERE Acct IS OwningParcel
 )
ELSE DoNotCall
END ,
 PropUse = 
CASE 
WHEN OwningParcel IN (SELECT Acct from a) 
 THEN (SELECT UseType FROM a
  WHERE Acct IS OwningParcel
 )
ELSE PropUse
END ,
 RecordType =
CASE 
WHEN OwningParcel IN (SELECT Acct from a) 
 THEN (SELECT RecType FROM a
  WHERE Acct IS OwningParcel
 )
ELSE RecordType
END 
WHERE Phone2 IS NULL OR LENGTH(PHone2) IS 0;

-- ** END UpdateDwnldRecs **********;


-- ** UpdateDNCs **********
-- *	4/28/21.	wmk.
-- *--------------------------
-- *
-- * UpdateDNCs - Update Do Not Calls.
-- *
-- * Entry DB and table dependencies.
-- *   <list main DB and ATTACHed DBs and tables>
-- *
-- * Exit DB and table results.
-- *
-- * Notes. This query ensures that there is an _RUBridge record
-- * for any DoNotCalls that are active for the territory, but not
-- * picked up by RefUSA in its download data.
-- *;

-- * DBs attached above;
WITH a AS (SELECT PropID,UnitAddress, Unit,
Name, Phone, "Foreign" as FL,
 RSO AS SCSO, RecDate FROM DoNotCalls 
 WHERE TerrID IS "xxx")
INSERT OR IGNORE INTO Terrxxx_RUBridge
SELECT PropID, UnitAddress, Unit,
 Name, Phone, "", "", "", "xxx", 1,
 SCSO, "Foreign", RecDate, UPPER(UnitAddress),
 "", "", "" FROM a
WHERE PropID NOT IN (SELECT OwningParcel
 FROM Terrxxx_RUBridge
 WHERE Unit IS a.Unit);

-- ** END UpdateDNCS **********;
 
.quit
-- ** end UpdateRUDwnld.sql

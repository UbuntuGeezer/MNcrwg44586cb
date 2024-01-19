-- GardensEdgeDrTidy.sql - Complete fields in RU-Special/GardensEdgeDr.db.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * 6/2/22.     wmk.   (automated) NVenAll > Terr86777.
-- 		4/18/22.	wmk.
-- *
-- * Entry.	../RefUSA-Downloads/Special/AvenidaEstancias.db is the special DB for all
-- *		 territories needing selected records from WindWood.
-- *			Spec_RUBridge is the Bridge records for use with territories
-- *
-- * Exit.	Spec_RUBridge has the following fields updated:
-- *			RecordDate is set to the date the RU data was downloaded
-- *			RecordType is set according to the PropUse field value			
-- *	
-- * Modification History.
-- * ---------------------
-- * 4/18/22.	wmk.	original code; cloned from FlamingoDrTidy.
-- * Legacy mods.
-- * 12/30/21.	wmk.	original code; cloned from BirdBayWay.
-- *
-- * Notes. RefUSA has several addresses as "500 Gardens Edge Dr" with no units.
-- * As it turns out, none of these can be matched. However addresses 511-514, 521-534,
-- * etc. match up with 500 Gardens Edge Dr Units 511..etc.

-- *;

-- ** subquery list.
-- *
-- * FixFromSCU - Fix RU records with units from SC records for territory 215.
-- * FixFromSC - Fix RU records from SC records for territory 215.
-- *;


-- * attach db's;
.open '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special/GardensEdgeDr.db'
ATTACH '$pathbase/DB-Dev/Terr86777.db'
 AS db2;
-- pragma table_info(SCPropUse);
-- * delete stray records; no addresses along capri isles in Eagle Point;

ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads'
  || '/Terr215/Terr215_SC.db'
  AS db11;
-- pragma table_info(Terr215_SCBridge);

ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads'
  || '/Terr215/Terr215_RU.db'
  AS db12;
-- pragma table_info(Terr215_RUBridge);


--DELETE FROM Spec_RUBridge
--WHERE UnitAddress LIKE '%%';

-- ** Fix5xxGardens *******
-- *	4/18/22.	wmk.
-- *-----------------------
-- *
-- * FixFromSCU - Fix Gardens Edge Dr 5xx RU addresses to match SC data.
-- *
-- * Entry DB and table dependencies.
-- *	GardensEdgeDr.db - as main, RU data for Inlet Cir
-- *		Spec_RUBridge - Bridge records for InletCir
-- *	Terr215_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr215_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 215
-- *
-- * Exit DB and table results.
-- *	InletCir.db - as main, RU data for Inlet Cir
-- *		Spec_RUBridge - Bridge records with units tidied up.
-- *
-- * Notes. e.g. 511 Gardens Edge Dr (RU) is 500 Gardens Edge Dr, Unit 511.
-- * Do this one first, if there are missing parcel IDs that have units.
-- *;

-- * DBs attached above;
-- * Terr215_SC.db - db11;
-- * GardensEdgeDr.db - main;

UPDATE Spec_RUBridge
set UNIT = substr(unitaddress,1,3),
UnitAddress = '500' || substr(unitaddress,4)
WHERE cast(substr(unitaddress,1,3) as integer) >= 511
  AND cast(substr(unitaddress,1,3) as integer) <= 534;

-- ** END Fix5xxGardens;

-- ** FixFromSCU **********
-- *	4/7/22.	wmk.
-- *-----------------------
-- *
-- * FixFromSCU - Fix RU records with units from SC records for territory 215.
-- *
-- * Entry DB and table dependencies.
-- *	GardensEdgeDr.db - as main, RU data for Inlet Cir
-- *		Spec_RUBridge - Bridge records for InletCir
-- *	Terr215_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr215_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 215
-- *
-- * Exit DB and table results.
-- *	InletCir.db - as main, RU data for Inlet Cir
-- *		Spec_RUBridge - Bridge records with units tidied up.
-- *
-- * Notes. Fix records not fixed above, with units.
-- * Do this one first, if there are missing parcel IDs that have units.
-- *;

-- * DBs attached above;
-- * Terr215_SC.db - db11;
-- * GardensEdgeDr.db - main;

WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Unit AS SCUnit,
Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM db11.Terr215_SCBridge)
UPDATE Spec_RUBridge
SET OwningParcel = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a
   WHERE SCUnit IS Unit)
 THEN (SELECT Acct FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS Unit)
ELSE OwningParcel
END,
SitusAddress = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a
   WHERE SCUnit IS Unit)
 THEN (SELECT Situs FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS Unit)
ELSE SitusAddress
END,
Phone2 =
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a
   WHERE SCUnit IS Unit)
 THEN (SELECT Hstead FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS Unit)
ELSE Phone2
END,
PropUse = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a
   WHERE SCUnit IS Unit)
 THEN (SELECT UseType FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS Unit)
ELSE PropUse
END,
DoNotCall = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a
    WHERE SCUnit IS Unit)
 THEN (SELECT DNC FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS Unit)
ELSE DoNotCall
END,
RSO = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a
   WHERE SCUnit IS Unit)
 THEN (SELECT SCSO FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS Unit)
ELSE RSO
END,
"Foreign" =
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a
   WHERE SCUnit IS Unit)
 THEN (SELECT FL FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS Unit)
ELSE "Foreign"
END,
RecordType = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a
   WHERE SCUnit IS Unit)
 THEN (SELECT RecType FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS Unit)
ELSE RecordType
END
WHERE Length(Unit) > 0; 

-- ** END FixFromSCU **********;


-- ** FixFromSC ************
-- *	4/7/22.	wmk.
-- *------------------------
-- *
-- * FixFromSC - Fix RU records from SC records for territory 215.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr215_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr215_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 215
-- *	Terr215_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr215_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr215_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr215_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr215_RUBridge - Bridge records fixed where..
-- *
-- * Modification History.
-- * ---------------------
-- * 5/19/21.	wmk.	original code; for Terr215 Fix215RU.sql.
-- * 12/31/21.	wmk.	OwningParcel - '-' constraint removed.
-- * Notes. Fix records not fixed above.
-- *;

-- * DBs attached above;
-- * InletCir.db - main;
-- * Terr215_SC.db - db11;

WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM db11.Terr215_SCBridge)
UPDATE Spec_RUBridge
SET OwningParcel = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE OwningParcel
END,
SitusAddress = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE SitusAddress
END,
Phone2 =
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT Hstead FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE Phone2
END,
PropUse = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE PropUse
END,
DoNotCall = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT DNC FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE DoNotCall
END,
RSO = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT SCSO FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE RSO
END,
"Foreign" =
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT FL FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE "Foreign"
END,
RecordType = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT RecType FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE RecordType
END
where length(Unit) = 0; 

-- ** END FixFromSC **********;

-- * set territory 215 in all records;
UPDATE Spec_RUBridge
SET CongTerrID = '215';

.quit
-- ****************************************************
-- ** FixGardensEdgeDr **********
-- *	4/7/22.	wmk.
-- *--------------------------
-- *
-- * FixGardensEdgeDr - Fix GardensEdge Dr UnitAddress,s for territory 215.
-- *
-- * Entry DB and table dependencies.
-- *	Terr215_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr215_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr215_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr215_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr215_RUBridge - Bridge records fixed to match postal and SC
-- *		 addresses.
-- *
-- * Modification History.
-- * ---------------------
-- * 4/7/22.	wmk.	original code.
-- *
-- * Notes. This query removes the 'W' prefix from the RefUSA records to match
-- * the SC and postal addresses with no direction prefix/suffix.
-- *;

-- * db,s attached above;
-- * GardensEdgeDr.db - main;

UPDATE Spec_RUBridge
SET UnitAddress =
CASE
WHEN SUBSTR(UnitAddress,7,1) IS 'W'
 THEN SUBSTR(UnitAddress,1,6) || TRIM(SUBSTR(UnitAddress,8))
WHEN SUBSTR(UnitAddress,LENGTH(UnitAddress)-1,2) IS ' W'
 THEN TRIM(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' W')))
ELSE UnitAddress
END
WHERE UnitAddress like '%flamingo%';
-- ** END FixGardensEdgeDr;



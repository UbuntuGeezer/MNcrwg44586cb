--Fix136RU.sql - Fix RU parcels in territory 136.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * 7/9/22.   wmk.   (automated) udpate FixFromSC (Terr136 template).
-- * 6/2/22.     wmk.   (automated) NVenAll > Terr86777.
--	2/13/22.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 1/29/21,	wmk.	original code.
-- * 4/21/21.	wmk.	all code removed (was a Bird Bay territory code).
-- * 6/12/21.	wmk.	(automated) ($)folderbase support.
-- * 1/13/22.	wmk.	(automated) ($)string repairs.
-- * 2/13/22.	wmk.	Cornwell on the Gulf fixes.
-- *
-- * Notes. whatever relevant for this RU download..
-- *;

-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * FixFlamingo - Fix Flamingo Rd parcels for territory 136.
-- * FixParkUnits - Fix Park Blvd parcels having units for territory 136.
-- * FixFromSC - Fix records from SC data.
-- *;

-- ** AttachDBs **********
-- *	4/21/21.	wmk.
-- *---------------------
-- *
-- * AttachDBs - Attach required databases.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db - as main, junk database so can use dbxx ATTACHes
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	AuxSCPAData - as db8, auxiliary data for SCPA records
-- *		SitusDups - table of ambiguous situs addresses with account #s
-- *		SitusConv - situs conversion table unitaddress <-> scpa situs
-- *		AddrXcpt - address exceptions
-- *	Terr136_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr136_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 136
-- *	Terr136_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr136_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr136_RUPoly)
-- *
-- * Exit DB and table results.
-- *
-- * Notes.
-- *;

-- * junk as main;
.open '$pathbase/DB-Dev/junk.db'

ATTACH '$pathbase'
||		'/DB-Dev/Terr86777.db' 
 AS db2;
--SELECT tbl_name FROM db2.sqlite_master 
-- WHERE type is "table";
--pragma db2.table_info(Terr86777);
 
ATTACH '$pathbase'
 ||		'/DB-Dev/AuxSCPAData.db'
  AS db8;
--SELECT tbl_name FROM db8.sqlite_master;
--pragma db8.table_info(AddrXcpt); 

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/Terr136/Terr136_SC.db'
  AS db11;
--  PRAGMA db11.table_info(Terr136_SCBridge);

ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terr136/Terr136_RU.db'
  AS db12;
--  PRAGMA db12.table_info(Terr136_RUBridge);

-- ** END AttachDBs **********;


-- ** FixFlamingo **********
-- *	4/21/21.	wmk.
-- *------------------------
-- *
-- * FixFlamingo - Fix Flamingo Rd parcels for territory 136.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr136_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr136_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr136_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr136_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr136_RUBridge - Bridge records fixed where..
-- *
-- * Notes. Flamingo Rd parcels have unit addresses to be matched in
-- * SC data.
-- *;

-- * DBs attached above;

-- * DBs attached above;

WITH a AS (SELECT OwningParcel AS Acct,
 UnitAddress  AS StreetAddr,
 TRIM(SUBSTR(Unit,1,4)) AS SCUnit,
 PropUse AS UseType,
 Phone2 AS Homestead,
 DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS ForLang,
 SitusAddress AS Situs, 
 RecordType AS RecType
 FROM Terr136_SCBridge
  WHERE LENGTH(SCUnit) > 0
  AND UnitAddress LIKE "620   FLAMINGO%"
)
UPDATE Terr136_RUBridge
SET OwningParcel = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a
  WHERE SCUnit IS trim(SUBSTR(Unit,1,4)) )
 THEN (SELECT Acct from a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
 )
ELSE OwningParcel
END,
 SitusAddress =
CASE 
WHEN  UPPER(TRIM(
SUBSTR(UnitAddress,1,LENGTH(UnitAddress)-2) ))
 IN (SELECT StreetAddr from a
  WHERE SCUnit IS trim(SUBSTR(Unit,1,4)) )
 THEN (SELECT Situs from a
  WHERE StreetAddr IS UPPER(TRIM(
  SUBSTR(UnitAddress,1,LENGTH(UnitAddress)-2) ))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
 ) 
ELSE SitusAddress
END,
 PropUse = 
CASE 
WHEN  UPPER(TRIM(
SUBSTR(UnitAddress,1,LENGTH(UnitAddress)-2) ))
 IN (SELECT StreetAddr from a
  WHERE SCUnit IS trim(SUBSTR(Unit,1,4)) )
 THEN (SELECT UseType from a
  WHERE StreetAddr IS UPPER(TRIM(
  SUBSTR(UnitAddress,1,LENGTH(UnitAddress)-2) ))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
 )  
ELSE PropUse
END,
 Phone2 = 
CASE 
WHEN   UPPER(TRIM(
SUBSTR(UnitAddress,1,LENGTH(UnitAddress)-2) ))
 IN (SELECT StreetAddr from a)
 THEN  (SELECT Homestead from a
  WHERE StreetAddr IS UPPER(TRIM(
  SUBSTR(UnitAddress,1,LENGTH(UnitAddress)-2) ))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
  )
ELSE Phone2 
END,
 DoNotCall = 
CASE 
WHEN   UPPER(TRIM(
SUBSTR(UnitAddress,1,LENGTH(UnitAddress)-2) ))
 IN (SELECT StreetAddr from a)
 THEN (SELECT DNC FROM a
  WHERE StreetAddr IS UPPER(TRIM(
  SUBSTR(UnitAddress,1,LENGTH(UnitAddress)-2) ))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
 )
END, 
 RSO =
CASE 
WHEN   UPPER(TRIM(
SUBSTR(UnitAddress,1,LENGTH(UnitAddress)-2) ))
 IN (SELECT StreetAddr from a)
 THEN (SELECT SCSO FROM a
  WHERE StreetAddr IS UPPER(TRIM(
  SUBSTR(UnitAddress,1,LENGTH(UnitAddress)-2) ))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
 )
ELSE RSO
END, 
 "Foreign" = 
CASE 
WHEN   UPPER(TRIM(
SUBSTR(UnitAddress,1,LENGTH(UnitAddress)-2) ))
 IN (SELECT StreetAddr from a)
 THEN (SELECT ForLang FROM a
  WHERE StreetAddr IS UPPER(TRIM(
  SUBSTR(UnitAddress,1,LENGTH(UnitAddress)-2) ))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
 )
ELSE "Foreign"
END,
 RecordType =
CASE 
WHEN  UPPER(TRIM(
SUBSTR(UnitAddress,1,LENGTH(UnitAddress)-2) ))
 IN (SELECT StreetAddr from a
  WHERE SCUnit IS trim(SUBSTR(Unit,1,4)) )
 THEN (SELECT RecType from a
  WHERE StreetAddr IS UPPER(TRIM(
  SUBSTR(UnitAddress,1,LENGTH(UnitAddress)-2) ))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
 )   
ELSE RecordType
END 
WHERE OwningParcel IS "-"
 AND UnitAddress LIKE "620   flamingo%"
 AND LENGTH(Unit) > 0;

-- ** END FixFlamingo **********;


-- ** FixParkUnits **********
-- *	4/21/21.	wmk.
-- *-------------------------
-- *
-- * FixParkUnits - Fix Park Blvd parcels having units for territory 136.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr136_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr136_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr136_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr136_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr136_RUBridge - Bridge records fixed where..
-- *
-- * Notes. Flamingo Rd parcels have unit addresses to be matched in
-- * SC data.
-- *;

-- * DBs attached above;

WITH a AS (SELECT OwningParcel AS Acct,
 UnitAddress  AS StreetAddr,
 TRIM(SUBSTR(Unit,1,4)) AS SCUnit,
 PropUse AS UseType,
 Phone2 AS Homestead,
 DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS ForLang,
 SitusAddress AS Situs, 
 RecordType AS RecType
 FROM Terr136_SCBridge
  WHERE LENGTH(SCUnit) > 0
  AND UnitAddress LIKE "%PARK BLVD%"
)
UPDATE Terr136_RUBridge
SET OwningParcel = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a
  WHERE SCUnit IS trim(SUBSTR(Unit,1,4)) )
 THEN (SELECT Acct from a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
 )
ELSE OwningParcel
END,
 SitusAddress =
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a
  WHERE SCUnit IS trim(SUBSTR(Unit,1,4)) )
 THEN (SELECT Situs from a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
 ) 
ELSE SitusAddress
END,
 PropUse = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a
  WHERE SCUnit IS trim(SUBSTR(Unit,1,4)) )
 THEN (SELECT UseType from a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
 )  
ELSE PropUse
END,
 Phone2 = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a
  WHERE SCUnit IS trim(SUBSTR(Unit,1,4)) )
 THEN  (SELECT Homestead from a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
  )
ELSE Phone2 
END,
 DoNotCall = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a
  WHERE SCUnit IS trim(SUBSTR(Unit,1,4)) )
 THEN (SELECT DNC FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
 )
END, 
 RSO =
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a
  WHERE SCUnit IS trim(SUBSTR(Unit,1,4)) )
 THEN (SELECT SCSO FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
 )
ELSE RSO
END, 
 "Foreign" = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a)
 THEN (SELECT ForLang FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
 )
ELSE "Foreign"
END,
 RecordType =
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a
  WHERE SCUnit IS trim(SUBSTR(Unit,1,4)) )
 THEN (SELECT RecType from a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS trim(SUBSTR(Unit,1,4))
 )   
ELSE RecordType
END 
WHERE OwningParcel IS "-"
 AND UnitAddress LIKE "%PARK BLVD%"
 AND LENGTH(Unit) > 0;

-- ** END FixParkUnits **********;


-- ** FixParkNoUnits **********
-- *	4/21/21.	wmk.
-- *---------------------------
-- *
-- * FixParkUnits - Fix Park Blvd parcels having units for territory 136.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr136_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr136_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr136_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr136_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr136_RUBridge - Bridge records fixed where..
-- *
-- * Notes. 440 Park Blvd S not getting picked up so this fixes it.
-- *;

-- * DBs attached above;

WITH a AS (SELECT OwningParcel AS Acct,
 UnitAddress  AS StreetAddr,
 TRIM(SUBSTR(Unit,1,4)) AS SCUnit,
 PropUse AS UseType,
 Phone2 AS Homestead,
 DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS ForLang,
 SitusAddress AS Situs, 
 RecordType AS RecType
 FROM Terr136_SCBridge
  WHERE UnitAddress LIKE "440   PARK BLVD%"
)
UPDATE Terr136_RUBridge
SET OwningParcel = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a)
 THEN (SELECT Acct from a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
 )
ELSE OwningParcel
END,
 SitusAddress =
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a)
 THEN (SELECT Situs from a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
 ) 
ELSE SitusAddress
END,
 PropUse = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a)
 THEN (SELECT UseType from a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
 )  
ELSE PropUse
END,
 Phone2 = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a)
 THEN  (SELECT Homestead from a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE Phone2 
END,
 DoNotCall = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a)
 THEN (SELECT DNC FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
 )
END, 
 RSO =
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a)
 THEN (SELECT SCSO FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
 )
ELSE RSO
END, 
 "Foreign" = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a)
 THEN (SELECT ForLang FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
 )
ELSE "Foreign"
END,
 RecordType =
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr from a)
 THEN (SELECT RecType from a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
 )   
ELSE RecordType
END 
WHERE OwningParcel IS "-"
 AND UnitAddress LIKE "440   PARK BLVD%";

-- ** END FixParkNoUnits **********;


--begin FixFromSC
-- ** FixFromSC **********
-- *	6/24/22.	wmk.
-- *----------------------
-- *
-- * FixFromSC - Fix RU records from SC records for territory 136.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr136_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr136_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 136
-- *	Terr136_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr136_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr136_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr136_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr136_RUBridge - Bridge records fixed where..
-- *
-- * Modification History.
-- * 5/19/21.	wmk.	original code.
-- * 6/22/22.	wmk.	total overhaul; fix day 1 bug where addresses with units
-- *			 all getting same parcel ID.
-- * 6/24/22.	wmk.	bug fix where no ELSEs when setting OwningParcel.
-- *
-- * Notes. Fix owning parcels then other fields.
-- *;

-- * DBs attached above;
-- * Terr136_SC.db db11;
-- * Terr136_RU.db db12;

-- * first fix OwningParcels where there are units;
WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Unit AS SCUnit,
Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM db11.Terr136_SCBridge)
UPDATE Terr136_RUBridge
SET OwningParcel = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
    IN (SELECT StreetAddr FROM a
	 WHERE SCUnit IS Unit
	)
    THEN (SELECT Acct FROM a 
    WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
      AND SCUnit IS UNIT
	)
ELSE OwningParcel
END
WHERE "OwningParcel" is "-"
  AND LENGTH(Unit) > 0;

-- * then fix OwningParcels with no units;
WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM db11.Terr136_SCBridge)
UPDATE Terr136_RUBridge
SET OwningParcel = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
    IN (SELECT StreetAddr FROM a)
   THEN (SELECT Acct FROM a 
    WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE OwningParcel
END
WHERE "OwningParcel" is "-"
  AND LENGTH(Unit) = 0;

-- * now set remaining fields from SC data;
-- *  SitsusAddress, Phone2, DoNotCall, RSO, Foreign;
-- *  RecordType;
WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM db11.Terr136_SCBridge)
UPDATE Terr136_RUBridge
SET SitusAddress = 
CASE 
WHEN OwningParcel
 IN (SELECT Acct FROM a)
 THEN (SELECT Situs FROM a 
  WHERE Acct IS OwningParcel
  )
ELSE SitusAddress
END,
Phone2 =
CASE 
WHEN OwningParcel
 IN (SELECT Acct FROM a)
 THEN (SELECT Hstead FROM a 
  WHERE Acct IS OwningParcel
  )
ELSE Phone2
END,
PropUse = 
CASE 
WHEN OwningParcel
 IN (SELECT Acct FROM a)
 THEN (SELECT UseType FROM a 
  WHERE Acct IS OwningParcel
  )
ELSE PropUse
END,
DoNotCall = 
CASE 
WHEN OwningParcel
 IN (SELECT Acct FROM a)
 THEN (SELECT DNC FROM a 
  WHERE Acct IS OwningParcel
  )
ELSE DoNotCall
END,
RSO = 
CASE 
WHEN OwningParcel
 IN (SELECT Acct FROM a)
 THEN (SELECT SCSO FROM a 
  WHERE Acct IS OwningParcel
  )
ELSE RSO
END,
"Foreign" =
CASE 
WHEN OwningParcel
 IN (SELECT Acct FROM a)
 THEN (SELECT FL FROM a 
  WHERE Acct IS OwningParcel
  )
ELSE "Foreign"
END,
RecordType = 
CASE 
WHEN OwningParcel
 IN (SELECT Acct FROM a)
 THEN (SELECT RecType FROM a 
  WHERE Acct IS OwningParcel
  )
ELSE RecordType
END; 
-- ** END FixFromSC **********;
--/**/

-- ** END FixFromSC **********;
--/**/

.quit
-- *** END Fix136RU ***********;

-- ********** Legacy code ***********************
-- ** FixSCFlamingo **********
-- *	mm/dd/yy.	wmk.
-- *--------------------------
-- *
-- * subquery_name - simple description.
-- *
-- * Entry DB and table dependencies.
-- *   <list main DB and ATTACHed DBs and tables>
-- *
-- * Exit DB and table results.
-- *
-- * Notes.;

SELECT * FROM NVENALL 
WHERE "SITUS ADDRESS (PROPERTY ADDRESS)"
LIKE "620$FLAMINGO DR%"
ORDER BY "SITUS ADDRESS (PROPERTY ADDRESS)";

WITH a AS (SELECT "ACCOUNT #" AS Acct,
SUBSTR("SITUS ADDRESS (PROPERTY ADDRESS)",1,3) 
 || " " || TRIM(SUBSTR("SITUS ADDRESS (PROPERTY ADDRESS)",
				5,31)) || " W" AS StreetAddr,
 SUBSTR("SITUS ADDRESS (PROPERTY ADDRESS)",36) AS SCUnit
 FROM NVENALL 
 WHERE "SITUS ADDRESS (PROPERTY ADDRESS)"
  LIKE "620$FLAMINGO DR%"
 )
UPDATE Terr136_SCBridge
SET OwningParcel = 
CASE 
WHEN UnitAddress IN (SELECT StreetAddr from a
 WHERE SCUnit is Unit) 
 THEN (SELECT Acct FROM a 
  WHERE StreetAddr IS UnitAddress 
   AND SCUnit IS Unit
 )
ELSE OwningParcel
END  
WHERE UnitAddress LIKE "620   FLAMINGO%";

-- ** END FixSCFlamingo **********;



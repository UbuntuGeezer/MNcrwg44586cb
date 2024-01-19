--Fix118RU.sql - Fix RU records territory 118.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * 7/9/22.   wmk.   (automated) udpate FixFromSC (Terr124 template).
-- * 6/2/22.     wmk.   (automated) NVenAll > Terr86777.
-- * 1/13/22.	wmk.	(automated) ($)string repairs.
-- *  6/12/21.	wmk.	(automated) ($)folderbase support.
--	3/31/21.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 3/31/21.	wmk.	original code.
-- * 5/19/21.	wmk.	updated for consistency.
-- *
-- * Notes. whatever relevant for this RU download..
-- *;

-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * Fix118RU - Fix RU records territory 118.
-- *;

--FixX118RU.sql - Fix RU parcels in territory 118.
--	5/19/21.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 3/31/21.	wmk.	original code.
-- * 5/19/21.	wmk.	updated for consistency.
-- *
-- * Notes. whatever relevant for this RU download..
-- *;

-- * subquery list.
-- * --------------
-- * FixFromSC - Fix RU records from SC records for territory 118.
-- * DelStrays - Delete stray records from RU download.
-- * FixWhatever - Fix whatever for territory 118.
-- *;

-- ** AttachDBs **********
-- *	5/19/21.	wmk.
-- *---------------------
-- *
-- * AttachDBs - Attach required databases.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db - as main, junk database so can use dbxx ATTACHes
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	TerrIDData.db - as db4, territory and subterritories (all) defs
-- *		Territory - territory id definitions
-- *		SubTerrs - subterritory definitions
-- *		DoNotCalls - DoNotCall addresses by territory
-- *	AuxSCPAData - as db8, auxiliary data for SCPA records
-- *		SitusDups - table of ambiguous situs addresses with account #s
-- *		SitusConv - situs conversion table unitaddress <-> scpa situs
-- *		AddrXcpt - address exceptions
-- *	Terr118_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr118_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 118
-- *	Terr118_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr118_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr118_RUPoly)
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
 ||		'/DB-Dev/TerrIDData.db'
 AS db4;
--SELECT tbl_name FROM db4.sqlite_master 
-- WHERE type is "table";
--pragma db4.table_info(DoNotCalls);

ATTACH '$pathbase'
 ||		'/DB-Dev/AuxSCPAData.db'
  AS db8;
--SELECT tbl_name FROM db8.sqlite_master;
--pragma db8.table_info(AddrXcpt); 

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/Terr118/Terr118_SC.db'
  AS db11;
--  PRAGMA db11.table_info(Terr118_SCBridge);

ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terr118/Terr118_RU.db'
  AS db12;
--  PRAGMA db12.table_info(Terr118_RUBridge);

-- ** END AttachDBs **********;



-- ** FixWhatever **********
-- *	<date>.	wmk.
-- *--------------------------
-- *
-- * FixWhatever - Fix whatever for territory 122.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terrxxx_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terrxxx_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terrxxx_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terrxxx_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terrxxx_RUBridge - Bridge records fixed where..
-- *
-- * Notes. Whatever
-- *;

-- * DBs attached above;

-- * Fix 229 Fiesole St;
UPDATE Terr118_RUBridge 
SET OwningParcel = "0429130018",
 Phone2 = "",
 SitusAddress = "NOT RECORDED",
 PropUse = "0100",
 RecordType = "P"
where UnitAddress LIKE "229   Fiesole St%";

-- ** END FixWhatever **********;


--begin SPLIT
--begin FixFromSC
-- ** FixFromSC **********
-- *	5/19/21.	wmk.
-- *----------------------
-- *
-- * FixFromSC - Fix RU records from SC records for territory 118.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr118_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr118_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 118
-- *	Terr118_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr118_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr118_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr118_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr118_RUBridge - Bridge records fixed where..
-- *
-- * Notes. Fix records not fixed above.
-- *;

-- * DBs attached above;

WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM Terr118_SCBridge)
UPDATE Terr118_RUBridge
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
WHERE OwningParcel is "-"; 

-- ** END FixFromSC **********;
--/**/

.quit

-- * Attach required databases;

-- * junk as main;
.open '$pathbase/DB-Dev/junk.db'

ATTACH '$pathbase'
||		'/DB-Dev/Terr86777.db' 
 AS db2;
--SELECT tbl_name FROM db2.sqlite_master 
-- WHERE type is "table";
--pragma db2.table_info(Terr86777);
 
ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terr118/Terr118_RU.db'
  AS db12;
--  PRAGMA db12.table_info(Terr118_RUBridge);


-- ** Fix118RU **********
-- *	3/31/21.	wmk.
-- *--------------------------
-- *
-- * Fix118RU - Fix RU records territory 118.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db - as main, junk database so can use dbxx ATTACHes
-- *	Terr118_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr118_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr118_RUPoly)
-- *
-- * Exit DB and table results.
-- *	Terr118_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr118_RUBridge - Record created for 229 Fiesole St
-- *
-- * Notes. The property at 229 Fiesole St is on the aerial map, but has
-- * no parcel ID nor property record in the county records. This query
-- * forces the parcel ID between the two adjacent parcels and fills in
-- * what appear to be appropriate values for the record fields.
-- *;

-- * DBs attached above;

-- ** Fix700Nokomis **********
-- *	3/31/21.	wmk.
-- *--------------------------
-- *
-- * Fix700Nokomis - Fix record(s) for 700 Nokomis Ave S
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *
-- * Exit DB and table results.
-- *
-- * Notes. Nokomis Ave addresses do not have "S" suffix in county data.
-- *;

-- * DBs attached above;

WITH a AS(select * from Terr86777 
where "situs address (property address)"
like "700   NOKOMIS%")
UPDATE Terr118_RUBridge 
SET OWNINGPARCEL =
case
when UPPER(TRIM(SUBSTR(UnitAddress,1,
 LENGTH(UNITADDRESS)-1 )))
   IN (SELECT TRIM(SUBSTR("situs address (property address)",
			1,35))
   FROM a)
 then (SELECT "account #" FROM a
 WHERE TRIM(SUBSTR("situs address (property address)",1,35))
    IS UPPER(TRIM(SUBSTR(UnitAddress,
        1,LENGTH(UnitAddress)-1)))
 )
else OwningParcel 
end 
WHERE UnitAddress LIKE "700   Nokomis%"
 AND OwningParcel IS "-";

-- ** END FixNokomis **********;

.quit
-- ** END Fix118RU **********;


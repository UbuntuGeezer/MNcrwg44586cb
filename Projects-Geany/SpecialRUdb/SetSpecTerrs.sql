-- * SetSpecTerrs.sql - Set SpecTerrxxx_RU.db territory IDs and info.
-- *	5/23/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
-- *			 *congterr*, *conglib* env vars introduced.
-- * 5/23/23.	wmk.	VeniceNTerritory, NVenAll > Terr86777.
-- * Legacy mods.
-- * 8/15/21.	wmk.	original code;
-- * 8/16/21.	wmk.	code enhancements.
-- * 8/17/21.	wmk.	terr 201 replaced with xx x; db30 documentation
-- *					updated.
-- * 8/18/21.	wmk.	terr274 code appended to end for use as model
-- *					code for other territories; code correction
-- *					in TerrList references.
-- * 8/20/21.	wmk.	bug fix extraneous ',' in CASE statement; bad
-- *					reference to AvenidaEstancias for Spec_RUBridge;
-- *					bug fix when setting CongTerrID where units cleared.
-- * 10/12/21.	wmk.	fix matching to use upper(trim(UnitAddress)); eliminate
-- *					duplicated code setting territory ID twice in db30.
-- * 10/18/21.	wmk.	fix matching again to use upper(trim(UnitAddress)).
-- * 10/25/21.	wmk.	edited for territory xx x.
-- * 10/28/21.	wmk.	edited for territory 647. 
-- *
-- * Notes. WARNING: Watch out for unit matching code and eliminate if no units.
--*	AvensCohosh.db -  Windwood RU download
--*	Bellagio.db - Bellagio RU download
--* BerkshirePlace.db - Berkshire Place RU download
--* BrennerPark.db - Brenner Park RU download
--* BridleOaks.db - Bridle Oaks RU download
--* EaglePoint.db - Eagle Point RU download
--* HiddenLakes.db - Hidden Lakes RU download
--* ReclinataCir.db - Reclinata Circle RU download
--* SawgrassN.db - Sawgrass north section RU download
--* SawgrassS.db - Sawgrass south section RU download
--* TheEsplanade.db - The Esplanade RU download
--*	TrianoCir.db - TrianoCir RU download
--* WaterfordNE.db - WaterfordNE RU download
--*	WaterfordNW.db - WaterfordNW RU download
-- *;

--
-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * FiXxxxRU - Fix RU records territory xxx.
-- *;


-- ** AttachDBs **********
-- *	8/16/21.	wmk.
-- *----------------------
-- *
-- * AttachDBs - Attach required databases.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db - as main, junk database so can use dbxx ATTACHes
-- * 19	Specxxx_RU.db - as db19, special download records for terr xxx
-- *		Spec_RUBridge - Bridge formatted records extracted from
-- *		  Specxxx_RU database
-- * 29	Special.db - as db29, special download records
-- *		Spec_RURaw - unsorted raw download data from street
-- *		Spec_RUPoly - sorted download data from street
-- *		Spec_RUBridge - Bridge formatted records extracted from
-- *		  Terr86777 table
-- *		TerrList - list of territories and record counts 
-- *		PropTerr - [legacy] table of property ID, streetaddress, terrid
-- *
-- * Exit DB and table results.
-- *
-- * Modification History.
-- * ---------------------
-- * 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
-- *			 *congterr*, *conglib* env vars introduced.
-- * Legacy mods.
-- * 8/15/21.	wmk.	original code.
-- * 8/16/21.	wmk.	added query code to set PropUse and OwningParcels.
-- * Notes.
-- *;

-- * junk as main;
.open '$pathbase/DB-Dev/junk.db'

ATTACH '$pathbase/DB-Dev/Terr86777.db'
 AS db2;
--  PRAGMA db2.table_info(Terr86777)

ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terrxxx/Specxxx_RU.db'
  AS db19;
--  PRAGMA db19.table_info(Terrxxx_RUBridge);

-- ** END AttachDBs **********;

-- ** FixSpecRU **********
-- *	10/28/21.	wmk.
-- *----------------------
-- *
-- * FixSpecRU - Fix Specxxx_RU records territory xxx.
-- *
-- * Entry DB and table dependencies.
-- * 19	Specxxx_RU.db - as db19, special download records for terr xxx
-- *		Spec_RUBridge - Bridge formatted records extracted from
-- *		  Specxxx_RU database
-- * 29	Special.db - as db29, special download records
-- *		Special - table of special download record
-- *		PropTerr - [legacy] table of property ID, streetaddress, terrid
-- *		Spec_RUBridge - Bridge formatted records extracted from
-- *		  Terr86777 table
-- *		TerrList - list of territories and record counts 
-- *
-- * Exit DB and table results.
-- * 19	Specxxx_RU.db - as db19, special download records for terr xxx
-- *		Spec_RUBridge - Bridge records updated with terr xxx
-- * 29	Special.db - as db29, special download records
-- *		Special - table of special download records; CongTerrID updated
-- *		PropTerr - [legacy] table of property ID, streetaddress, terrid
-- *			NOT UPDATED with terrxxx
-- *		Spec_RUBridge - Bridge records updated with terr xxx
-- *		  Terr86777 table
-- *		TerrList - record counts updated for terr xxx
-- *
-- * Modification History.
-- * ---------------------
-- * 8/15/21.	wmk.	original code.
-- * 10/28/21.	wmk.	TheEsplanade added.
-- *
-- * Notes.
--*	AvensCohosh.db -  Windwood RU download
--*	Bellagio.db - Bellagio RU download
--* BerkshirePlace.db - Berkshire Place RU download
--* BrennerPark.db - Brenner Park RU download
--* BridleOaks.db - Bridle Oaks RU download
--* EaglePoint.db - Eagle Point RU download
--* HiddenLakes.db - Hidden Lakes RU download
--* ReclinataCir.db - Reclinata Circle RU download
--* SawgrassN.db - Sawgrass north section RU download
--* SawgrassS.db - Sawgrass south section RU download
--* TheEsplande.db - The Esplanade RU download
--*	TrianoCir.db - TrianoCir RU download
--* WaterfordNE.db - WaterfordNE RU download
--*	WaterfordNW.db - WaterfordNW RU download
-- *;

-- * DBs attached above;

-- ** perform territory-dependent fixes on new records **;

-- * Terrxxx_RU.db/Terrxxx_RUBridge;
ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/Terrxxx/Terrxxx_SC.db'
  AS db11;
ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terrxxx/Terrxxx_RU.db'
  AS db12;
WITH a AS (SELECT "Account #", "situs address (property address)",
	"Property Use Code" FROM Terr86777
	WHERE "Account #" IN (SELECT OwningParcel FROM Terrxxx_SCBridge))
UPDATE Terrxxx_RUBridge 
SET SitusAddress =
 (SELECT "situs address (property address)" FROM a
   WHERE "Account #" IS OwningParcel),
PropUse = 
 (SELECT "Property Use Code" FROM a
   WHERE "Account #" IS OwningParcel)
WHERE OwningParcel IS NOT "-";

-- ** END SetSitusPropUse **********;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db19.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all these records;
UPDATE db19.Spec_RUBridge
SET 
CongTerrID = 'xxx'
;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db19.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- ****** end Terrxxx block *****;

-- repeat below block for each special db;
--*	AvensCohosh.db -  Windwood RU download
--*	Bellagio.db - Bellagio RU download
--* BerkshirePlace.db - Berkshire Place RU download
--* BrennerPark.db - Brenner Park RU download
--* BridleOaks.db - Bridle Oaks RU download
--* EaglePoint.db - Eagle Point RU download
--* HiddenLakes.db - Hidden Lakes RU download
--* ReclinataCir.db - Reclinata Circle RU download
--* SawgrassN.db - Sawgrass north section RU download
--* SawgrassS.db - Sawgrass south section RU download
--* TheEsplanade.db - The Esplanade RU download
--*	TrianoCir.db - TrianoCir RU download
--* WaterfordNE.db - WaterfordNE RU download
--*	WaterfordNW.db - WaterfordNW RU download
-- *;
--*************** AvensCohosh;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/AvensCohosh.db'
 AS db29;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, SitusAddress AS Situs,
 PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db29.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS =
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE SITUSADDRESS
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all Special/Special records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db19.Spec_RUBridge
			WHERE OwningParcel IS NOT '-')
UPDATE db29.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db29.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- * update Terr xxx counts field in Special.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db29.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db29.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db29;

--***** end AvensCohosh block *****;

--*	Bellagio.db - Bellagio RU download
-- *;
--*************** Bellagio;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/Bellagio.db'
 AS db29;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, SitusAddress AS Situs,
 PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db29.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS =
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE SITUSADDRESS
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all Special/Special records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db19.Spec_RUBridge
			WHERE OwningParcel IS NOT '-')
UPDATE db29.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db29.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- * update Terr xxx counts field in Special.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db29.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db29.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db29;

--***** end Bellagio block *****;

--*;
--* BerkshirePlace.db - Berkshire Place RU download
-- *;
--*************** BerkshirePlace;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/BerkshirePlace.db'
 AS db29;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, SitusAddress AS Situs,
 PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db29.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS =
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE SITUSADDRESS
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all Special/Special records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db19.Spec_RUBridge
			WHERE OwningParcel IS NOT '-')
UPDATE db29.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db29.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- * update Terr xxx counts field in Special.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db29.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db29.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db29;

--***** end BerkshirePlace block *****;

--*;
--* BrennerPark.db - Brenner Park RU download
-- *;
--*************** BrennerPark;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/BrennerPark.db'
 AS db29;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, SitusAddress AS Situs,
 PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db29.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS =
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE SITUSADDRESS
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all Special/Special records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db19.Spec_RUBridge
			WHERE OwningParcel IS NOT '-')
UPDATE db29.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db29.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- * update Terr xxx counts field in Special.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db29.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db29.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db29;

--***** end BrennerPark block *****;

--*;
--* BridleOaks.db - Bridle Oaks RU download
-- *;
--*************** BridleOaks;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/BridleOaks.db'
 AS db29;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, SitusAddress AS Situs,
 PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db29.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS =
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE SITUSADDRESS
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all Special/Special records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db19.Spec_RUBridge
			WHERE OwningParcel IS NOT '-')
UPDATE db29.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db29.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- * update Terr xxx counts field in Special.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db29.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db29.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db29;

--***** end BridleOaks block *****;

--*;
--* EaglePoint.db - Eagle Point RU download
-- *;
--*************** EaglePoint;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/EaglePoint.db'
 AS db29;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, SitusAddress AS Situs,
 PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db29.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS =
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE SITUSADDRESS
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all Special/Special records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db19.Spec_RUBridge
			WHERE OwningParcel IS NOT '-')
UPDATE db29.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db29.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- * update Terr xxx counts field in Special.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db29.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db29.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db29;

--***** end EaglePoint block *****;

--*;
--* HiddenLakes.db - Hidden Lakes RU download
-- *;
--*************** HiddenLakes;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/HiddenLakes.db'
 AS db29;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, SitusAddress AS Situs,
 PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db29.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS =
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE SITUSADDRESS
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all Special/Special records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db19.Spec_RUBridge
			WHERE OwningParcel IS NOT '-')
UPDATE db29.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db29.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- * update Terr xxx counts field in Special.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db29.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db29.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db29;

--***** end HiddenLakes block *****;

--*;
--* ReclinataCir.db - Reclinata Circle RU download
-- *;
--*************** ReclinataCir;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/ReclinataCir.db'
 AS db29;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, SitusAddress AS Situs,
 PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db29.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS =
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE SITUSADDRESS
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all Special/Special records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db19.Spec_RUBridge
			WHERE OwningParcel IS NOT '-')
UPDATE db29.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db29.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- * update Terr xxx counts field in Special.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db29.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db29.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db29;

--***** end ReclinatsCir block *****;

--*;
--* SawgrassN.db - Sawgrass north section RU download
-- *;
--*************** SawgrassN;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/SawgrassN.db'
 AS db29;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, SitusAddress AS Situs,
 PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db29.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS =
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE SITUSADDRESS
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all Special/Special records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db19.Spec_RUBridge
			WHERE OwningParcel IS NOT '-')
UPDATE db29.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db29.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- * update Terr xxx counts field in Special.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db29.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db29.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db29;

--***** end SawgrassN block *****;

--* SawgrassS.db - Sawgrass south section RU download
-- *;
--*************** SawgrassS;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/SawgrassS.db'
 AS db29;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, SitusAddress AS Situs,
 PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db29.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS =
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE SITUSADDRESS
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all Special/Special records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db19.Spec_RUBridge
			WHERE OwningParcel IS NOT '-')
UPDATE db29.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db29.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- * update Terr xxx counts field in Special.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db29.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db29.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db29;

--***** end SawgrassS block *****;

--*	TrianoCir.db - TheEsplanade RU download
-- *;
--*************** TheEsplanade;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/TheEsplanade.db'
 AS db29;

-- * set OwningParcels and PropUses for TheEsplanade;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, SitusAddress AS Situs,
 PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db29.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS =
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE SITUSADDRESS
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all Special/TheEsplanade records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db19.Spec_RUBridge
			WHERE OwningParcel IS NOT '-')
UPDATE db29.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db29.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- * update Terr xxx counts field in TheEsplanade.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db29.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db29.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db29;

--***** end TheEsplanade block *****;

--*	TrianoCir.db - TrianoCir RU download
-- *;
--*************** TrianoCir;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/TrianoCir.db'
 AS db29;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, SitusAddress AS Situs,
 PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db29.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS =
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE SITUSADDRESS
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all Special/Special records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db19.Spec_RUBridge
			WHERE OwningParcel IS NOT '-')
UPDATE db29.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db29.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- * update Terr xxx counts field in Special.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db29.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db29.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db29;

--***** end TrianoCir block *****;

--* WaterfordNE.db - WaterfordNE RU download
-- *;
--*************** WaterfordNE;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/WaterfordNE.db'
 AS db29;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, SitusAddress AS Situs,
 PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db29.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS =
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE SITUSADDRESS
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all Special/Special records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db19.Spec_RUBridge
			WHERE OwningParcel IS NOT '-')
UPDATE db29.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db29.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- * update Terr xxx counts field in Special.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db29.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db29.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db29;

--***** end WaterfordNE block *****;

--*	WaterfordNW.db - WaterfordNW RU download
-- *;
--*************** WaterfordNW;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
 || '/WaterfordNW.db'
 AS db29;

-- * set OwningParcels and PropUses for <special-street>;
with a AS (SELECT OWNINGPARCEL AS Acct, upper(trim(UNITADDRESS)) AS StreetAddr,
 Unit AS SUnit, SitusAddress AS Situs,
 PROPUSE AS UseType
 FROM Terrxxx_SCBridge)
UPDATE db29.Spec_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS =
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE SITUSADDRESS
END,
PROPUSE = 
CASE
WHEN upper(trim(UNITADDRESS)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UNITADDRESS)) )
ELSE PROPUSE
END
;

-- * set territory xxx in all Special/Special records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db19.Spec_RUBridge
			WHERE OwningParcel IS NOT '-')
UPDATE db29.Spec_RUBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;

-- set record type;
WITH a AS (SELECT Code, RType
 FROM SCPropUse
)
UPDATE db29.Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a 
  WHERE Code is PropUse
 )
ELSE RecordType
END 
WHERE RecordType ISNULL OR LENGTH(RecordType) = 0;
--* fix record types;

-- end SetRecordType;
-- * update Terr xxx counts field in Special.TerrList;
WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList
 SELECT CongTerrID, 0 FROM a;
DELETE FROM db29.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db29.TerrList GROUP BY TerrID);
WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT CongTerrID FROM a)
 THEN (SELECT COUNT() CongTerrID FROM a 
   WHERE CongTerrID IS TerrID)
ELSE Counts
END;
DETACH db29;

--***** end WaterfordNW block *****;

-- ** END FixxxxRU **********;

.quit
-- ** END SetSpecTerrs **********;

--* Special620.dblist.txt;
--*		10/25/21.
--*
--* Modification History.
--* 10/21/21.	original listing.
--* 10/25/21.	modified to include WITH/INSERT query for all databases.
--*
--*	AvensCohosh.db -  Windwood RU download
--*	Bellagio.db - Bellagio RU download
--* BerkshirePlace.db - Berkshire Place RU download
--* BrennerPark.db - Brenner Park RU download
--* BridleOaks.db - Bridle Oaks RU download
--* EaglePoint.db - Eagle Point RU download
--* HiddenLakes.db - Hidden Lakes RU download
--* ReclinataCir.db - Reclinata Circle RU download
--* SawgrassN.db - Sawgrass north section RU download
--* SawgrassS.db - Sawgrass south section RU download
--*	TrianoCir.db - TrianoCir RU download
--* WaterfordNE.db - WaterfordNE RU download
--*	WaterfordNW.db - WaterfordNW RU download
--*;
--* AvensCohosh;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/AvensCohosh.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* Bellagio;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/Bellagio.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* BerkshirePlace.db - Berkshire Place RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/BerkshirePlace.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* BrennerPark.db - Brenner Park RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/BrennerPark.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* BridleOaks.db - Bridle Oaks RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/BridleOaks.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* EaglePoint.db - Eagle Point RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/EaglePoint.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* HiddenLakes.db - Hidden Lakes RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/HiddenLakes.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* ReclinataCir.db - Reclinata Circle RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/ReclinataCir.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* SawgrassN.db - Sawgrass north section RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/SawgrassN.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* SawgrassS.db - Sawgrass south section RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/SawgrassS.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* TrianoCir;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/TrianoCir.db'
   AS db29;
--*;
--* WaterfordNE.db - WaterfordNE RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/WaterfordNE.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--*	WaterfordNW.db - WaterfordNW RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/WaterfordNW.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* Special620.dblist.txt;
--*		10/25/21.
--*
--* Modification History.
--* 10/21/21.	original listing.
--* 10/25/21.	modified to include WITH/INSERT query for all databases.
--*
--*	AvensCohosh.db -  Windwood RU download
--*	Bellagio.db - Bellagio RU download
--* BerkshirePlace.db - Berkshire Place RU download
--* BrennerPark.db - Brenner Park RU download
--* BridleOaks.db - Bridle Oaks RU download
--* EaglePoint.db - Eagle Point RU download
--* HiddenLakes.db - Hidden Lakes RU download
--* ReclinataCir.db - Reclinata Circle RU download
--* SawgrassN.db - Sawgrass north section RU download
--* SawgrassS.db - Sawgrass south section RU download
--*	TrianoCir.db - TrianoCir RU download
--* WaterfordNE.db - WaterfordNE RU download
--*	WaterfordNW.db - WaterfordNW RU download
--*;
--* AvensCohosh;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/AvensCohosh.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* Bellagio;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/Bellagio.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* BerkshirePlace.db - Berkshire Place RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/BerkshirePlace.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* BrennerPark.db - Brenner Park RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/BrennerPark.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* BridleOaks.db - Bridle Oaks RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/BridleOaks.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* EaglePoint.db - Eagle Point RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/EaglePoint.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* HiddenLakes.db - Hidden Lakes RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/HiddenLakes.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* ReclinataCir.db - Reclinata Circle RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/ReclinataCir.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* SawgrassN.db - Sawgrass north section RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/SawgrassN.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* SawgrassS.db - Sawgrass south section RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/SawgrassS.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--* TrianoCir;
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/TrianoCir.db'
   AS db29;
--*;
--* WaterfordNE.db - WaterfordNE RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/WaterfordNE.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
--*	WaterfordNW.db - WaterfordNW RU download
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/WaterfordNW.db'
   AS db29;
WITH a AS (SELECT OwningParcel AS Acct
 FROM db11.Terr620_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;
--*;
.quit
--** END SetSpecTerrs.sql **********;

-- SetSpecTerrs.sql - Set SpecTerrxxx_SC.db territory IDs and info.
--	5/30/22.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 5/30/22.	wmk.	*pathbase* support.
-- * Legacy mods.
-- * 8/15/21.	wmk.	original code;
-- * 8/21/21.	wmk.	eliminate unit clearing code; correct db18 to db30
-- *					where appropriate; add ATTACH for db30 in AttachDBs.
-- * 8/30/21.	wmk.	CASE statements setting terr IDs corrected.
-- * 9/5/21.	wmk.	PropUse 0350 corrected in Set PropUse code.	
-- * 9/16/21.	wmk.	edited for territory 302; mod to use SCPropUse table
-- *					in VeniceNTerritories.db to set record types.
-- * 11/2/21.	wmk.	bug fixes RecType changed to RType line 126; lines
-- *					134-136 commented since db attached above.
-- * 11/28/21.	wmk.	bug fix where Account # field name corrected to Account
-- *					in <special-db> table reference.
-- *
-- * Notes. whatever relevant for this SC download..
-- *;

-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * FiXxxxSC - Fix SC records territory $P1.
-- *;


-- ** AttachDBs *********
-- *	5/30/22.	wmk.
-- *---------------------
-- *
-- * AttachDBs - Attach required databases.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db - as main, junk database so can use dbxx ATTACHes
-- * 18	Spec289_SC.db - as db18, special download records for terr $P1
-- *		Spec_SCBridge - Bridge formatted records extracted from
-- *		  Spec$P1_SC database
-- * 30	Spec289_SC.db - as db18, special download records
-- *		<special-db> - table of special download record
-- *		PropTerr - [legacy] table of property ID, streetaddress, terrid
-- *		Spec_SCBridge - Bridge formatted records extracted from
-- *		  Terr86777 table
-- *		TerrList - list of territories and record counts 
-- *
-- * Exit DB and table results.
-- *
-- * Modification History.
-- * ---------------------
-- * 5/30/22.	wmk.	*pathbase* support.
-- * Legacy mods.
-- * 8/15/21.	wmk.	original code.
-- * 9/16/21.	wmk.	added VeniceNTerritory.db to attached files for setting
-- *					RecordType fields.
-- * Notes.
-- *;

-- * junk as main;
.open '$pathbase/DB-Dev/junk.db'

ATTACH '$pathbase/DB-Dev'
  || '/Terr86777.db'
  as db2;
-- pragma db2.table_info(SCPropUse);

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/Terrxxx/Specxxx_SC.db'
  AS db18;
--  PRAGMA db18.table_info(Terrxxx_SCBridge);

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/Special/<special-db>.db'
  AS db30;
--  PRAGMA db30.table_info(Special_SCBridge);

-- ** END AttachDBs **********;

-- ** FixSpecSC **********
-- *	8/15/21.	wmk.
-- *---------------------
-- *
-- * FixSpecSC - Fix Spexxx_SC records territory xxx.
-- *
-- * Entry DB and table dependencies.
-- * 18	Specxxx_SC.db - as db18, special download records for terr $P1
-- *		Spec_SCBridge - Bridge formatted records extracted from
-- *		  Spec$P1_SC database
-- * 30	<special-db>.db - as db30, special download records
-- *		<special-db> - table of special download record
-- *		PropTerr - [legacy] table of property ID, streetaddress, terrid
-- *		Spec_SCBridge - Bridge formatted records extracted from
-- *		  Terr86777 table
-- *		TerrList - list of territories and record counts 
-- *
-- * Exit DB and table results.
-- * 18	Specxxx_SC.db - as db18, special download records for terr xxx
-- *		Spec_SCBridge - Bridge records updated with terr xxx
-- * 30	<special-db>.db - as db30, special download records
-- *		<special-db> - table of special download records; TID updated
-- *		PropTerr - [legacy] table of property ID, streetaddress, terrid
-- *			NOT UPDATED with terr$P1
-- *		Spec_SCBridge - Bridge records updated with terr $P1
-- *		  Terr86777 table
-- *		TerrList - record counts updated for terr $P1
-- *
-- * Modification History.
-- * ---------------------
-- * 8/15/21.	wmk.	original code.
-- * 9/5/21.	wmk.	propuse 0350 accounted for.
-- *
-- * Notes.
-- *;

-- * DBs attached above;

-- ** perform territory-dependent fixes on new records **;
-- like eliminate unit fields since match numbers;

-- * set territory xxx in all these records;
UPDATE db18.Spec_SCBridge
SET 
CongTerrID = "xxx"
;

-- set record type;
WITH a AS (SELECT Code, RType FROM db2.SCPropUse)
UPDATE db18.Spec_SCBridge
SET RecordType =
CASE
WHEN PropUse IN (SELECT Code from a)
 THEN (SELECT RType FROM a 
   WHERE Code IS PropUse)
ELSE RecordType
END;
-- end SetRecordType;

-- repeat below block for each special db;
--*************** <special-db>;
--ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads/Special'
-- || '/<special-db>.db'
-- AS db30;
-- * set territory xxx in all Special/Spec_SCBridge records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db18.Spec_SCBridge)
UPDATE db30.Spec_SCBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END
;

-- set record type;
WITH a AS (SELECT Code, RType FROM db2.SCPropUse)
UPDATE db30.Spec_SCBridge
SET RecordType =
CASE
WHEN PropUse IN (SELECT Code from a)
 THEN (SELECT RType FROM a 
   WHERE Code IS PropUse)
ELSE RecordType
END;
-- end SetRecordType;
-- end SetRecordType;

-- * set territory xxx in all Special/<special-db> records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db18.Spec_SCBridge)
UPDATE db30.<special-db>
SET TID = 
CASE
WHEN "Account" IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE TID
END;

-- * update Terr xxx counts field in <special-db>.TerrList;
WITH a AS (SELECT DISTINCT TID from db30.<special-db>)
INSERT INTO db30.TerrList
 SELECT TID, 0 FROM a;
DELETE FROM db30.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db30.TerrList GROUP BY TerrID);
WITH a AS (SELECT TID from db30.<special-db>)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT TID FROM a)
 THEN (SELECT COUNT() TID FROM a 
   WHERE TID IS TerrID)
ELSE Counts
END;
DETACH db30;
--*****

--*************** <special-db>;
ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads/Special'
 || '/<special-db>.db'
 AS db30;
-- * set territory xxx in all Special/Spec_SCBridge records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db18.Spec_SCBridge)
UPDATE db30.Spec_SCBridge
SET CongTerrID = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE CongTerrID
END;
-- set record type;
WITH a AS (SELECT Code, RType FROM db2.SCPropUse)
UPDATE db30.Spec_SCBridge
SET RecordType =
CASE
WHEN PropUse IN (SELECT Code from a)
 THEN (SELECT RType FROM a 
   WHERE Code IS PropUse)
ELSE RecordType
END;
-- end SetRecordType;
-- end SetRecordType;
-- * set territory xxx in all Special/<special-db> records for xxx;
with a AS (SELECT OwningParcel AS Acct FROM db18.Spec_SCBridge)
UPDATE db30.<special-db>
SET TID = 
CASE
WHEN "Account" IN (SELECT Acct FROM a)
 THEN "xxx"
ELSE TID
END;

-- * update Terr xxx counts field in <special-db>.TerrList;
WITH a AS (SELECT DISTINCT TID from db30.<special-db>)
INSERT INTO db30.TerrList
 SELECT TID, 0 FROM a;
DELETE FROM db30.TerrList 
 WHERE rowid NOT IN (SELECT MAX(rowid)
  FROM db30.TerrList GROUP BY TerrID);
WITH a AS (SELECT TID from db30.<special-db>)
UPDATE TerrList
SET Counts = 
CASE
WHEN TerrID IN (SELECT TID FROM a)
 THEN (SELECT COUNT() TID FROM a 
   WHERE TID IS TerrID)
ELSE Counts
END;
DETACH db30;
-- ** END Fix$P1SC **********;

.quit
-- ** END SetSpecTerrs **********;

-- * SyncTerrToSpec.sql- Synchronize Terrxxx_RU.db with new Specxxx_RU.db records.
-- * 3/26/23.	wmk.
-- *
-- * Modification History.
-- *----------------------
-- * 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
-- *			 *congterr*, *conglib* env vars introduced.
-- * 6/19/22.	wmk.	revert to eliminating dups by UnitAddress, Unit,
-- *			 Resident for reliability.
-- * 3/26/23.	wmk.	VeniceNTerritory/NVenall > Terr86777; 266 > xxx.
-- * Legacy mods.
-- * ??			wmk.	eliminate older dups by UnitAddress, Unit, Resident.
-- * 10/19/21.	wmk.	mod to eliminate older dups by UnitAddress, Unit,
-- *					RecordDate.
-- * 10/25/21.	wmk.	mod to elimiinate older dups using RecordDate first,
-- *					then UnitAddress, Unit, Resident.
-- * 11/13/21.	wmk.	change all $ P1 to x xx.
-- * 1/18/22.	wmk.	add code to delete dup records with same RecordDate.
-- *
-- * Notes. 10/25 mod accounts for the case where MakeSpecials is run
-- * more than once on the same download data.
-- copy and edit this SQL template to territory RU download folder.
.cd '$pathbase'
.cd './RawData/RefUSA/RefUSA-Downloads/Terrxxx'
--.trace 'Procs-Dev/SQLTrace.txt'
-- open Terrxxx_RU.db and attach Specxxx_RU.db;
.open 'Terrxxx_RU.db'
ATTACH 'Specxxx_RU.db' AS db29;
-- insert records from Specxxx_RU.db.Spec_RUBridge into;
--   Terrxxx_RU.db.Terrxxx_RUBridge;
INSERT INTO Terrxxx_RUBridge
 SELECT * FROM db29.Spec_RUBridge;
-- eliminate oldest dups from Terrxxx_RUBridge based on UnitAddress,Unit;
-- NOTE: empty Unit fields are expected to be "", not null;
UPDATE Terrxxx_RUBridge
SET UnitAddress = trim(UnitAddress);
-- delete any dup records where unitaddress, unit are same,
--  but RecordDate is older; 
DELETE FROM Terrxxx_RUBridge 
WHERE rowid NOT IN (SELECT MAX(rowid) FROM Terrxxx_RUBridge
	GROUP BY UnitAddress, Unit, Resident1);
--  WHERE RecordDate NOT IN (SELECT MAX(RecordDate) FROM Terrxxx_RUBridge
--	GROUP BY UnitAddress, Unit);
-- now delete oldest records with duplicate Resident1 and RecordDate;
DELETE FROM Terrxxx_RUBridge 
WHERE rowid NOT IN (SELECT MAX(rowid) FROM Terrxxx_RUBridge
	GROUP BY UnitAddress, Unit, Resident1, RecordDate);
--  WHERE RecordDate NOT IN (SELECT MAX(RecordDate) FROM Terrxxx_RUBridge
--	GROUP BY UnitAddress, Unit, Resident1);
-- * now see if can set parcel IDs.
ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads/Terrxxx/Terrxxx_SC.db'
	AS db11;
with a AS (SELECT OwningParcel as PropID, 
 TRIM(UnitAddress) AS StreetAddr, Unit AS SCunit, SitusAddress AS Situs
 FROM TERRxxx_SCBridge)
UPDATE Terrxxx_RUBridge
SET OwningParcel = 
CASE 
WHEN Upper(trim(UnitAddress))
 IN (SELECT StreetAddr FROM a
 WHERE SCunit IS Unit)
 THEN (SELECT PropID FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCunit IS Unit)
ELSE OwningParcel
END, 
SitusAddress = 
CASE 
WHEN Upper(trim(UnitAddress))
 IN (SELECT StreetAddr FROM a
 WHERE SCunit IS Unit)
 THEN (SELECT Situs FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCunit IS Unit)
ELSE SitusAddress
END
WHERE OwningParcel IS "-";
-- * set all SitusAddress fields;
UPDATE Terrxxx_RUBridge
SET SitusAddress = 
 TRIM(UPPER(UnitAddress)) || "     " || Unit
WHERE SitusAddress ISNULL 
 OR LENGTH(TRIM(SitusAddress)) = 0;
-- * end set all SitusAddress fields;
-- * set all propuse, recordtype fields;
ATTACH '$pathbase/DB-Dev/Terr86777.db'
 AS db2;
-- pragma db2.table_info(Terr86777);
WITH a AS (SELECT "Account #" AS Acct, "property use code" AS UseType
 FROM Terr86777
 WHERE Acct IN (SELECT OwningParcel FROM Terrxxx_RUBridge)),
 b AS (SELECT Code, RType FROM SCPropUse)
UPDATE Terrxxx_RUBridge
SET  PropUse = 
CASE 
 WHEN OwningParcel IN (SELECT Acct FROM a)
  THEN (SELECT UseType FROM a 
   WHERE Acct IS OwningParcel)
 ELSE PropUse
 END,
RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM b)
 THEN (SELECT RType FROM b
  WHERE Code IS PropUse)
ELSE RecordType
END
WHERE PropUse ISNULL OR LENGTH(TRIM(PropUse)) = 0;
-- * end set all propuse fields;
.quit
-- end SyncTerrToSpec.sql;

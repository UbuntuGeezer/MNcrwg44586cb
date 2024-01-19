-- ReclinataCirTidy.sql - Complete fields in RU-Special/ReclinataCir.sql.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * 6/1/22.     wmk.   VeniceNTerritory > Terr86777; NVenAll > Terr86777.
-- 		12/7/21.	wmk.
-- *
-- * Entry.	../RefUSA-Downloads/Special/ReclinataCir.db is the special DB for all
-- *		 territories needing selected records from The Esplanade.
-- *			Spec_RUBridge is the Bridge records for use with territories
-- *
-- * Exit.	Spec_RUBridge has the following fields updated:
-- *			RecordDate is set to the date the RU data was downloaded
-- *			RecordType is set according to the PropUse field value			
-- *	
-- * Modification History.
-- * ---------------------
-- * 10/9/21.	wmk.	original code; cloned from WaterfordNE.
-- * 12/7/21.	wmk.	use $ TODAY env var to set RecordDate.
-- *
-- * Notes. To simplify query the subdivision name 'ReclinataCir' is searched for in the
-- * "parcel desc 1" field; there are 2 exceptions 253, 406 Rio Terra where the string
-- * 'ReclinataCir' is found in the "parcel desc 4" field.
-- * RecordDate fields will be set to '2021-10-08'.
-- *;

.open '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special/ReclinataCir.db'
ATTACH '$pathbase/DB-Dev/Terr86777.db'
 AS db2;
-- pragma table_info(SCPropUse);
-- * delete stray records; no addresses along capri isles in Eagle Point;
--DELETE FROM Spec_RUBridge
--WHERE UnitAddress LIKE '%capri isles%';

-- * first, set owningparcels, situsaddress, propuse, phone2
-- *  based on situs address match, no unit;
WITH a AS (SELECT "ACCOUNT #" AS Acct, 
 TRIM(SUBSTR("Situs address (property address)",1,35)) AS StreetAddr,
 "property use code" AS UseType,
 "situs address (property address)" AS Situs,
 CASE
 WHEN "homestead exemption" IS 'YES'
  THEN '*'
 ELSE ''
 END AS Hstead
 FROM Terr86777
  WHERE "situs address (property address)" like '%reclinata cir%')
UPDATE Spec_RUBridge
SET OwningParcel = 
CASE 
WHEN 
 UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
  WHERE StreetAddr IS upper(trim(UnitAddress)) )
ELSE OwningParcel
END,
 SitusAddress =
CASE 
WHEN 
 UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS upper(trim(UnitAddress)) )
ELSE SitusAddress
END,
 PropUse =
CASE 
WHEN 
 UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a
  WHERE StreetAddr IS upper(trim(UnitAddress)) )
ELSE PropUse
END,
 Phone2 =
CASE 
WHEN 
 UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT HStead FROM a
  WHERE StreetAddr IS upper(trim(UnitAddress)) )
ELSE Phone2
END
;

-- * no addresses in Reclinata have unit numbers;
WITH a AS (SELECT Code, RType FROM SCPropUse)
UPDATE Spec_RUBridge
SET RecordDate = '$TODAY',
 RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a)
 THEN (SELECT RType FROM a 
   WHERE Code IS PropUse)
ELSE RecordType
END;
.quit


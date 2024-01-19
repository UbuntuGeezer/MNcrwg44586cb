-- GondolaParkDrTidy.sql - Complete fields in RU-Special/GondolaParkDr.db.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * 6/1/22.     wmk.   VeniceNTerritory > Terr86777; NVenAll > Terr86777.
-- 		12/7/21.	wmk.
-- *
-- * Entry.	../RefUSA-Downloads/Special/GondoalParkDr.db is the special DB for all
-- *		 territories needing selected records from GondolaParkDr.
-- *			Spec_RUBridge is the Bridge records for use with territories
-- *
-- * Exit.	Spec_RUBridge has the following fields updated:
-- *			RecordDate is set to the date the RU data was downloaded
-- *			RecordType is set according to the PropUse field value			
-- *	
-- * Modification History.
-- * ---------------------
-- * 11/9/21.	wmk.	original code; cloned from Bellagio; mod to use $ TODAY
-- *					environment var; add code to set OwningParcel,s first.
-- * 12/7/21.	wmk.	edited for gondola park dr.
-- *
-- * Notes. The record date fields will be set to 2021-11-08, matching the .csv
-- * download date.
-- *;

.open '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special/GondolaParkDr.db'
ATTACH '$pathbase/DB-Dev/Terr86777.db'
 AS db2;
-- pragma table_info(SCPropUse);
-- * delete stray records; no addresses along capri isles in Eagle Point;
--DELETE FROM Spec_RUBridge
--WHERE UnitAddress LIKE '%capri isles%';

-- * first, set OwningParcels based on UnitAddress match.
WITH a AS (SELECT "ACCOUNT #" AS Acct, 
 TRIM(SUBSTR("Situs address (property address)",1,35)) AS StreetAddr,
 "situs zip code" AS ZipCode
FROM Terr86777
  WHERE "situs address (property address)" like '%gondola park dr%')
UPDATE Spec_RUBridge
SET OwningParcel = 
CASE
WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
   WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) )
ELSE OwningParcel
END;
 
-- * next, set ZipCode in UnitAddress,s to match SCBridge entries;
WITH a AS (SELECT "ACCOUNT #" AS Acct, 
 TRIM(SUBSTR("Situs address (property address)",1,35)) AS StreetAddr,
 "situs zip code" AS ZipCode
FROM Terr86777
  WHERE "situs address (property address)" like '%gondola park dr%')
UPDATE Spec_RUBridge
SET UnitAddress = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM a)
AND 
(INSTR(UnitAddress,'34275') = 0
 AND INSTR(UnitAddress,'34285') = 0
 AND INSTR(UnitAddress,'34292') = 0)
 THEN TRIM(UnitAddress) || '   '
  || (SELECT ZipCode FROM a
      WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
;

-- * then set situsaddress, propuse, phone2
-- *  based on OwningParcel;
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
  WHERE "situs address (property address)" like '%gondola park dr%')
UPDATE Spec_RUBridge
SET SitusAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN (SELECT Situs FROM a
  WHERE Acct IS OwningParcel)
ELSE SitusAddress
END,
 PropUse =
CASE  
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN (SELECT UseType FROM a
  WHERE Acct IS OwningParcel)
ELSE PropUse
END,
 Phone2 =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN (SELECT HStead FROM a
  WHERE Acct IS OwningParcel)
ELSE Phone2
END
;

-- * set RecordDate and RecordType fields.
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


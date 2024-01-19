-- GibbsRdTidy.sql - Complete fields in RU-Special/GibbsRd.db.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * 6/2/22.     wmk.   (automated) NVenAll > Terr86777.
-- 		12/30/21.	wmk.
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
-- * 12/30/21.	wmk.	original code; cloned from BirdBayWay.
-- *
-- * Notes. 909 and 911 Gibbs Rd are duplexes. The mailing addresses are
-- * 909 A,B 911 A,B, but the county is using 8,9 and 10,11 as unit numbers.
-- * Terr128_SC.db must have been fixed before running GibbsRdTidy.
-- * The record date fields will be set to $ TODAY, matching the date the db
-- * was generated.
-- *;

-- * attach db's;
.open '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special/GibbsRd.db'
ATTACH '$pathbase/DB-Dev/Terr86777.db'
 AS db2;
-- pragma table_info(SCPropUse);
-- * delete stray records; no addresses along capri isles in Eagle Point;
--DELETE FROM Spec_RUBridge
--WHERE UnitAddress LIKE '%%';

-- * fix 909A 911A and similar anomalies in RU download;
-- * see Notes above; these must also be fixed in the SCBridge;
UPDATE Spec_RUBridge
set UnitAddress = substr(UnitAddress,1,3) || ' ' || substr(UnitAddress,5),
Unit = substr(UnitAddress,4,1)
WHERE UnitAddress like '___A%'
   or UnitAddress like '___B%';

-- * first, set OwningParcels based on UnitAddress match.
WITH a AS (SELECT "ACCOUNT #" AS Acct, 
 TRIM(SUBSTR("Situs address (property address)",1,35)) AS StreetAddr,
 "situs zip code" AS ZipCode
FROM Terr86777
  WHERE "situs address (property address)" like '%gibbs rd%')
UPDATE Spec_RUBridge
SET OwningParcel = 
CASE
WHEN UPPER(TRIM(UnitAddress)) IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a
   WHERE StreetAddr IS UPPER(TRIM(UnitAddress)) )
ELSE OwningParcel
END;

-- * then set OwningParcels based on UnitAddress, Unit match.
-- * this accounts for 909, 911 Units A, B.
with a AS (select OwningParcel AS Acct, UnitAddress AS StreetAddr,
  Unit AS SCUnit FROM db11.Terr128_SCBridge)
update Spec_RUBridge
set owningparcel =
case
when upper(trim(UnitAddress)) in (select StreetAddr from a
  where SCUnit is Unit)
 then (select Acct from a where StreetAddr is upper(trim(UnitAddress)
  and SCUnit is Unit)
else owningparcel
end
where owningparcel is '-';
 
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
  WHERE "situs address (property address)" like '%gibbs rd%')
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

-- * all GibbsRd addresses are in territory 128;
UPDATE Spec_RUBridge
SET CongTerrID = '128';

.quit


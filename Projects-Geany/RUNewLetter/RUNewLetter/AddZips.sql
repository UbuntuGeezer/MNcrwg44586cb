-- * AddZips.sql - Add zip codes to RU unitadress,s in ANY letter territory.
-- *	10/28/21.	wmk.
-- *
-- * Modification History.
-- * 10/12/21.	wmk.	original code; adpapted from territory 603.
-- * 10/15/21.	wmk.	AddZips to Spec603_RU.db also.
-- * 10/16/21.	wmk.	edited for territory 603.
-- * 10/17/21.	wmk.	bug fix to account for possible zip code 'nnnnn-'.
-- * 10/22/21.	wmk.	generalized for territory y yy.
-- * 10/24/21.	wmk.	bug fix where residual 603s changed to y yy.
-- * 10/25/21.	wmk.	RUBridge code modified to Terrxx x_RUBridge; complete list
-- *					of territories processed (inefficient, but labor-saving).	
-- * legacy mods.
-- * 10/8/21.	wmk.	original code.
-- * 10/10/21.	wmk.	bug fix attaching NVenall instead of VeniceNTerritory;
-- *					code expanded to add zipcodes to all Special db RUBRidge
-- *					records; trim UnitAddress field before adding Zip Code.
-- * 10/11/21.	wmk.	fix missed trim UnitAddress Terr603_RUBridge.
-- * 10/25/21.	wmk.	updated with all letter Special/dbs.
-- * 10/28/21.	wmk.	added missing TheEsplanade.db.
-- *
-- * AddZips.sql will go through a build transformation to .sq to .sh
-- * The SQL will add zip codes, separated by 3 spaces, to unit addresses in
-- * all databases used by any territory.
-- *
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
.open '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Terrxxx/Terrxxx_RU.db'
ATTACH '$folderbase/Territories/DB-Dev/VeniceNTerritory.db'
 AS db2;
-- pragma db2.table_info(NVenAll);
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Terrxxx/Specxxx_RU.db'
 AS db19;
-- pragma db19.table_info(Spec_RUBridge);
-- * add zip codes to all RUBridge UnitAddresses where missing;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE Terrxxx_RUBridge
SET UnitAddress = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
-- *;
-- * add zip codes to all Specxxx_RU.db.RUBridge UnitAddresses where missing;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db19.Spec_RUBridge
SET UnitAddress = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db19;
-- *;
-- * now repeat for all Special db Bridge records so everything aligns while sorting;
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
-- *;
--*	AvensCohosh.db -  Windwood RU download
-- * AvensCohosh;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
  || '/AvensCohosh.db'
 AS db29;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_RUBridge
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db29;
--*	Bellagio.db - Bellagio RU download
-- * Bellagio;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
  || '/Bellagio.db'
 AS db29;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_RUBridge
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db29;
-- *;
--* BerkshirePlace.db - Berkshire Place RU download
-- * BerkshirePlace;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
  || '/BerkshirePlace.db'
 AS db29;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_RUBridge
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db29;
--* BrennerPark.db - Brenner Park RU download
-- * BrennerPark;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
  || '/BrennerPark.db'
 AS db29;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_RUBridge
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db29;
--* BridleOaks.db - Bridle Oaks RU download
-- * BridleOaks;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
  || '/BridleOaks.db'
 AS db29;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_RUBridge
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db29;
--* EaglePoint.db - Eagle Point RU download
-- * EaglePoint;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
  || '/EaglePoint.db'
 AS db29;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_RUBridge
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db29;
--* HiddenLakes.db - Hidden Lakes RU download
-- * HiddenLakes;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
  || '/HiddenLakes.db'
 AS db29;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_RUBridge
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db29;
--* ReclinataCir.db - Reclinata Circle RU download
-- * ReclinataCir;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
  || '/ReclinataCir.db'
 AS db29;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_RUBridge
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db29;
--* SawgrassN.db - Sawgrass north section RU download
-- * SawgrassN;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
  || '/SawgrassN.db'
 AS db29;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_RUBridge
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db29;
--* SawgrassS.db - Sawgrass south section RU download
-- * SawgrassS;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
  || '/SawgrassS.db'
 AS db29;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_RUBridge
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db29;
--*	TheEsplanade.db - TheEsplanade RU download
-- * TheEsplanade;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
  || '/TheEsplanade.db'
 AS db29;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_RUBridge
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db29;
--*	TrianoCir.db - TrianoCir RU download
-- * TrianoCir;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
  || '/TrianoCir.db'
 AS db29;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_RUBridge
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db29;
--* WaterfordNE.db - WaterfordNE RU download
-- * WaterfordNE;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
  || '/WaterfordNE.db'
 AS db29;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_RUBridge
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db29;
--*	WaterfordNW.db - WaterfordNW RU download
-- * WaterfordNW;
ATTACH '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special'
  || '/WaterfordNW.db'
 AS db29;
WITH a AS (SELECT OwningParcel AS PropID FROM Terrxxx_RUBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_RUBridge
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
DETACH db29;
.quit
-- ** end AddZips **********;

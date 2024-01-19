-- * AddZips.sql - Add zip codes to SC unitadress,s set yyy in letter territory .
-- *	10/29/21.	wmk.
-- *
-- * Modification History.
-- * 10/23/21.	wmk.	original code; generalized from territory 614 to yy y.
-- * 10/29/21.	wmk.	bug fix residual 616 in open statement.
-- * legacy mods.
-- * 10/8/21.	wmk.	original code.
-- * 10/10/21.	wmk.	bug fix attaching NVenall instead of VeniceNTerritory;
-- *					code expanded to add zipcodes to all Special db SCBridge
-- *					records; trim UnitAddress field before adding Zip Code.
-- * 10/11/21.	wmk.	fix missed trim UnitAddress Terr616_SCBridge.
-- * 10/12/21.	wmk.	original code; adpapted from territory 603.
-- * 10/15/21.	wmk.	AddZips to Spec616_RU.db also.
-- * 10/16/21.	wmk.	edited for territory xxx.
-- * 10/17/21.	wmk.	bug fix to account for possible zip code 'nnnnn-'.
-- * 10/17/21.	wmk.	adapted for SC 607 from RU;code added to set CongTerrID also.
-- * 10/18/21.	wmk.	edited for territory 616.
-- *
-- *
-- * NOTE. BridleOaks.db is NEW (replaces BridleOaksDr which does not include CONNEMARE).
-- * AddZips.sql will go through a build transformation to .sq to .sh
-- * The SQL will add zip codes, separated by 3 spaces, to unit addresses in
-- * all databases used by territory 616.
-- * BerkshirePlace
-- * BridleOaks
-- *;
.open '$folderbase/Territories/RawData/SCPA/SCPA-Downloads/Terryyy/Terryyy_SC.db'
ATTACH '$folderbase/Territories/DB-Dev/VeniceNTerritory.db'
 AS db2;
-- pragma db2.table_info(NVenAll);
-- * set CongTerrID in all records;
UPDATE Terryyy_SCBridge
SET CongTerrID = 'yyy';
-- * add zip codes to all SCBridge UnitAddresses where missing;
WITH a AS (SELECT OwningParcel AS PropID FROM Terryyy_SCBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE Terryyy_SCBridge
SET UnitAddress = 
CASE
WHEN OwningParcel IN (SELECT Acct FROM b) 
 THEN trim(UnitAddress) || '   ' || (SELECT Zip FROM b
   WHERE Acct IS OwningParcel)
ELSE UnitAddress
END
WHERE SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
-- *;
-- * now repeat for all Special db Bridge records so everything aligns while sorting;
-- * BerkshirePlace
-- * BridleOaks
-- *;
-- * BerkshirePLace;
ATTACH '$folderbase/Territories/RawData/SCPA/SCPA-Downloads/Special'
  || '/BerkshirePlace.db'
 AS db29;
-- * set CongTerrID in records;
WITH a AS (SELECT OwningParcel AS PropID FROM Terryyy_SCBridge)
UPDATE db29.Spec_SCBridge
SET CongTerrID =
CASE 
WHEN OwningParcel IN (SELECT PropID FROM a) 
 THEN 'yyy'
ELSE CongTerrID
END
;
-- * set zip codes in records;
WITH a AS (SELECT OwningParcel AS PropID FROM Terryyy_SCBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_SCBridge
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
-- * BridleOaks;
ATTACH '$folderbase/Territories/RawData/SCPA/SCPA-Downloads/Special'
  || '/BridleOaks.db'
 AS db29;
-- * set CongTerrID in records;
WITH a AS (SELECT OwningParcel AS PropID FROM Terryyy_SCBridge)
UPDATE db29.Spec_SCBridge
SET CongTerrID =
CASE 
WHEN OwningParcel IN (SELECT PropID FROM a) 
 THEN 'yyy'
ELSE CongTerrID
END
;
-- * set zip codes in records;
WITH a AS (SELECT OwningParcel AS PropID FROM Terryyy_SCBridge),
 b AS (SELECT "Account #" AS Acct, "situs zip code" AS Zip FROM db2.NVenAll 
   WHERE Acct IN (SELECT PropID FROM a) )
UPDATE db29.Spec_SCBridge
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
.quit
-- ** end AddZips **********;

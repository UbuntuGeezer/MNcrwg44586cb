-- * BuildDiffAcctsTbl.psq/sql - Build DiffAccts table in SCPADiff_05-28.db;
-- *	4/26/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 4/26/23.	wmk.	code a28ed to set territory ID 998 in all DiffAccts
-- *			 records having a residential use code, but no territory;
-- *			 co05ents tidied.
-- * 4/30/23.	wmk.	code a28ed to set territory IDs in "no territory"
-- *			 DiffAccts by zip code.
-- * Legacy mods.
-- * 1/1/22.     wmk.   original code.
-- * 4/26/22.    wmk.   *pathbase* support.
-- *
-- * Notes. The DiffAccts table is build anew. 
-- * Extracts all Property IDs from Diff0528 into DiffAccts
-- * Scans MultiMail.db setting territory IDs for PropIDs
-- * Scans PolyTerri.db setting territory IDs for PropIDs
-- *
-- * This leaves DiffAccts as a list of territory IDs affected
-- * by this download. Only territory IDs that are in the current
-- * publisher territories are known.
-- *
-- * This may leave some new records "stranded" with no known
-- * territory ID. These "stranded" records will have territory
-- * ID 998 assigned so that they may be checked if they belong
-- * in a publisher territory, but were previously missed being
-- * assigned.
-- *;
.open '$pathbase/RawData/SCPA/SCPA-Downloads/SCPADiff_05-28.db'
ATTACH '$pathbase/DB-Dev/Terr86777.db'
  AS db2;
ATTACH '$pathbase/DB-Dev/MultiMail.db' 
  AS db3;
ATTACH '$pathbase/DB-Dev/PolyTerri.db'
 AS db5;
--;
DROP TABLE IF EXISTS DiffAccts;
CREATE TABLE DiffAccts(
 PropID TEXT DEFAULT '9999999999',
 TerrID TEXT DEFAULT '',
 DelFlag INTEGER DEFAULT 0,
 FOREIGN KEY(PropID)
 REFERENCES Diff0528
 ON UPDATE CASCADE
 ON DELETE NO ACTION);
 
insert into DiffAccts(PropID) 
SELECT "ACCOUNT#" FROM Diff0528;
ORDER BY "HomesteadExemption" DESC;

--;
-- * Check MultiMail for territory IDs;
WITH a AS (SELECT DISTINCT OwningParcel AS Acct,
CONGTERRID FROM SplitProps
 WHERE Acct
 IN (SELECT "Account#" FROM Diff0528))
UPDATE DiffAccts
SET TerrID =
CASE 
WHEN PropID IN (SELECT Acct FROM a)
 THEN (SELECT CongTerrID FROM a 
  WHERE Acct IS PropID)
ELSE TerrID
END
WHERE TerrID ISNULL 
 OR LENGTH(TerrID) = 0;
--;
-- * now check PolyTerri for territory IDs;
WITH a AS (SELECT DISTINCT OwningParcel AS Acct,
CONGTERRID FROM TerrProps
 WHERE Acct
 IN (SELECT "Account#" FROM Diff0528))
UPDATE DiffAccts
SET terrid =
CASE 
WHEN PropID IN (SELECT Acct FROM a)
 THEN (SELECT CongTerrID FROM a 
  WHERE Acct IS pROPId)
ELSE TerrID
END
WHERE TerrID ISNULL 
 OR LENGTH(TerrID) = 0;

-- * now set territory ID by zip code for all entries
-- * that are a residential property use, but not
-- * found in either of the main publisher territory dbs
-- * 998 - zip code 34285
-- * 997 - zip code 34275
-- * 996 - zip code 34292;

DROP TABLE IF EXISTS NoTerrs;
create temp table NoTerrs(PropID text,PropUse text);

WITH a AS (SELECT PropID from DiffAccts
WHERE length(terrid) = 0)
INSERT INTO NoTerrs
SELECT "Account#" Acct, PropertyUseCode FROM Diff0404
WHERE Acct IN (SELECT PropID FROM a);

WITH a AS (SELECT Code, RType FROM db2.SCPropUse
WHERE RType IS 'P'
   OR RType IS 'M'),
b AS (SELECT * FROM NoTerrs)
UPDATE DiffAccts
SET TerrID = '998'
WHERE PropID IN (SELECT PropID FROM b
 INNER JOIN a
 ON a.Code IS b.PropUse);
 ;

-- * now reassign by zip code;
DROP TABLE IF EXISTS ResNoTerr;
CREATE TEMP TABLE ResNoTerr(
Acct TEXT,
Situs TEXT,
Zip TEXT,
SCPropUse TEXT,
TerrID TEXT,
PRIMARY KEY (Acct));

WITH a AS (SELECT PropID FROM DiffAccts
 WHERE TerriD IS '998'),
b AS (SELECT Code, RType FROM db2.SCPropUse
WHERE RType IS 'P'
   OR RType IS 'M')
INSERT INTO ResNoTerr
SELECT "Account#" Acct, "situsa28ress(propertya28ress)" Situs,
 "SitusZipCode" Zip, "PropertyUseCode" SCPropUse, '998'
FROM Diff0404
INNER JOIN b
ON b.Code IS SCPropUse
WHERE Acct IN (SELECT PropID from a);

-- * correct TerrID fields in ResNoTerr by zip code;
UPDATE ResNoTerr
SET TerrID =
CASE WHEN Zip LIKE '34275%'
 THEN '997'
WHEN ZIP LIKE '34292%'
 THEN '996'
ELSE TerrID
END;

-- now reassign DiffAccts terr IDs by zip code;
WITH a AS (SELECT Acct, Zip, TerrID CorrTerr FROM ResNoTerr)
UPDATE DiffAccts
SET TerrID =
CASE WHEN PropID IN (SELECT Acct FROM a)
 THEN (SELECT CorrTerr FROM a
  WHERE Acct IS PropID)
ELSE TerrID
END;

-- * end BuildDiffAcctsTbl;

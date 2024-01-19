-- GetDiffTerrIDs.sql - Get DiffAccts territory IDs from main dbs.
-- 		11/4/21.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 11/4/21.	wmk.	original code.

ALTER TABLE DiffAccts ADD COLUMN TerrID;

-- * set territories from TerrProps;
WITH a AS (SELECT "Account#" FROM Diff1102),
b AS (SELECT DISTINCT OwningParcel, 
  CongTerrID AS CongTerr FROM TerrProps)
UPDATE DiffAccts
SET TerrID = 
CASE
WHEN DiffAcct IN (SELECT OwningParcel FROM b)
 THEN (SELECT CongTerr FROM b
   WHERE OwningParcel IS DiffAcct)
ELSE TerrID
END
WHERE DelFlag IS NOT 1;

-- * set territories from SplitProps;
WITH a AS (SELECT "Account#" FROM Diff1102),
b AS (SELECT DISTINCT OwningParcel, 
  CongTerrID AS CongTerr FROM SplitProps)
UPDATE DiffAccts
SET TerrID = 
CASE
WHEN DiffAcct IN (SELECT OwningParcel FROM b)
 THEN (SELECT CongTerr FROM b
   WHERE OwningParcel IS DiffAcct)
ELSE TerrID
END
WHERE DelFlag IS NOT 1;

.output 'Unassigned Diffs.txt'
.headers ON
.mode csv
.separator ,
SELECT DiffAcct FROM DiffAccts
WHERE DelFlag IS NOT 1
 and (TerrID ISNULL 
 OR LENGTH(TerrID) = 0);

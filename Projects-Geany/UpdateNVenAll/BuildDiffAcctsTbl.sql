--BuildDifAcctsTbl.psq/sql - Build DiffAccts table in SCPADiff_03-19.db;
--	1/1/22.	wmk.;
.open '/home/vncwmk3/Territories/RawData/SCPA/SCPA-Downloads/SCPADiff_03-19.db'
ATTACH '/home/vncwmk3/Territories/DB-Dev/MultiMail.db' 
  AS db3;
ATTACH '/home/vncwmk3/Territories/DB-Dev/PolyTerri.db'
 AS db5;
--;
DROP TABLE IF EXISTS DiffAccts;
CREATE TABLE DiffAccts
(PropID TEXT, TerrID TEXT, DelFlag INTEGER DEFAULT 0);
insert into DiffAccts 
SELECT "ACCOUNT#", '', 0 FROM Diff0319;
--;
WITH a AS (SELECT DISTINCT OwningParcel AS Acct,
CONGTERRID FROM SplitProps
 WHERE Acct
 IN (SELECT "Account#" FROM Diff0319))
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
WITH a AS (SELECT DISTINCT OwningParcel AS Acct,
CONGTERRID FROM TerrProps
 WHERE Acct
 IN (SELECT "Account#" FROM Diff0319))
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
-- end BuildDiffAcctsTbl

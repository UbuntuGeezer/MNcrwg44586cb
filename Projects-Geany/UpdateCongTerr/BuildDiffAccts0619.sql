--BuildDifAccts0619.sql - Build DiffAccts table in SCPADiff_06-19.db;
--	7/23/21.	wmk.;
.open '/media/ubuntu/Windows/Users/Bill/Territories/RawData/SCPA/SCPA-Downloads/SCPADiff_06-19.db'
ATTACH '/media/ubuntu/Windows/Users/Bill/Territories/DB-Dev/MultiMail.db' 
  AS db3;
ATTACH '/media/ubuntu/Windows/Users/Bill/Territories/DB-Dev/PolyTerri.db'
 AS db5;
--;
DROP TABLE IF EXISTS DiffAccts;
CREATE TABLE DiffAccts
(PropID TEXT, TerrID TEXT);
insert into DiffAccts 
SELECT "ACCOUNT #", "" FROM Diff0619;
--;
WITH a AS (SELECT DISTINCT OwningParcel AS Acct,
CONGTERRID FROM SplitProps
 WHERE Acct
 IN (SELECT "Account #" FROM Diff0619))
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
 IN (SELECT "Account #" FROM Diff0619))
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
-- end BuildDiffAccts0619

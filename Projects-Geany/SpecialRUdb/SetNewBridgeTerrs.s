-- * SetNewBridgeTerrs.s - set new special Bridge CongTerrID fields.
-- * 6/5/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 6/5/23.	wmk.	change to use *pathbase; comments tidied.
-- * Legacy mods.
-- * 7/18/21.	wmk.	original code.
-- *;
.open '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special/vvvvv.db'
ATTACH 'pathbase/DB-Dev/PolyTerri.db'
 AS db5;
ATTACH 'pathbase/DB-Dev/MultiMail.db'
 AS db3;
-- find matches in TerrProps;
with a AS (select TRIM(UnitAddress) AS StreetAddr,
 CongTerrID AS TerrNo FROM TerrProps 
 where TerrNo IN (SELECT TerrID from TerrList))
UPDATE Spec_RUBridge
SET CongTerrID = (SELECT TerrNo FROM a 
CASE 
WHEN TRIM(UNITADDRESS) IN (SELECT StreetAddr FROM a)
THEN (SELECT TerrNo FROM a 
 WHERE StreetAddr IS trim(UnitAddress))
ELSE CongTerrID
END 
WHERE trim(UnitAddress) IN (SELECT StreetAddr FROM a);
-- now find matches in SplitProps;
with a AS (select TRIM(UnitAddress) AS StreetAddr,
 CongTerrID AS TerrNo FROM SplitProps 
 where TerrNo IN (SELECT TerrID from TerrList))
UPDATE Spec_RUBridge
SET CongTerrID =
CASE 
WHEN TRIM(UNITADDRESS) IN (SELECT StreetAddr FROM a)
THEN (SELECT TerrNo FROM a 
 WHERE StreetAddr IS trim(UnitAddress))
ELSE CongTerrID
END 
WHERE trim(UnitAddress) IN (SELECT StreetAddr FROM a);
.quit
-- end SetNewBridgeTerrs.sq;

-- * rebuild TerrList table.
DROP TABLE IF EXISTS db29.TerrList;
CREATE TABLE db29.TerrList(
 TerriD TEXT,
 Counts INTEGER DEFAULT 0
 );

WITH a AS (SELECT DISTINCT CongTerrID from db29.Spec_RUBridge)
INSERT INTO db29.TerrList(TerrID)
 SELECT CongTerrID FROM a;


WITH a AS (SELECT CongTerrID from db29.Spec_RUBridge)
UPDATE db29.TerrList
SET Counts =
 (SELECT COUNT() congterrID FROM a
  WHERE CongTerrID IS TerrID);
  
DETACH db29;


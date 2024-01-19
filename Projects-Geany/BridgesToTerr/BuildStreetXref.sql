--  Build StreetXref.sql - Build Street crossrefence db.
--		10/5/21.	wmk.
-- * .open 'StreetXRev.db'
DELETE FROM StreetXRef;

WITH a AS
(SELECT DISTINCT 
trim(SUBSTR(UnitAddress,INSTR(UnitAddress,
  ' '))) AS Streets, CongTerrID As TerrID
  FROM db3.SplitProps)
INSERT OR IGNORE INTO StreetXRef 
SELECT Streets, TerrID, '', '', ''
 FROM a;
 
 WITH a AS
(SELECT DISTINCT 
trim(SUBSTR(UnitAddress,INSTR(UnitAddress,
  ' '))) AS Streets, CongTerrID as TerrID
  FROM db5.TerrProps)
INSERT OR IGNORE INTO StreetXRef 
SELECT Streets, TerrID, '', '', ''
 FROM a;

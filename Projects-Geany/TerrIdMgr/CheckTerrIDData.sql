-- * CheckTerrIDData.psq/sql - Check TerrID database for territory 964;
-- * 6/2/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 6/2/23.	wmk.	original code.
-- *
-- * Notes.
-- *;
.open '$pathbase/DB-Dev/TerrIDData.db'
.mode list
.output '$TEMP_PATH/FoundTerritory.txt'
SELECT TerrID from Territory
WHERE TerrID IS '964'
;
.quit
-- * END CheckTerrDefined.sql;


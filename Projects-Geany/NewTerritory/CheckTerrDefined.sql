-- * CheckTerrDefined.psq/sql - Check for territory defined within TerrIDData.
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
.output '$TEMP_PATH/FoundTerrID.txt'
SELECT TerrID from Territory
WHERE TerrID IS '947'
;
.quit
-- * END CheckTerrDefined.sql;

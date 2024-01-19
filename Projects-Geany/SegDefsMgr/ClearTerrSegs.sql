-- * ClearTerrSegs.psq/sql - export territory segments to Terr264Streetstxt.
-- * 2/10/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 2/7/23.	wmk.	original code.
-- * 2/8/23.	wmk.	mod to write SQL "WHERE" snippet.
-- * Notes.
-- *;
.open '$pathbase/DB-Dev/TerrIDData.db'
.mode csv
.headers off
.output '$pathbase/$rupath/Terr264/segdefs.csv'
SELECT sqldef FROM SegDefs
 WHERE TerrID IS '264'
 ORDER BY RecNo;
.quit
-- * END ClearTerrSegss.sql;

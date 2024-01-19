-- * ListTerrSegs.psq/sql - export territory segments to Terr308Streetstxt.
-- * 2/14/23.	wmk.
-- *
-- * Entry.	*pathbase/DB-Dev/TerrIDData.db table SegDefs contains Terr308 segments.
-- *
-- * Exit.	TerrIDData.EndMessage table has termination message(s).
-- *		/RefUSA-Downloads/Jumpto.sql will display any termination message(s).
-- *		$TEMP_PATH/Terr308.segdefs.csv has results.
-- *		 formerly output to:
-- *		/RefUSA-Downloads/Terryy/segdefs.csv has segment definitions for '308'.
-- *		/SCPA-Downloads/Terr308/segdefs.csv has segment definitions for '308'.
-- *
-- * Modification History.
-- * ---------------------
-- * 2/7/23.	wmk.	original code.
-- * 2/8/23.	wmk.	mod to write SQL "WHERE" snippet.
-- * 2/14/23.	wmk.	snippets written to both RefUSA and SCPA territory;
-- *			 EndMessage termination message set.
-- *
-- * Notes.
-- *;
.open '$pathbase/DB-Dev/TerrIDData.db'

-- * Clear EndMessage table;

-- * get segment count;
CREATE TEMP TABLE SegCounts(Counts INTEGER);
INSERT INTO SEGCounts( Counts )
SELECT COUNT() sqldef FROM SegDefs
WHERE TerrID IS '308';

WITH a AS (SELECT Counts FROM SegCounts)
INSERT INTO EndMessage(msg)
SELECT CASE WHEN a.Counts > 0
THEN "  ListTerrSegs exporting " || a.Counts || " segments."
ELSE "  **ListTerrSegs - No segments defined for territory '308' **"
END
FROM a;

.mode list
.headers off
.separator "|"
-- * output to $TEMP_PATH/Terr308.segdefs.csv;
.output '$TEMP_PATH/Terr308.segdefs.csv'
WITH a AS (SELECT Counts FROM SegCounts)
SELECT sqldef FROM SegDefs
INNER JOIN a
ON a.Counts > 0 
WHERE TerrID IS '308'
ORDER BY RecNo;
 
--;
-- * output to *rupath first;
--.output '$pathbase/$rupath/Terr308/segdefs.csv;
--WITH a AS (SELECT Counts FROM SegCounts)
--SELECT sqldef FROM SegDefs
--INNER JOIN a
--ON a.Counts > 0 
--WHERE TerrID IS '308'
--ORDER BY RecNo;
 
-- * output to *scpath/Terr308/segdefs.csv;
--.output '$pathbase/$scpath/Terr308/segdefs.csv;
--WITH a AS (SELECT Counts FROM SegCounts)
--SELECT sqldef FROM SegDefs
--INNER JOIN a
--ON a.Counts > 0 
-- WHERE TerrID IS '308'
-- ORDER BY RecNo;
 
.quit
-- * END ListTerrSegs.sql;

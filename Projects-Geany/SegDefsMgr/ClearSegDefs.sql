-- * ClearSegDefs.psq/sql - Clear TerriDData.SegDefs table of territory xxx entries.
-- * 3/8/23.	wmk.
-- *
-- * Entry. Jumpto.sql contains SQL code to issue EndMessage table messages.
-- *	    /DB-Dev/TerrIDData.db.DefSegs table contains definitions.
-- *
-- * Exit. table TerriDData.SegDefs entries removed tor territory.
-- *	   table TerrIDData.Territory.Segmented = 0 for territory.
-- *
-- * Modification History.
-- * ---------------------
-- * 2/15/23.	wmk.	original code; adpated from LoadSegDefs.
-- * 3/5/23.	wmk.	documentation clarified.
-- * 3/8/23.	wmk.	Note text corrected with 308.
-- *
-- * Notes. segdefs.sqldef contains a set of WHERE clauses with the following pattern:
-- *	WHERE UnitAddress LIKE '%street1%'
-- *       OR UnitAddress LIKE '%street2%'
-- *	   OR (UnitAddress LIKE '%street3%'
-- *	     AND CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')) AS INT) >= n1
-- *	     AND CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')) AS INT) >= n2
-- *         AND CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')) AS INT)%2 = 1)
-- *
-- * This query only clears the segdefs from the TerrIDData.SegDefs table. It
-- * leaves the segdefs.csv file in the territory data alone.
-- *;
.open '$pathbase/DB-Dev/TerrIDData.db'

DROP TABLE IF EXISTS EndMessage;
CREATE TABLE EndMessage(
 msg TEXT)
 ;

INSERT INTO EndMessage
VALUES( " ClearSegDefs initiated..");

INSERT INTO EndMessage
VALUES("  Note. ClearSegDefs does not clear Terr308/segdefs.csv");

DELETE FROM SegDefs
WHERE TerrID IS '308';

UPDATE Territory
SET Segmented = 0
WHERE TerrID IS '308';

DROP TABLE IF EXISTS Counts308;
CREATE TABLE Counts308(
 Count INTEGER )
;
INSERT INTO Counts308(Count)
SELECT count() TerriD FROM SegDefs
WHERE TerrID IS '308';

WITH a AS (SELECT Count FROM Counts308)
INSERT INTO EndMessage
SELECT CASE WHEN a.Count > 0
THEN "  **ClearSegDefs FAILED - SegDefs for 308 not cleared.**"
ELSE "  ClearSegDefs complete."
END FROM a;

.quit
-- ** END ClearSegDefs.sql

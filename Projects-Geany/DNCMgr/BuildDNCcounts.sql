-- * BuildDNCCounts.sql - Build DNCCounts table in TerrIDData.
-- *	6/8/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 6/8/23.	wmk.	original code.
-- *
-- * Notes.
-- *;

.open '$pathbase/DB-Dev/TerrIDData.db'
--pragma table_info(DoNotCalls);
--pragma table_info(DNCCounts);

DROP TABLE IF EXISTS DNCCounts;
CREATE TABLE DNCCounts(
 TerrID TEXT,
 NumDNCs INTEGER DEFAULT 0,
 PRIMARY KEY(TerrID),
 FOREIGN KEY(TerrID)
 REFERENCES Territory(TerrID)
 ON UPDATE CASCADE)
 ;

INSERT INTO DNCCounts(TerrID)
SELECT DISTINCT TerrID FROM DoNotCalls;

UPDATE DNCCounts
SET NumDNCs =
 (SELECT COUNT() TerrID FROM DoNotCalls
  WHERE TerrID IS DNCCounts.TerrID
  AND DelPending <> 1);

.quit
-- * END BuildDNCCounts.sql;

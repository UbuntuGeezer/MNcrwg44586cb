-- ClearRUBridge.psq - Clear RUBridge table in territory 314.
-- *	7/9/22.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 10/20/21.	wmk.	original code.
-- * 7/9/22.	wmk.	*pathbase support.
-- *;
.open '$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr314/Terr314_RU.db'
DELETE FROM Terr314_RUBridge;
.quit
-- * end ClearRUBridge.sql;

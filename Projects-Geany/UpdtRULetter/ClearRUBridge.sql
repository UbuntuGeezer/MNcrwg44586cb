-- ClearRUBridge.psq - Clear RUBridge table in territory 612.
--		10/20/21.	wmk.
.open '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Terr612/Terr612_RU.db'
DELETE FROM Terr612_RUBridge;
.quit
-- end ClearRUBridge.sql

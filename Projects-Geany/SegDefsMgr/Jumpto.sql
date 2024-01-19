-- Jumpto.psq - Jump to code for LoadSegDefs.psq.;
-- 2/25/23.   wmk - new table structure for SegDefsMgr;
-- 2/11/23.   wmk - original code.;
.open '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/TerrIDData.db'
DROP TABLE IF EXISTS "Defs308";
CREATE TABLE "Defs308"(
 newtid TEXT,
 newdb TEXT,
 newsql TEXT)
;
.mode csv
.headers OFF
.separator |
.import '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/Terr308/segdefs.csv' "Defs308"
.quit
-- end Jumpto.psq


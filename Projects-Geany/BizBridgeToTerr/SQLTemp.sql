-- * QBGetTerr query as batch run.
.cd /media/ubuntu/Windows/Users/Bill/Territories/FL/SARA/86777
.cd './BTerrData/Terr521/Working-Files'
ATTACH '/media/ubuntu/Windows/Users/Bill/Territories/FL/SARA/86777/BRawData/RefUSA/RefUSA-Downloads'
||		'/Terr521/Terr521_RU.db'
 AS db12;
.headers ON
.mode csv
.separator ,
.output '/media/ubuntu/Windows/Users/Bill/Territories/FL/SARA/86777/BTerrData/Terr521/Working-Files/QTerr521.csv'
SELECT * FROM Terr521_RUBridge
ORDER BY TRIM(SUBSTR(UnitAddress,INSTR(UnitAddress,' '))),
  CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')-1) AS INTEGER);
.quit

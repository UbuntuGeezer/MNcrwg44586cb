-- * QBGetTerr query as batch run.
.cd /media/ubuntu/Windows/Users/Bill/Territories
.cd './BTerrData/Terr310/Working-Files'
ATTACH '/media/ubuntu/Windows/Users/Bill/Territories/BRawData/BRefUSA/BRefUSA-Downloads'
||		'/Terr310/Terr310_RU.db'
 AS db12;
.headers ON
.mode csv
.separator ,
.output '/media/ubuntu/Windows/Users/Bill/Territories/BTerrData/Terr310/Working-Files/QTerr310.csv'
SELECT * FROM Terr310_RUBridge
ORDER BY TRIM(SUBSTR(UnitAddress,INSTR(UnitAddress,' '))),
  CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')-1) AS INTEGER);
.quit

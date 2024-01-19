-- SQLTemp.sql - RUNewTerr raw .csv to .db.
.cd '/media/ubuntu/Windows/Users/Bill/Territories'
.open "./DB-Dev/TerrIDData.db"
.headers on
.mode csv
.separator , 
.cd '/media/ubuntu/Windows/Users/Bill/Territories/BTerrData'
.cd './Terr521/Working-Files'
.output 'Terr521Hdr.csv'
SELECT * FROM Territory
 WHERE TerrID Is "521";
.quit

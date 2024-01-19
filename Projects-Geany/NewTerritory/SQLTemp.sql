-- SQLTemp.sql - RUNewTerr raw .csv to .db.
.cd '/home/vncwmk3/Territories/FL/SARA/86777'
.open "./DB-Dev/TerrIDData.db"
.headers on
.mode csv
.separator , 
.cd '/home/vncwmk3/Territories/FL/SARA/86777/TerrData'
.cd './Terr947/Working-Files'
.mode csv
.headers on
.separator ,
.import 'Terr947Hdr.csv' Territory
DELETE FROM Territory
WHERE TerrID is 'TerrID';
.quit

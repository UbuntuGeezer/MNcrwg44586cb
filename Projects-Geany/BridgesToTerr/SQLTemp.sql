--QGenTable. - Generate .csv from QTerrxxx.
.cd '/home/vncwmk3/Territories/MN/CRWG/99999/TerrData' 
.cd './Terr275/Working-Files'
.open QTerr275.db
.shell echo \Generating QTerr275.csv\ | awk '{print $1}' >> SQLTrace.txt
.shell rm QTerr275.csv
.headers ON
.output 'QTerr275.csv'
SELECT * FROM QTerr275;
.quit

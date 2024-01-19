#!/bin/bash
#QGetSubTerrHdr.sh - get header information for specified territory.
#	9/29/20.	wmk.
#	10/19/20.	wmk.	Territories folder moved 2 levels up
echo ".open /media/ubuntu/Windows/Users/Bill/Territories/DB/TerrIDData.db" > SQLTemp.sql
echo ".output Terr"$1"Hdr.csv" >> SQLTemp.sql
echo "SELECT TerrID, AreaName, 'Street-Address(s)'," >> SQLTemp.sql
echo " City, Zip, Location, Type FROM Territory" >> SQLTemp.sql
echo " WHERE TerrID IS '$1'" >> SQLTemp.sql
echo "UNION" >> SQLTemp.sql
echo "SELECT * FROM SubTerrs" >> SQLTemp.sql
echo " WHERE TerrID IS " >> SQLTemp.sql
echo "'$1'">> SQLTemp.sql
echo " AND SubTerr IS" >> SQLTemp.sql
echo "'$2';" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
sqlite3 <SQLTemp.sql
echo "  QGetSubTerrHdr complete - .csv on file Terr$1Hdr.csv" >> $system_log #
echo "  QGetSubTerrHdr complete - .csv on file Terr$1Hdr.csv"

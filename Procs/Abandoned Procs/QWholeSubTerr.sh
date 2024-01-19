#!/bin/bash
#QWholeSubTerr.sh - extract all subterritory information
#	9/30/20.	wmk.
#   Terrxxx.csv contains territory records from PolyTerri/MultiMail
#	TerrxxxHdr.csv contains header information from TerrIDData
echo ".open /media/ubuntu/Windows/Users/Bill/Documents/Cong-Files/Territories/DB/PolyTerri.db" > SQLTemp.sql
echo "ATTACH " >> SQLTemp.sql
echo "'/media/ubuntu/Windows/Users/Bill/Documents/Cong-Files/Territories/DB/MultiMail.db'" >> SQLTemp.sql
echo "  as db2;" >> SQLTemp.sql
echo ".output Terr$1.csv" >> SQLTemp.sql
echo "SELECT TerrProps.* FROM TerrProps" >> SQLTemp.sql
echo " WHERE CongTerrid IS '$1'" >> SQLTemp.sql
echo " AND SubTerritory IS '$2'" >> SQLTemp.sql
echo " AND (DelPending IS NULL" >> SQLTemp.sql
echo "     OR DelPending IS 0)" >> SQLTemp.sql
echo "UNION" >> SQLTemp.sql
echo "SELECT SplitProps.* FROM SplitProps" >> SQLTemp.sql
echo " WHERE CongTerrid IS '$1'" >> SQLTemp.sql
echo " AND SubTerritory IS '$2'" >> SQLTemp.sql
echo " AND (DelPending IS NULL" >> SQLTemp.sql
echo "     OR DelPending IS 0);" >> SQLTemp.sql
# now write SQL for extracting header
echo ".open /media/ubuntu/Windows/Users/Bill/Documents/Cong-Files/Territories/DB/TerrIDData.db" >> SQLTemp.sql
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
echo "  SQL/QWholeSubTerr complete - .csv on file Terr$1.csv" >> $system_log #
echo "  SQL/QWholeSubTerr complete - .csv on file Terr$1.csv"

#!/bin/bash
# QGetTerr.sh - Get all territory records for passed territory id.
#	10/5/20.	wmk.	adapted from QGetSubTerr.sh
#	10/19/20.	wmk.	Territories folder moved up 2 levels
echo "-- BEGIN SQLTemp.sql" > SQLTemp.sql
echo ".open '/media/ubuntu/Windows/Users/Bill/Territories/DB/junk.db'" > SQLTemp.sql
echo "ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'" >> SQLTemp.sql
echo "||     '/DB/MultiMail.db'" >> SQLTemp.sql
echo " AS db3;" >> SQLTemp.sql
echo "ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'" >> SQLTemp.sql
echo "||     '/DB/TerrIDData.db'" >> SQLTemp.sql
echo " AS db4;" >> SQLTemp.sql
echo "ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'" >> SQLTemp.sql
echo "||     '/DB/PolyTerri.db'" >> SQLTemp.sql
echo " AS db5;" >> SQLTemp.sql
echo ".output Terr$1.csv" >> SQLTemp.sql
echo "SELECT TerrProps.* FROM TerrProps" >> SQLTemp.sql
echo " WHERE CongTerrid IS \"$1\" " >> SQLTemp.sql
echo " AND DelPending IS NOT 1" >> SQLTemp.sql
echo "UNION" >> SQLTemp.sql
echo "SELECT SplitProps.* FROM SplitProps" >> SQLTemp.sql
echo " WHERE CongTerrid IS \"$1\" " >> SQLTemp.sql
echo " AND DelPending IS NOT 1" >> SQLTemp.sql
echo "ORDER BY \"OwningParcel\";" >> SQLTemp.sql
echo "-- separate output for 2nd query" >> SQLTemp.sql
echo ".output Terr$1Hdr.csv" >> SQLTemp.sql
echo "SELECT \"TerrID\", \"AreaName\", \"Street-Address(s)\"," >> SQLTemp.sql
echo "	   \"City\", \"Zip\", \"Location\"," >> SQLTemp.sql
echo "	   \"StatusCode\" FROM Territory" >> SQLTemp.sql
echo "  WHERE TerrID IS \"$1\" ;" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
sqlite3 <SQLTemp.sql
echo "  QGetTerr complete - .csv on file Terr$1.csv" >> $system_log #
echo "  QGetTerr complete - .csv on file Terr$1.csv"


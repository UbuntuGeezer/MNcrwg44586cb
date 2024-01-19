echo "-- GondolaParkDr.sql - create GondolaParkDr.db from records from VeniceNTerritory." > SQLTemp.sql
-- * 5/28/22.	wmk.	(automated) *pathbase* integration.
echo "--	8/13/21.	wmk." >> SQLTemp.sql
echo ".open '$pathbase/RawData/SCPA/SCPA-Downloads/Special/GondolaParkDr.db'" >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/VeniceNTerritory.db'" >> SQLTemp.sql
echo "  AS db2;" >> SQLTemp.sql
echo ".output \"$pathbase/RawData/SCPA/SCPA-Downloads/Special/GondolaParkDr.csv\"" >> SQLTemp.sql
echo ".headers ON" >> SQLTemp.sql
echo ".mode csv" >> SQLTemp.sql
echo "select * from db2.nvenall" >> SQLTemp.sql
echo " where \"situs address (property address)\"" >> SQLTemp.sql
echo "  like \"%gondola park dr%\";" >> SQLTemp.sql
echo "DROP TABLE IF EXISTS GondolaParkDr;" >> SQLTemp.sql
echo ".import '$pathbase/RawData/SCPA/SCPA-Downloads/Special/GondolaParkDr.csv' GondolaParkDr" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql

echo "-- SetNewBridgeTerrs.s - set new special Bridge CongTerrID fields." > SQLTemp.sql
echo "--		4/24/22.	19:26;" >> SQLTemp.sql
echo ".open '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special/LPavia.db'" >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/PolyTerri.db'" >> SQLTemp.sql
echo " AS db5;" >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/MultiMail.db'" >> SQLTemp.sql
echo " AS db3;" >> SQLTemp.sql
echo "-- find matches in TerrProps;" >> SQLTemp.sql
echo "with a AS (select TRIM(UnitAddress) AS StreetAddr," >> SQLTemp.sql
echo " CongTerrID AS TerrNo FROM TerrProps " >> SQLTemp.sql
echo " where TerrNo IN (SELECT TerrID from TerrList))" >> SQLTemp.sql
echo "UPDATE Spec_RUBridge" >> SQLTemp.sql
echo "SET CongTerrID = (SELECT TerrNo FROM a " >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN TRIM(UNITADDRESS) IN (SELECT StreetAddr FROM a)" >> SQLTemp.sql
echo "THEN (SELECT TerrNo FROM a " >> SQLTemp.sql
echo " WHERE StreetAddr IS trim(UnitAddress))" >> SQLTemp.sql
echo "ELSE CongTerrID" >> SQLTemp.sql
echo "END " >> SQLTemp.sql
echo "WHERE trim(UnitAddress) IN (SELECT StreetAddr FROM a);" >> SQLTemp.sql
echo "-- now find matches in SplitProps;" >> SQLTemp.sql
echo "with a AS (select TRIM(UnitAddress) AS StreetAddr," >> SQLTemp.sql
echo " CongTerrID AS TerrNo FROM SplitProps " >> SQLTemp.sql
echo " where TerrNo IN (SELECT TerrID from TerrList))" >> SQLTemp.sql
echo "UPDATE Spec_RUBridge" >> SQLTemp.sql
echo "SET CongTerrID =" >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN TRIM(UNITADDRESS) IN (SELECT StreetAddr FROM a)" >> SQLTemp.sql
echo "THEN (SELECT TerrNo FROM a " >> SQLTemp.sql
echo " WHERE StreetAddr IS trim(UnitAddress))" >> SQLTemp.sql
echo "ELSE CongTerrID" >> SQLTemp.sql
echo "END " >> SQLTemp.sql
echo "WHERE trim(UnitAddress) IN (SELECT StreetAddr FROM a);" >> SQLTemp.sql
echo "-- end SetNewBridgeTerrs.sq;" >> SQLTemp.sql
echo "" >> SQLTemp.sql

echo "--RUGenMHPMap.sq - Generate pseudo MHP Map download.csv (template)." > SQLTemp.sql
echo "--	7/5/21.	wmk." >> SQLTemp.sql
echo "--" >> SQLTemp.sql
echo "-- * subquery list." >> SQLTemp.sql
echo "-- * --------------" >> SQLTemp.sql
echo "-- *;" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "-- ** RUGenMHPMap **********" >> SQLTemp.sql
echo "-- *	7/5/21.	wmk." >> SQLTemp.sql
echo "-- *--------------------------" >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * RUGenMHPMap - Generate pseudo MHP Map download.csv." >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * Entry DB and table dependencies." >> SQLTemp.sql
echo "-- *	Terr237_RU.db - as db12; from ./Previous folder" >> SQLTemp.sql
echo "-- *	  Terr237_MHP table - table of known a04resses from last download" >> SQLTemp.sql
echo "-- *		of terr237 from RU data " >> SQLTemp.sql
echo "-- *	RU<MHP-name>_07-04.db - as db19, full download of MHP as of 07-04" >> SQLTemp.sql
echo "-- *	  <MHP-name> table - full download table" >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * Exit DB and table results." >> SQLTemp.sql
echo "-- *	Map237_RU.csv - .csv of download data that corresponds to the" >> SQLTemp.sql
echo "-- *	  latest full RU download of the MHP." >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * Notes. The Terr237_MHP table records are in RU polygon map download" >> SQLTemp.sql
echo "-- * order so the fields House Number, Pre-Directional, Street, Street Suffix," >> SQLTemp.sql
echo "-- * and Post-Directional can be compared directly with the full download" >> SQLTemp.sql
echo "-- * to obtain the records for all the known a04resses in territory 237." >> SQLTemp.sql
echo "-- * A second pass over the full download using only Pre-Directional, Street, " >> SQLTemp.sql
echo "-- * Street Suffix, and Post-Directional can be done to find House Number" >> SQLTemp.sql
echo "-- * fields that are new since the last download, and these records can" >> SQLTemp.sql
echo "-- * be a04ed." >> SQLTemp.sql
echo "-- *;" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "-- * open junk as main;" >> SQLTemp.sql
echo ".open '/media/ubuntu/Windows/Users/Bill/Territories/DB-Dev/junk.db'" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "-- * attach ./Previous/Terr_RU.db as db12;" >> SQLTemp.sql
echo "ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'" >> SQLTemp.sql
echo "	|| 		'/RawData/RefUSA/RefUSA-Downloads/Terr237/Previous'" >> SQLTemp.sql
echo "	|| '/Terr237_RU.db'" >> SQLTemp.sql
echo "	AS db12;" >> SQLTemp.sql
echo "-- pragma db12.table_info(Terr237_MHP);" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "-- * attach full download of MHP;" >> SQLTemp.sql
echo "ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'" >> SQLTemp.sql
echo "	|| 		'/RawData/RefUSA/RefUSA-Downloads/Special/'" >> SQLTemp.sql
echo "	|| '/RUBayIndies_07-04.db'" >> SQLTemp.sql
echo "	AS db19;" >> SQLTemp.sql
echo "	pragma db19.table_info(BayIndies);" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "CREATE TEMP TABLE MHP_Recs" >> SQLTemp.sql
echo "( \"Last Name\" TEXT, \"First Name\" TEXT, \"House Number\" TEXT," >> SQLTemp.sql
echo " \"Pre-directional\" TEXT, Street TEXT, \"Street Suffix\" TEXT," >> SQLTemp.sql
echo "  \"Post-directional\" TEXT, \"Apartment Number\" TEXT, City TEXT," >> SQLTemp.sql
echo " State TEXT, \"ZIP Code\" TEXT, \"County Name\" TEXT," >> SQLTemp.sql
echo " \"Phone Number\" TEXT );" >> SQLTemp.sql
echo "with a AS (SELECT \"Pre-Directional\" AS PreDir, \"House Number\" AS HouseNo," >> SQLTemp.sql
echo "  Street AS StreetName, \"Street Suffix\" AS StreetType, " >> SQLTemp.sql
echo "  \"Post-Directional\" AS PostDir" >> SQLTemp.sql
echo "  FROM db12.Terr237_MHP)" >> SQLTemp.sql
echo " INSERT INTO MHP_Recs" >> SQLTemp.sql
echo " SELECT * FROM db19.BayIndies " >> SQLTemp.sql
echo "  WHERE \"Pre-directional\"||\"House Number\"||Street||\"Street Suffix\"" >> SQLTemp.sql
echo "	|| \"Post-Directional\"" >> SQLTemp.sql
echo "   IN (SELECT PreDir || HouseNo || StreetName || StreetType || PostDir" >> SQLTemp.sql
echo "    from a)" >> SQLTemp.sql
echo " ;" >> SQLTemp.sql
echo " --;" >> SQLTemp.sql
echo " --.headers ON;" >> SQLTemp.sql
echo " .separator ," >> SQLTemp.sql
echo " .mode csv" >> SQLTemp.sql
echo " .output '/media/ubuntu/Windows/Users/Bill/Territories/RawData/RefUSA/RefUSA-Downloads/Terr237/Map237_RU.csv'" >> SQLTemp.sql
echo " SELECT * FROM MHP_Recs;" >> SQLTemp.sql
echo " DROP TABLE MHP_Recs;" >> SQLTemp.sql
echo " --;" >> SQLTemp.sql
echo " --.quit;" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "-- ** END RUGenMHPMap **********;" >> SQLTemp.sql

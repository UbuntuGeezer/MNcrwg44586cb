#!/bin/bash
# RUNewTerr_2.sh - Process RefUSA new territory stage 2.
#	10/11/20.	wmk.
#	10/19/20.	wmk.	Territories folder moved up 2 levels
# RUNewTerr_2 - run sqlite performing phase 2 of processing RefUSA
#	download from .csv (Phase 1) into SQL table TerrProps
#	Usage. bash RUNewTerr_2 <terrid>
#		<terrid> = territory ID (e.g. 101)
# All Phase 2 operations involve generating an .sql batch directives
# file, then running sqlite to add new territory records to TerrProps
# table
date +%T >> $system_log #
echo "  RUNewTerr Phase 2 started." >> $system_log #
echo "  RUNewTerr Phase 2 started."
if [ -z $1 ]; then
  echo "  Territory id not specified... RUNewTerr_2 abandoned." >> $system_log #
  echo -e "Territory id must be specified...\nRUNewTerr_2 abandoned."
  exit 1
fi
touch $TEMP_PATH/scratchfile
error_counter=0
echo "-- SQLTemp.sql - RUNewTerr Phase 2." > SQLTemp.sql
echo ".open '/media/ubuntu/Windows/Users/Bill/Territories/DB/PolyTerri.db'" >> SQLTemp.sql
echo ".mode csv" >> SQLTemp.sql
echo ".separator ," >> SQLTemp.sql
echo ".import /media/ubuntu/Windows/Users/Bill/Territories/Intermediate-csvs/RefUSA-Downloads/Terr$1_Bridge.csv' TerrProps" >> SQLTemp.sql
echo "ATTACH '/media/ubuntu/Windows/Users/Bill/Territories" >> SQLTemp.sql
echo "||      '/DB/VeniceNTerritory.db'" >> SQLTemp.sql
echo " as db2; " >> SQLTemp.sql
echo "UPDATE TerrProps" >> SQLTemp.sql
echo " SET OwningParcel" >> SQLTemp.sql
echo "  = (SELECT \"Account #\" FROM NVenAll" >> SQLTemp.sql
echo "     WHERE NVenAll.\"Situs Address (Property Address)\"" >> SQLTemp.sql
echo "      = TerrProps.SitusAddress)" >> SQLTemp.sql
echo " WHERE CongTerrID IS \"$1\";" >> SQLTemp.sql
echo "-- END SQLTemp.sql --" >> SQLTemp.sql
# sqlite < SQLTemp.sql
date +%T >> $system_log #
echo "  RUNewTerr Phase 2 complete." >> $system_log #
echo "  RUNewTerr Phase 2 complete."

#!/bin/bash
#GenBTerrHdr.sh - Generate territory header .csv.
#	8/12/22.	wmk.
#
# bash GenBTerrHdr   <terrid>
#
#	<terrid> = territory ID
#
#	Entry Dependencies.
#   	TerrIDData.db - as main, Territory definitions
#
#	Exit Results.
#		../Territories/TerrData/Terr<terrid>/Working-Files/Terr<terrid>Hdr.csv
#			generated with territory header information
#
# Modification History.
# ---------------------
# 5/11/22.	wmk.	*pathbase* support.
# 8/12/22.	wmk.	change to use TerrData instead of BTerrData.
# Legacy mods.
# 9/24/21.	wmk.	original shell; adapted from GenTerrHdr; jumpto function
#					eliminated.
#
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
#
P1=$1
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
 cd $pathbase/Procs-Dev
fi
TEMP_PATH="$HOME/temp"
~/sysprocs/LOGMSG "  GenBTerrHdr $P1 started."
echo "  GenBTerrHdr $P1 started."
if [ -z "$P1" ]; then
  echo -e "Territory id must be specified...\nGenBTerrHdr abandoned."
  exit 1
fi
TID=$P1
F_1=Terr
F_2=Hdr.csv
F_3=Hdr.ods
if true ; then
TST_STR="(test)"
else
TST_STR=""
fi
touch $TEMP_PATH/scratchfile
error_counter=0
echo "-- SQLTemp.sql - RUNewTerr raw .csv to .db." > SQLTemp.sql
echo ".cd '$pathbase'" >> SQLTemp.sql
echo ".open \"./DB-Dev/TerrIDData.db\"" >> SQLTemp.sql
#echo ".trace 'Procs-Dev/SQLTrace.txt'" >> SQLTemp.sql
#pragma database_list;
echo ".headers on" >> SQLTemp.sql
echo ".mode csv" >> SQLTemp.sql
echo ".separator , " >> SQLTemp.sql
echo ".cd '$pathbase/TerrData'" >> SQLTemp.sql
echo ".cd './$F_1$TID/Working-Files'"  >> SQLTemp.sql
#echo ".cd './Working-Files'" >> SQLTemp.sql
echo ".output '$F_1$TID$F_2'" >> SQLTemp.sql
echo "SELECT * FROM Territory" >> SQLTemp.sql
echo " WHERE TerrID Is \"$TID\";" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
echo "SQLTemp.sql written..calling SQL"
sqlite3 < SQLTemp.sql
~/sysprocs/LOGMSG "  GenBTerrHdr $TID $TST_STR complete."
echo "  GenBTerrHdr $TID $TST_STR complete."
echo " ** BE SURE TO RUN CALC TO GENERATE $F_1$TID$F_3 **"
# end GenBTerrHdr

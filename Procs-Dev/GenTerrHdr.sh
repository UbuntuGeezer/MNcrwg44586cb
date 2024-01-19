#!/bin/bash
echo " ** GenTerrHdr.sh out-of-date **";exit 1
# GenTerrHdr.sh - Generate territory header .csv.
#	4/28/22.	wmk.
#
#	Usage. bash GenTerrHdr   <terrid> [<state> <county> <congno>]
#
#	<terrid> = territory ID
#	<state> = (optional) 2 char state abbreviation
#	<county> = (optional) 4 char county abbreviation
#	<congno> = (optional) congregation number
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
# 4/10/22.	wmk.	modified for <state> <county> <congno> support; HOME
#			 changed to USER in host test; *pathbase* env var support;
# 4/28/23.	wmk.	*pathabase conditional corrected.
#			 jumpto function eliminated.
# 8/8/22	wmk.	*pathbase support.
# Legacy mods.
# 1/6/21.	wmk.	original shell.
# 2/28/21.	wmk.	adapted for use with make utility.
# 5/30/21.	wmk.	modified for multihost system support.
# 6/17/21.	wmk.	bug fixes; ($)folderbase not substituted within ';
#					multihost code generalized; LOGMSG used.
# 8/29/21.	wmk.	remove superfluous Bay Indies notify; echo reminder
#					for user to use Calc to generate TerrxxxHdr.ods file.
# 10/29/21.	wmk.	add code to create TerrData/Terrxxx and Terrxxx/Working-Files
#					if non-existent.
#
#	Notes. This shell runs a query that will fix any Bay Indies territory.
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
P2=${2^^}
P3=${3^^}
P4=$4
if [ -z "$system_log" ]; then
 system_log="$folderbase/ubuntu/SystemLog.txt"
fi
TEMP_PATH="$HOME/temp"
if [ -z "$P1" ]; then
  ~/sysprocs/LOGMSG "  GenTerrHdr -Territory id not specified... abandoned."
  echo -e "Territory id must be specified...\nGenTerrHdr abandoned."
  exit 1
fi
if [ ! -z "$P2" ];then
 if [ -z "$P3" ] || [ -z "$P4" ];then
  echo "GenTerrHdr <terrid> <state> <county> <congno> missing paramter(s) - abandoned."
  exit 1
 fi
 if [ "$pathbase" != "$folderbase/Territories/$P2/$P3/$P4" ];then
  echo $pathbase
  echo -e "GenTerrHdr *pathbase* does not match $folderbase/Territories/$P2/$P3/$P4 - abandoned."
  exit 1
 fi
fi
~/sysprocs/LOGMSG "  GenTerrHdr started."
echo "  GenTerrHdr started."
TID=$P1
F_1=Terr
F_2=Hdr.csv
F_3=Hdr.ods
TST_STR=
if ! test -d $pathbase/TerrData/Terr$P1;then
 pushd ./ > $TEMP_PATH/scratchfile
 cd $pathbase/TerrData
 mkdir Terr$P1
 cd Terr$P1
 mkdir 'Working-Files'
 popd > $TEMP_PATH/scratchfile
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
~/sysprocs/LOGMSG "  GenTerrHdr $TST_STR  $P1 $P2 $P3 $P4 complete."
echo "  GenTerrHdr $TST_STR $P1 $P2 $P3 $P4 complete."
echo " ** BE SURE TO RUN CALC TO GENERATE $F_1$TID$F_3 **"
# end GenTerrHdr

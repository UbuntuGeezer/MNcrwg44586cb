#!/bin/bash
# NewTerrHdr.sh - Generate territory header .csv.
#	6/14/23.	wmk.
#
#	Usage. bash NewTerrHdr   <terrid> [-o]
#
#	<terrid> = territory ID
#	-o = (optional) overwrite current definition if exists in TerrIDData.
#
#	Entry Dependencies.
#   	/NewTerritory/NewTerrHdr.csv - template for new territory definition
#
#	Exit Results.
#		../Territories/TerrData/Terr<terrid>/Working-Files/Terr<terrid>Hdr.csv
#			generated with territory header information after Calc edit
#
# Modification History.
# ---------------------
# 6/3/23.	wmk.	original code; adapted from GenTerrHdr.
# 6/14.23.	wmk.	*spath to access soffice.bin	
# Legacy mods.
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
# Notes. This shell runs a query that will fix any Bay Indies territory.
#
# P1=<terrid> P2=[-o]
P1=$1
P2=${2^^}
if [ -z "$P1" ];then
 echo " NewTerrHdr <terrid> missing parameter(s) - abandoned."
 exit 1
fi
overwrite=0
if [ ! -z "$P2" ];then
 if [ "$P2" == "-O" ];then
  overwrite=1
 else
  echo " NewTerrHdr <terrid> -o unrecognized option $P2 - abandoned."
  exit 1
 fi
fi
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
if [ -z "$system_log" ]; then
 system_log="$folderbase/ubuntu/SystemLog.txt"
fi
TEMP_PATH="$HOME/temp"
if [ -z "$P1" ]; then
  ~/sysprocs/LOGMSG "  NewTerrHdr -Territory id not specified... abandoned."
  echo -e "Territory id must be specified...\nNewTerrHdr abandoned."
  exit 1
fi
~/sysprocs/LOGMSG "  NewTerrHdr started."
echo "  NewTerrHdr started."
projpath=$codebase/Projects-Geany/NewTerritory
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
sed "s?<terrid>?$TID?g" $projpath/NewTerrHdr.csv > $TEMP_PATH/NewTerrHdr.csv
$spath/soffice.bin $TEMP_PATH/NewTerrHdr.csv
if ! test -f $pathbase/TerrData/Terr$P1/Working-Files/$F_1$P1$F_2;then
 echo " ** ERROR - $F_1$P1$F_2 not in TerrData..."
 echo "  must be saved from Calc before continuing **"
 exit 1
else
 echo " $F_1$P1$F_2 saved in TerrData..."
fi
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
if [ $overwrite -ne 0 ];then
 echo " DELETE FROM Territory" >> SQLTemp.sql
 echo " WHERE TerrID IS \"$TID\";" >> SQLTemp.sql
fi
echo ".mode csv" >> SQLTemp.sql
echo ".headers on" >> SQLTemp.sql
echo ".separator ","" >> SQLTemp.sql
echo ".import '$F_1$TID$F_2' Territory" >> SQLTemp.sql
echo "DELETE FROM Territory" >> SQLTemp.sql
echo "WHERE TerrID is 'TerrID';" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
echo "SQLTemp.sql written..calling SQL"
sqlite3 < SQLTemp.sql
~/sysprocs/LOGMSG "  NewTerrHdr $P1 complete."
echo "  NewTerrHdr $P1 complete."
# end NewTerrHdr

#!/bin/bash
# UpdatePubTerrs.sh - Update out-of-date publisher territories.
# 6/6/23.	wmk.
#
# Usage. bash  UpdatePubTerrs.sh
#
# Entry. *pathbase/TerrData/Terrxxx/PubTerrxxx.ods files
#		 *pathbase/TerrData/Working-Files/QTerrxxx.ods files.
#		 *thisproj/autoload.tmp = autoload.csv template file.
#
# Dependencies.
#	date stamps on "Entry" files accurate.
#	*codebase/Projects-Geany/DoTerrsWithCalc/ProcessQTerrs12.ods exists.
#	calc libraries FLsara86777 and Territories set up in Calc.
#	LibreOffice installed on system.
#
# Modification History.
# ---------------------
# 6/6/23.	wmk.	OBSOLETE territory detection.
# Legacy mods.
# 2/1/23.	wmk.	original shell.
# 2/2/23.	wmk.	bug fix in old/new filenames comparison.
#
# Notes. UpdatePubTerrs cycles through all of the TerrData/Terrxxx folders
# comparing Working-Files/QTerrxxx.ods date with PubTerrxxx.ods date.
# If the QTerrxxx.ods date is newer, the PubTerrxxx.ods is considered
# out-of-date. The territory numbers of all out-of-date territories
# are placed in the $TEMP_PATH/autoload.csv file.
#
# autoload.csv contains 5 header lines followed by the list of territories
# to be processed by ProcessQTerrs.ods.
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  UpdatePubTerrs - initiated from Make"
  echo "  UpdatePubTerrs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  UpdatePubTerrs - initiated from Terminal"
  echo "  UpdatePubTerrs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
thisproj=$codebase/Projects-Geany/UpdatePubTerrs
# generate territory folder list.
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase/TerrData
ls -d Terr* > $TEMP_PATH/terrfolders.txt
popd > $TEMP_PATH/scratchfile
rm $thisproj/autoload.csv
cp $thisproj/autoload.tmp  $thisproj/autoload.csv
nterrs=0
# loop on territory folder list.
file=$TEMP_PATH/terrfolders.txt
while read -e;do
 echo "testing $REPLY.."
 TID=${REPLY:4:3}
 pubterrbase=Terr$TID
 pubterrsuffx=_PubTerr.ods
 skip=0
 if test -f $pathbase/TerrData/$TID/OBSOLETE;then
  skip=1
  echo " ** Territory $TID OBSOLETE - UpdatePubTerrs skipping..**"
 fi
 if [ $skip -eq 0 };then
  if [ $pathbase/TerrData/$REPLY/Working-Files/QTerr$TID.csv \
     -nt $pathbase/TerrData/$REPLY/$pubterrbase$pubterrsuffx ];then
   echo "$TID" >> $thisproj/autoload.csv
   nterrs=$((nterrs+1))
  fi	# end -nt test
 fi		# end skip=0
done < $file
echo "$" >> $thisproj/autoload.csv
echo "  $nterrs publisher territories out-of-date."
#endprocbody
echo "  UpdatePubTerrs.sh complete."
~/sysprocs/LOGMSG "  UpdatePubTerrs.sh complete."
# end UpdatePubTerrs.sh

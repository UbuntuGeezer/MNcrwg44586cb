#!/bin/bash
echo " ** FixAllProjPaths.sh out-of-date **";exit 1
echo " ** FixAllProjPaths.sh out-of-date **";exit 1
# FixAllProjPaths.sh - Fix all Make* files in all projects.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
#	9/24/22.	wmk.
#
# Usage.  bash FixAllProjPaths.sh 
#
# Calls.  FixAllMakePaths.
#
# Modification History.
# ---------------------
# 9/23/22.	wmk.	original code; adapted from FixAllSyncTerrs.sh
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 9/24/22.	wmk.	documentation added.
# Legacy mods.
# 6/14/22.	wmk.	original code; adapted from FixAllMakeSpecials.
# 9/21/22.	wmk.	modified for Chromebook.
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FixAllProjPaths - initiated from Make"
  echo "  FixAllProjPaths - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllProjPaths - initiated from Terminal"
  echo "  FixAllProjPaths - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/MigrationRepairs
cd $codebase/Projects-Geany
ls -lh > $TEMP_PATH/ProjList.txt
# loop on BatchList.txt...
cd $projpath
if [ 1 -eq 1 ];then	   # skip full list until debugged..
mawk '/drw/ {print $9}' $TEMP_PATH/ProjList.txt > $projpath/ProjList.txt
fi
file=$projpath/ProjList.txt
while read -e;do
 len=${#REPLY}
 fpath=$REPLY
 $projpath/FixAllMakePaths.sh $codebase/Projects-Geany/$fpath 
done < $file
#end proc body.
~/sysprocs/LOGMSG "  FixAllProjPaths complete."
echo "  FixAllProjPaths complete."
# end FixAllProjPaths.sh

#!/bin/bash
echo " ** FixAllMakePaths.sh out-of-date **";exit 1
echo " ** FixAllMakePaths.sh out-of-date **";exit 1
# FixAllMakePaths.sh - Fix all .sh files on <shellpath>.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
#	9/23/22.	wmk.
#
# Usage.  bash FixAllMakePaths.sh <shellpath> 
#
#	<shellpath> = path to shell files 
#				(e.g. *pathbase*/Procs-Dev)
#
# Calls. FixMakePaths.
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
P1=$1		# shells path
if [ -z "$P1" ];then
 echo "FixAllMakePaths <shellpath>  missing parameter(s) - abandoned."
 exit 1
fi
if ! test -d $P1;then
 echo "FixAllMakePaths path '$P1' does not exist - abandoned."
 exit 1
fi
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
  ~/sysprocs/LOGMSG "  FixAllMakePaths - initiated from Make"
  echo "  FixAllMakePaths - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllMakePaths - initiated from Terminal"
  echo "  FixAllMakePaths - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/MigrationRepairs
cd $P1
ls -lh Make* > $TEMP_PATH/BatchList.txt
# loop on BatchList.txt...
cd $projpath
mawk '{print $9}' $TEMP_PATH/BatchList.txt > $projpath/BatchList.txt
pushd ./
cd $P1
file=$projpath/BatchList.txt
while read -e;do
 len=${#REPLY}
 fn=$REPLY
  echo "processing $fn ..."
  $projpath/FixMakePaths.sh $fn 
done < $file
popd
#end proc body.
~/sysprocs/LOGMSG "  FixAllMakePaths $P1 complete."
echo "  FixAllMakePaths $P1 complete."
# end FixAllMakePaths.sh

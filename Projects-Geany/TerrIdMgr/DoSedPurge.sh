#!/bin/bash
# DoSedPurge.sh - perform *sed edits for TerrIdMgr Purge operation.
# 6/e/23.	wmk.
#
# Usage. bash  DoSedPurge.sh <terrid>
#
#	<terrid> = territory id to add
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 6/2/23.	wmk.	original shell.
# 6/3/23.	wmk.	Purgatory.psq, PurgeSpecial.psq, CheckTerrIDData.psq added.
#
# Notes. 
#
# set parameters P1=<terrid>
#
P1=$1
if [ -z "$P1" ];then
 echo "DoSedPurge <terrid> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  DoSedPurg - initiated from Make"
  echo "  DoSedPurge - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DoSedPurg - initiated from Terminal"
  echo "  DoSedPurge - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
sed "s?yyy?$P1?g" MakePurgeTerr.tmp > MakePurgeTerr
sed "s?yyy?$P1?g" Purgatory.psq > Purgatory.sql
sed "s?yyy?$P1?g" CheckTerrIDData.psq > CheckTerrIDData.sql
sed "s?yyy?$P1?g" PurgeSpecial.psq > PurgeSpecial.sql
#endprocbody
echo "  DoSedPurge complete."
~/sysprocs/LOGMSG "  DoSedPurge complete."
# end DoSedPurge.sh

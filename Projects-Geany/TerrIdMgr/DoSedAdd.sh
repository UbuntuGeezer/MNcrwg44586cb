#!/bin/bash
# DoSedAdd.sh - perform *sed edits for TerrIdMgr Add operation.
# 6/2/23.	wmk.
#
# Usage. bash  DoSedAdd.sh <terrid>
#
#	<terrid> = territory id to add
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 6/2/23.	wmk.	original shell (template)
#
# Notes. 
#
# set parameters P1=<terrid>
#
P1=$1
if [ -z "$P1" ];then
 echo "DoSedAdd <terrid> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  DoSedAdd - initiated from Make"
  echo "  DoSedAdd - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DoSedAdd - initiated from Terminal"
  echo "  DoSedAdd - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
sed "s?yyy?$P1?g" MakeAddTerr.tmp > MakeAddTerr
#endprocbody
echo "  DoSedAdd complete."
~/sysprocs/LOGMSG "  DoSedAdd complete."
# end DoSedAdd.sh

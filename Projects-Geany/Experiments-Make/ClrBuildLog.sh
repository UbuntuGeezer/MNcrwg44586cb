#!/bin/bash
# ClrBuildLog.sh - <description>.
# 2/2/23.	wmk.
#
# Usage. bash  ClrBuildLog.sh
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes. 
#
# set parameters P1..Pn here..
#
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
  ~/sysprocs/LOGMSG "  ClrBuildLog - initiated from Make"
  echo "  ClrBuildLog - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ClrBuildLog - initiated from Terminal"
  echo "  ClrBuildLog - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
rm -v $TEMP_PATH/BuildLog.txt
#endprocbody
echo "  ClrBuildLog complete."
~/sysprocs/LOGMSG "  ClrBuildLog complete."
# end ClrBuildLog.sh

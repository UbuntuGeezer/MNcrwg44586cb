#!/bin/bash
echo " ** ShellDesc.sh out-of-date **";exit 1
# ShellDesc.sh - List shell description from header.
# 6/14/23.	wmk.
#
# Usage. bash  ShellDesc.sh
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 6/14/23.	wmk.	original shell (template)
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
if [ -z "$P1" ];then
 echo "ShellDesc <shfile> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  ShellDesc - initiated from Make"
  echo "  ShellDesc - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ShellDesc - initiated from Terminal"
  echo "  ShellDesc - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
sed -n '2p' $P1
#endprocbody
echo "  ShellDesc complete."
~/sysprocs/LOGMSG "  ShellDesc complete."
# end ShellDesc.sh

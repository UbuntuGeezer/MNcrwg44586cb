#!/bin/bash
# 2023-09-01   wmk.   (automated) ver2.0 path fixes.
# lstoday.sh - List files changed today from folder.
# 7/8/23.	wmk.
#
# Usage. bash  lstoday.sh [<path>]
#
#	<path> = (optional) path to check for today files.
#
# Entry. 
#
# Calls.	SetToday.
#
# Modification History.
# ---------------------
# 7/8/23.	wmk.	original shell.
# 9/1/23.	wmk.	(automated) ver2.0 path fixes.
# 9/3/23.	wmk.	path fixes for MNcrwg44586.
#
# Notes. 
#
# P1=<path>
#
export P1=$1
if [ -z "$P1" ];then
 export P1=$PWD
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/MN/CRWG/44586
fi
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  lstoday - initiated from Make"
  echo "  lstoday - initiated from Make"
else
  ~/sysprocs/LOGMSG "  lstoday - initiated from Terminal"
  echo "  lstoday - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . $codebase/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
ls -lh $P1 | mawk '{if( $6 == ENVIRON["TODAY"])print;;}'
#endprocbody
echo "  lstoday complete."
~/sysprocs/LOGMSG "  lstoday complete."
# end lstoday.sh

#!/bin/bash
# CountFiles.sh - <description>.
# 6/2/23.	wmk.
#
# Usage. .  CountFiles.sh <path>
#
# Entry. 
#
# Exit. *numfiles = count of files in <path>
#				  = -1 if path does not exist
#
# Dependencies.
#
# Modification History.
# ---------------------
# 6/2/23.	wmk.	original shell.
#
# Notes. Since CountFiles is run through *bash, in order to preserve the value
# of *numfiles back to the calling shell, run CountFiles using the . (dot) command.
#
# P1=<path>
#
P1=$1
if [ -z "$P1" ];then
 echo "CountFiles <path> missing parameter(s) - using *PWD."
 P1=$PWD
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
  ~/sysprocs/LOGMSG "  CountFiles - initiated from Make"
  echo "  CountFiles - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CountFiles - initiated from Terminal"
  echo "  CountFiles - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
if ! test -d $P1;then
 numfiles=-1
else
 shopt -s nullglob
 numfiles=(*)
 numfiles=${#numfiles[@]}
 numdirs=(*/)
 numdirs=${#numdirs[@]}
 (( numfiles -= numdirs ))
fi
#endprocbody
exit $numfiles
echo "  CountFiles complete."
~/sysprocs/LOGMSG "  CountFiles complete."
# end CountFiles.sh

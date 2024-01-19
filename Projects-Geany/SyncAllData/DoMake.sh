#!/bin/bash
echo " ** DoMake.sh out-of-date **";exit 1
echo " ** DoMake.sh out-of-date **";exit 1
# DoMake.sh - run *make with traps on any SyncAllData makefile.
#	5/20/23.	wmk.
#
# Usage. bash  DoMake.sh  <makefile>
#
#	<makefile> = makefile name
#
# Entry. *PWD/<makefile> = makefile for anything SyncAllData related
#
# Dependencies.
#
# Exit.	<makefile> executed
#
# Modification History.
# ---------------------
# 5/20/23.	wmk.	original shell; adapted from DoSed.
# Legacy mods.
# 2/4/23.	wmk.	original shell.
# 2/5/23.	wmk.	modified to edit MakeSyncAllData.tmp
# 2/16/23.	wmk.	<start-tid>, <end-tid> support; documentation improved.
# 2/19/23.	wmk.	MakePubTerr added to edit list; .tmp suffixes removed
#			 from *sed target file headers.
#
# Notes. DoMake runs any makefile with trap protection. Trap protection
# allows the makefile to use the two-line sequence:
#	cmd=$previous_command ret=$?
#	if [ $ret -ne 0 ];then <error handling>
# to handle trapped errors.
#
# set parameters P1..Pn here..
trap 'previous_command=$current_command;current_command=$BASH_COMMAND' DEBUG
P1=$1
if [ -z "$P1" ];then
 echo "DoMake <makefile> missing parameter(s) - abandoned."
 exit 1
fi
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
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  DoMake - initiated from Make"
  echo "  DoMake - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DoMake - initiated from Terminal"
  echo "  DoMake - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
make -f $PWD/$P1
cmd=$previous_command ret=$?
if [ $ret -ne 0 ];then echo "DoMake/$P1 blew up.. error = $ret";fi
#endprocbody
echo "  DoMake complete."
~/sysprocs/LOGMSG "  DoMake complete."
# end DoMake.sh

#!/bin/bash
# DoSed.sh - *sed for Experiments-Make files.
# 5/12/23.	wmk.
#
# Usage. bash  DoSed.sh
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 5/12/23.	wmk.	original shell (template)
#
# Notes. 
#
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
# set parameters P1..Pn here..
#
export mypid=$$
export projpath=$PWD
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 $projpath/BLDMSG "  Error initiated by:"
 ps $mypid | mawk '{print "  " $0}' >> $TEMP_PATH/BuildLog.txt
 errcode=1
 jumpto ErrHandler
 #$projpath/BLDMSG "DoSed <mm> <dd> missing parameter(s) - abandoned."
 #echo "DoSed <mm> <dd> missing parameter(s) - abandoned." >> $TEMP_PATH/BuildErrors.txt
 echo "DoSed <mm> <dd> missing parameter(s) - abandoned." 
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
  ~/sysprocs/LOGMSG "  DoSed - initiated from Make"
  echo "  DoSed - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DoSed - initiated from Terminal"
  echo "  DoSed - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere

#endprocbody
echo "  DoSed complete."
~/sysprocs/LOGMSG "  DoSed complete."
exit 0
jumpto ErrHandler
ErrHandler:
 echo "** DoSed error handler..."
 ./BLDMSG "DoSed parent info follows..."
 grep PPid /proc/$$/task/$$/status >> $TEMP_PATH/BuildLog.txt
echo " DoSed pid = " $mypid  "error: " $mkerr
exit $errcode
# end DoSed.sh

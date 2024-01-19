#!/bin/bash
echo " ** FixCBPaths.sh out-of-date **";exit 1
echo " ** FixCBPaths.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# FixCBPaths.sh - Fix CBPaths in territory makefile.
# 9/22/22.	wmk.
#
# Modification History.
# ---------------------
# 9/22/22.	wmk.	original code for Chromebook.
#
P1=$1
if [ -z "$P1" ];then
 echo "FixCBPaths  <makefile> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  FixCBPaths - initiated from Make"
  echo "  FixCBPaths - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixCBPaths - initiated from Terminal"
  echo "  FixCBPaths - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#beginprocbpdy
projpath=$codebase/Projects-Geany/MigrationRepairs
RUpath=$codebase/Projects-Geany/$P1
grep -e "automated) *codebase" $RUpath
if [ $? -eq 0 ];then
 echo "$RUPATH/CBPaths already fixed - skipped."
 exit 0
fi
mawk -f awkaddcodebase.txt $RUPath > $TEMP_PATH/$P1
mawk -f awkfixpathbase.txt $TEMP_PATH/P1 > $RUPath
#endprocbody
echo "  FixCBPaths $P1 $P2 complete."
~/sysprocs/LOGMSG "  FixCBPaths $P1 $P2 complete."
# end FixCBPaths


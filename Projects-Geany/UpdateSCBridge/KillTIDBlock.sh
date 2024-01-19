#!/bin/bash
echo " ** KillTIDBlock.sh out-of-date **";exit 1
# KillTIDBlock - comment out block of territory IDs in TIDList.txt.
#	11/23/22.	wmk.
#
# Usage. bash  KillTIDBlock.sh <1st-digit> | <digit-range>
#
#	<1st-digit> = first digit of territories to deactivate in TIDList.txt
#	<digit-range> = range of first digits to deactivate (e.g. 1-6)
#
# Entry. UpdateSCBridge/TIDList.txt = current TID list for processing. 
#
# Exit.	UpdateSCBridge.TIDList.txt = modified TID list with block deactivated
#		 '#' inserted in all lines beginning with <1st-digit>
#
#		UpdateSCBridge.TIDList.bak = TIDList.txt from Entry.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes. 
#
P1=$1
if [ -z "$P1" ];then
 echo "KillTIDBlock <1st-digit> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
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
  ~/sysprocs/LOGMSG "  <filename> - initiated from Make"
  echo "  <filename> - initiated from Make"
else
  ~/sysprocs/LOGMSG "  <filename> - initiated from Terminal"
  echo "  <filename> - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
sed "s?<dig>?$P1?g" awkfixTIDs.tmp > awkfixTIDs.txt
mawk -f awkfixTIDs.txt TIDList.txt > $TEMP_PATH/TIDList.tmp
cp -pv TIDList.txt TIDList.bak
cp -pv $TEMP_PATH/TIDList.tmp TIDList.txt
#endprocbody
echo "KillTIDBlock complete."
echo " TIDList.txt has '$P1' block commented/removed."
~/sysprocs/LOGMSG "  <filename> complete."
# end KillTIDBlock.sh.

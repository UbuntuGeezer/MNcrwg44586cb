#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 1/24/23.	wmk.
#	Usage. bash AddMultiSCBridgeRec.sh <terrid>
#
#	<terrid> = territory id
#		
# Entry. *projpath/PIDList.txt = list of property IDs to add.
#
# Modification History.
# ---------------------
# 3/12/23.	wmk.	original code; adapted from AddRangeSCBridgeRec.
# Legacy mods.
# 1/24/23.	wmk.	parameter list added to log messages.
# Legacy Mods.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# 12/11/22.	wmk.	run SetToday.sh to export TODAY env var.
# 12/12/22.	wmk.	SetTody.sh path corrected.
# Legacy mods.
# 4/23/22.	wmk.	modified for FL/SARA/86777.
# 4/22/22.	wmk.	HOME changed to USER in host check.
# Legacy mods.
# 4/6/21.	wmk.	original shell (template)
# 6/17/21.	wmk.	multihost support.
# 9/6/21.	wmk.	jumpto function and references removed.
# 11/9/21.	wmk.	add echo when initiated from make; add $ TODAY definition.
# 12/3/21.	wmk.	'procbodyhere' replaces proc body here for awk reversal.
# 4/8/22.	wmk.	HOME changed to USER in host test.	
P3=$1		# territory id
if [ -z "$P3" ];then
 echo "AddMultiSCBridgeRec <terrid> missing parameter(s) - abandoned."
 exit 1
fi
TN="Terr"
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
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  AddMultiSCBridgeRec $P3 - initiated from Make"
  echo "  AddMultiSCBridgeRec - initiated from Make"
else
  ~/sysprocs/LOGMSG "  AddMultiSCBridgeRec $P3 - initiated from Terminal"
  echo "  AddMultiSCBridgeRec - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere
thisproj=$codebase/Projects-Geany/AddSCBridgeRecord
# loop on project DoSed and *make* for all property ids after gnerating list.
#seq $P1 $P2 > $TEMP_PATH/PropList.txt
cp -pv $thisproj/PIDList.txt $TEMP_PATH/PropList.txt
addcount=0
file=$TEMP_PATH/PropList.txt
pushd ./ $TEMP_PATH/scratchfile
cd $thisproj
while read -e; do
 len=${#REPLY}
 frstchar=${REPLY:0:1}
 if [ "$frstchar" == "\$" ];then break;fi
 skipit=0
 if [ "$frstchar" == "#" ] || [ $len -eq 0 ];then skipit=1;fi
 if [ $skipit -eq 0 ];then echo "Adding property ID $REPLY..."
  if [ $len -lt 10 ];then
    PID=0$REPLY
  else
    PID=$REPLY
  fi
  ./DoSed.sh $PID $P3
  make -f MakeAddSCBridgeRecord
  addcount=$(($addcount+1))
 fi		# end skipit
done < $file
#endprocbody
sqlite3 < SQLTemp.sql
echo "  PIDList.txt processed (list of property IDs to add).."
echo "  $addcount records added."
echo "  AddMultiSCBridgeRec $P3 complete."
~/sysprocs/LOGMSG "  AddMultiSCBridgeRec $P3 complete."
#end proc

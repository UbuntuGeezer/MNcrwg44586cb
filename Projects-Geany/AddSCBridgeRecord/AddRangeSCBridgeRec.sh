#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 1/24/23.	wmk.
#	Usage. bash AddRangeSCBridgeRec.sh <propLB> <propUB> <terrid>
#
#	<propLB> = lower bound property ID
#	<propUP> = upper bound property ID
#	<terrid> = territory id
#		
# Dependencies.
#
#
# Modification History.
# ---------------------
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
P1=$1		# lower bound prop ID
P2=$2		# upper bound prop ID
P3=$3		# territory id
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "AddRangeSCBridgeRec <lower-bound> <upper-bound> <terrid> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  AddRangeSCBridgeRec $P1 $P2 $P3 - initiated from Make"
  echo "  AddRangeSCBridgeRec - initiated from Make"
else
  ~/sysprocs/LOGMSG "  AddRangeSCBridgeRec $P1 $P2 $P3 - initiated from Terminal"
  echo "  AddRangeSCBridgeRec - initiated from Terminal"
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
seq $P1 $P2 > $TEMP_PATH/PropList.txt
file=$TEMP_PATH/PropList.txt
pushd ./ $TEMP_PATH/scratchfile
cd $thisproj
while read -e; do
 echo "Adding property ID 0$REPLY..."
 PID=0$REPLY
 ./DoSed.sh $PID $P3
 make -f MakeAddSCBridgeRecord
done < $file
#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  AddRangeSCBridgeRec $P1 $P2 $P3 complete."
~/sysprocs/LOGMSG "  AddRangeSCBridgeRec $P1 $P2 $P3 complete."
#end proc

#!/bin/bash
echo " ** ClearRUBridge.sh out-of-date **";exit 1
echo " ** ClearRUBridge.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 7/9/22.	wmk.
#	Usage. bash ClearRUBridge.sh
#		
# Dependencies.
#	(leave line count the same)
#
# Modification History.
# ---------------------
# 4/23/22.	wmk.	modified for FL/SARA/86777.
# 4/22/22.	wmk.	HOME changed to USER in host check.
# 7/9/22.	wmk.	change to require territory ID.	
# Legacy mods.
# 4/6/21.	wmk.	original shell (template)
# 6/17/21.	wmk.	multihost support.
# 9/6/21.	wmk.	jumpto function and references removed.
# 11/9/21.	wmk.	add echo when initiated from make; add $ TODAY definition.
# 12/3/21.	wmk.	'procbodyhere' replaces proc body here for awk reversal.
# 4/8/22.	wmk.	HOME changed to USER in host test.	
P1=$1
if [ -z "$P1" ];then
 echo "ClearRUBridge <terrid> missing parameter(s) - abandoned."
 exit 1
fi
TID=$P1
TN="Terr"
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
  ~/sysprocs/LOGMSG "  ClearRUBridge - initiated from Make"
  echo "  ClearRUBridge - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ClearRUBridge - initiated from Terminal"
  echo "  ClearRUBridge - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 TODAY=2022-04-22
fi
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere

echo "-- ClearRUBridge.psq - Clear RUBridge table in territory 273."  > SQLTemp.sql
echo "-- *	7/9/22.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 10/20/21.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 7/9/22.	wmk.	*pathbase support."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/RawData/RefUSA/RefUSA-Downloads/$NAME_BASE$TID/$NAME_BASE$TID$RU_DB'"  >> SQLTemp.sql
echo "DELETE FROM $NAME_BASE$TID$RU_SUFFX;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- * end ClearRUBridge.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  ClearRUBridge complete."
~/sysprocs/LOGMSG "  ClearRUBridge complete."
#end proc

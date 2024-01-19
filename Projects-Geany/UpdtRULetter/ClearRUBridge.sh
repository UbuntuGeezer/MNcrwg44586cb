#!/bin/bash
echo " ** ClearRUBridge.sh out-of-date **";exit 1
echo " ** ClearRUBridge.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 6/17/21.	wmk.
#	Usage. bash ClearRUBridge.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
# 4/6/21.	wmk.	original shell (template)
# 6/17/21.	wmk.	multihost support.
# 9/6/21.	wmk.	jumpto function and references removed.
P1=$1
TID=$P1
TN="Terr"
if [ "$HOME" == "/home/ubuntu" ]; then
 folderbase=/media/ubuntu/Windows/Users/Bill
else
 folderbase=$HOME
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH="$folderbase/temp"
  ~/sysprocs/LOGMSG "  ClearRUBridge - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ClearRUBridge - initiated from Terminal"
  echo "  ClearRUBridge - initiated from Terminal"
fi 
#	Environment vars:
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#proc body here

echo "-- ClearRUBridge.psq - Clear RUBridge table in territory 612."  > SQLTemp.sql
echo "--		10/20/21.	wmk."  >> SQLTemp.sql
echo ".open '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Terr612/Terr612_RU.db'"  >> SQLTemp.sql
echo "DELETE FROM Terr612_RUBridge;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- end ClearRUBridge.sql"  >> SQLTemp.sql

#end proc body
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
#notify-send "ClearRUBridge.sh" "ClearRUBridge processing complete. $P1"
echo "  ClearRUBridge complete."
~/sysprocs/LOGMSG "  ClearRUBridge complete."
#end proc

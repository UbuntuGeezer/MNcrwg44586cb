#!/bin/bash
echo " ** DiffsToNVenAll.sh out-of-date **";exit 1
echo " ** DiffsToNVenAll.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/30/21.	wmk.
#	Usage. bash DiffsToNVenAll.sh
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
# 11/9/21.	wmk.	add echo when initiated from make; add $ TODAY definition.
# 12/3/21.	wmk.	'procbodyhere' replaces proc body here for awk reversal.
# 12/30/21.	wmk.	$ HOME changed to USER; TODAY env var export removed.
P1=$1
TID=$P1
TN="Terr"
if [ "$USER" == "ubuntu" ]; then
 folderbase=/media/ubuntu/Windows/Users/Bill
else
 folderbase=$HOME
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH="$folderbase/temp"
  ~/sysprocs/LOGMSG "  DiffsToNVenAll - initiated from Make"
  echo "  DiffsToNVenAll - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DiffsToNVenAll - initiated from Terminal"
  echo "  DiffsToNVenAll - initiated from Terminal"
fi 
#	Environment vars:
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere


#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
#notify-send "DiffsToNVenAll.sh" "DiffsToNVenAll processing complete. $P1"
echo "  DiffsToNVenAll complete."
~/sysprocs/LOGMSG "  DiffsToNVenAll complete."
#end proc

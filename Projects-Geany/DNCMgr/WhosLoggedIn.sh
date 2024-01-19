#!/bin/bash
# WhosLoggedIn.sh - Set *adminwho env var to initials of logged in administrator.
# 6/8/23.	wmk.
#
# Usage. bash  WhosLoggedIn.sh
#
# Entry. 
#
# Exit. *adminwho = Admin.initials from TerrIDData.db 
#
# Modification History.
# ---------------------
# 6/8/23.	wmk.	original shell.
# 6/14/23.	wmk.	header updated
#
# Notes. 
#
# set parameters P1..Pn here..
#
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
  ~/sysprocs/LOGMSG "  WhosLoggedIn - initiated from Make"
  echo "  WhosLoggedIn - initiated from Make"
else
  ~/sysprocs/LOGMSG "  WhosLoggedIn - initiated from Terminal"
  echo "  WhosLoggedIn - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
echo ".open '$pathbase/DB-Dev/TerrIDData.db'" > SQLTemp.txt
echo ".mode list" >> SQLTemp.txt
echo ".headers off"  >> SQLTemp.txt
echo ".output '$TEMP_PATH/adminwho.txt'"  >> SQLTemp.txt
echo "SELECT initials FROM Admin LIMIT 1;"  >> SQLTemp.txt
echo ".quit"  >> SQLTemp.txt
#endprocbody
sqlite3 < SQLTemp.txt
file=$TEMP_PATH/adminwho.txt
while read -e;do
 adminwho=$REPLY
done < $file
#adminwho=$REPLY
echo "  WhosLoggedIn complete."
~/sysprocs/LOGMSG "  WhosLoggedIn complete."
# end WhosLoggedIn.sh

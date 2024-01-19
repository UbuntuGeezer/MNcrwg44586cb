#!/bin/bash
# Logout.sh - Log out Administrator.
# 6/8/23.	wmk.
#
# Usage. bash  Logout.sh <initials>
#
#	<initials> = initials of administrator logging in
#
# Entry.	/DB-Dev/TerrIDData.db.DNCLog has DoNotCalls change log. 
#
# Dependencies.
#
# Exit.	*TEMP_PATH/DNCLog.txt is all DNC log entries.
#
# Modification History.
# ---------------------
# 6/1/23.	wmk.	original shell; adapted from GetDNCList;
# 6/2/23.	wmk.	editing complete.
# 6/14/23.	wmk.	header corrected.
#
# Notes. P1 = initials of administrator logging in 
#
P1=$1
if [ -z "$P1" ];then
 echo "Logout <initials> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  Logout - initiated from Make"
  echo "  Logout - initiated from Make"
else
  ~/sysprocs/LOGMSG "  Logout - initiated from Terminal"
  echo "  Logout - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
echo "-- * Logout.sql - Get DNC property ID given UnitAddress, Unit."  > SQLTemp.sql
echo "-- * 6/8/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry.	/DB-Dev/TerrIDData.ArchivedDNCs = table or archived DoNotCalls"  >> SQLTemp.sql
echo "-- *				TerrIDData.DoNotCalls = table of DoNotCalls"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Dependencies. < terrid > and < initials > fields replaced by DoSedRecover.sh"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit.	/DB-Dev/TerrIDData.ArchivedDNCs = updated with DoNotCalls"  >> SQLTemp.sql
echo "-- *	added from DoNotCalls table < terrid >"  >> SQLTemp.sql
echo "-- *	DoNotCalls table records < terrid > marked for deletion"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 6/8/23.	wmk.	original code; adapted from GetDNCLog"  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 5/31/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 6/1/23.	wmk.	bug fix check for DelPending <> 1."  >> SQLTemp.sql
echo "-- * 6/1/23.	wmk.	use TerrIDData.db."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. The archiving process takes all of the DoNotCalls for a given territory"  >> SQLTemp.sql
echo "-- * ID and places them in the ArchivedDNCs table."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo "INSERT INTO DNCLog(Timestamp,LogMsg)"  >> SQLTemp.sql
echo "SELECT CURRENT_TIMESTAMP,'Admin logged out.' || initials FROM Admin;"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo "UPDATE Admin"  >> SQLTemp.sql
echo "SET initials = '';"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
#endprocbody
sqlite3 < SQLTemp.sql
adminwho=
echo "  Logout complete - *admnwho cleared."
~/sysprocs/LOGMSG "  Logout complete."
# end Logout.sh

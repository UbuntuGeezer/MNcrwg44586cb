#!/bin/bash
# Login.sh - Log in Administrator.
# 6/8/23.	wmk.
#
# Usage. . Login.sh <initials>
#
#	<initials> = initials of administrator logging in
#	Note. execute with '.' so *TODAY gets set to current date.
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
# 6/14/23.	wmk.	unconditionally set *TODAY
#
# Notes. P1 = initials of administrator logging in 
#
P1=$1
if [ -z "$P1" ];then
 echo "Login <initials> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  Login - initiated from Make"
  echo "  Login - initiated from Make"
else
  ~/sysprocs/LOGMSG "  Login - initiated from Terminal"
  echo "  Login - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY= today's date.
#procbodyhere
echo "-- * Login.sql - Get DNC property ID given UnitAddress, Unit."  > SQLTemp.sql
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
echo "UPDATE Admin"  >> SQLTemp.sql
echo "SET initials = '$P1';"  >> SQLTemp.sql
echo "INSERT INTO DNCLog(Timestamp,LogMsg)"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo "SELECT CURRENT_TIMESTAMP,'Admin logged in.' || initials FROM Admin;"  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
#endprocbody
sqlite3 < SQLTemp.sql
adminwho=$P1
echo " Login complete $adminwho."
echo "  Login complete."
~/sysprocs/LOGMSG "  Login complete."
# end Login.sh


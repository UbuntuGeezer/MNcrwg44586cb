#!/bin/bash
# GetAddrPID.sh - Get DNC Property ID given unitaddress, unit.
# 6/1/23.	wmk.
#
# Usage. bash  GetAddrPID.sh
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 6/1/23.	wmk.	original shell (template)
#
# Notes. 
#
# set parameters P1=<unitaddress, P2=<unit>.
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "GetAddrPID <unitaddress> <unit> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  GetAddrPID - initiated from Make"
  echo "  GetAddrPID - initiated from Make"
else
  ~/sysprocs/LOGMSG "  GetAddrPID - initiated from Terminal"
  echo "  GetAddrPID - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
echo "-- * GetAddrPID.sql - Get DNC property ID given UnitAddress, Unit."  > SQLTemp.sql
echo "-- * 6/1/23.	wmk."  >> SQLTemp.sql
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
echo "-- * 5/31/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 6/1/23.	wmk.	bug fix check for DelPending <> 1."  >> SQLTemp.sql
echo "-- * 6/1/23.	wmk.	use TerrIDData.db."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. The archiving process takes all of the DoNotCalls for a given territory"  >> SQLTemp.sql
echo "-- * ID and places them in the ArchivedDNCs table."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- find matching unitaddress, unit;" >> SQLTemp.sql
echo "SELECT \"Account #\"," >> SQLTemp.sql
echo  "TRIM(SUBSTR(\"situs address (property address)\",1,35)) UnitAddress," >> SQLTemp.sql
echo  "TRIM(SUBSTR(\"situs address (property address)\",35)) Unit "  >> SQLTemp.sql
echo "FROM Terr86777"  >> SQLTemp.sql
echo "WHERE UnitAddress LIKE  '%$P1%'"  >> SQLTemp.sql
if [ "$P2" != " " ];then
 echo " AND Unit LIKE '%$P2%'; "  >> SQLTemp.sql
else
 echo ";" >> SQLTemp.sql
fi
echo ""  >> SQLTemp.sql
#endprocbody
sqlite3 < SQLTemp.sql
echo "  GetAddrPID complete."
~/sysprocs/LOGMSG "  GetAddrPID complete."
# end GetAddrPID.sh

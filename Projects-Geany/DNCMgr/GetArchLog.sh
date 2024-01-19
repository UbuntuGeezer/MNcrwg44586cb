#!/bin/bash
# GetArchLog.sh - List DNC archive log to *TEMP_PATH/ArchLog.txt.
# 6/14/23.	wmk.
#
# Usage. bash  GetArchLog.sh [<terrid>]
#
# 	<terrid> = (oprional) '!' or territory ID to archive list for
#				! = same as for omittied, all entries.
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 6/1/23.	wmk.	original shell.
# 6/14/23.	wmk.	header updated.
#
# Notes. 
#
# set parameters P1=<terrid>
#
P1=$1
getall=0
if [ -z "$P1" ] || "$P1" == "!" ];then
 getall=1
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
  ~/sysprocs/LOGMSG "  GetArchLog - initiated from Make"
  echo "  GetArchLog - initiated from Make"
else
  ~/sysprocs/LOGMSG "  GetArchLog - initiated from Terminal"
  echo "  GetArchLog - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
echo "-- * GetArchLog.sql - Get DNC property ID given UnitAddress, Unit."  > SQLTemp.sql
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
echo ".open '$pathbase/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".separator \"|\""  >> SQLTemp.sql
echo ".headers ON"  >> SQLTemp.sql
echo ".output '$TEMP_PATH/ArchLog.txt'"  >> SQLTemp.sql
echo "-- find matching unitaddress, unit;" >> SQLTemp.sql
echo "SELECT *" >> SQLTemp.sql
echo "FROM ArchLog"  >> SQLTemp.sql
if [ $getall -eq 0 ];then
echo "WHERE TerrID IS  '$P1'"  >> SQLTemp.sql
fi
echo ";" >> SQLTemp.sql
echo ""  >> SQLTemp.sql
#endprocbody
sqlite3 < SQLTemp.sql
echo " DNC Archive Log on file $TEMP_PATH/ArchLog.txt"
echo "  GetArchLog complete."
~/sysprocs/LOGMSG "  GetArchLog complete."
# end GetArchLog.sh

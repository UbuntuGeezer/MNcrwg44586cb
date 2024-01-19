#!/bin/bash
# GetDNCpid.sh - Get DNC Property ID given unitaddress, unit.
# 6/1/23.	wmk.
#
# Usage. bash  GetDNCpid.sh
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
 echo "GetDNCpid <unitaddress> <unit> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  GetDNCpid - initiated from Make"
  echo "  GetDNCpid - initiated from Make"
else
  ~/sysprocs/LOGMSG "  GetDNCpid - initiated from Terminal"
  echo "  GetDNCpid - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
echo "-- * GetDNCpid.sql - Get DNC property ID given UnitAddress, Unit."  > SQLTemp.sql
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
echo "--CREATE TABLE DoNotCalls ("  >> SQLTemp.sql
echo "-- TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, "  >> SQLTemp.sql
echo "-- UnitAddress TEXT NOT NULL DEFAULT ' ', Unit TEXT, Phone TEXT, "  >> SQLTemp.sql
echo "-- Notes TEXT, RecDate TEXT, RSO INTEGER, Foreign INTEGER, PropID TEXT, "  >> SQLTemp.sql
echo "-- ZipCode TEXT, DelPending INTEGER, DelDate TEXT, Initials TEXT, "  >> SQLTemp.sql
echo "-- LangID INTEGER, "  >> SQLTemp.sql
echo "-- FOREIGN KEY (TerrID) "  >> SQLTemp.sql
echo "-- REFERENCES Territory(TerrID) "  >> SQLTemp.sql
echo "-- ON UPDATE CASCADE "  >> SQLTemp.sql
echo "-- ON DELETE SET DEFAULT);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--CREATE TABLE ArchivedDNCs ("  >> SQLTemp.sql
echo "-- TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, UnitAddress TEXT NOT NULL, "  >> SQLTemp.sql
echo "-- Unit TEXT, Phone TEXT, Notes TEXT, RecDate TEXT, RSO INTEGER, "  >> SQLTemp.sql
echo "-- Foreign INTEGER, PropID TEXT, ZipCode TEXT, DelPending INTEGER, "  >> SQLTemp.sql
echo "-- ArchDate TEXT, Initials TEXT );"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- find matching unitaddress, unit;" >> SQLTemp.sql
echo "SELECT PropID," >> SQLTemp.sql
echo "CASE WHEN DelPending = 0 OR DelPending ISNULL THEN 'Active' ELSE 'Inactive' END," >> SQLTemp.sql 
echo "TerrID," >> SQLTemp.sql
echo  "UnitAddress, Unit "  >> SQLTemp.sql
echo "FROM DoNotCalls"  >> SQLTemp.sql
echo "WHERE UnitAddress LIKE  '%$P1%'"  >> SQLTemp.sql
if [ "$P2" != " " ];then
 echo " AND Unit LIKE '%$P2%'; "  >> SQLTemp.sql
else
 echo ";" >> SQLTemp.sql
fi
echo ""  >> SQLTemp.sql
#endprocbody
sqlite3 < SQLTemp.sql
echo "  GetDNCpid complete."
~/sysprocs/LOGMSG "  GetDNCpid complete."
# end GetDNCpid.sh

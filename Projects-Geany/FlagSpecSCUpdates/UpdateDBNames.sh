#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash UpdateDBNames.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
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
P1=$1
TID=$P1
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
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  UpdateDBNames - initiated from Make"
  echo "  UpdateDBNames - initiated from Make"
else
  ~/sysprocs/LOGMSG "  UpdateDBNames - initiated from Terminal"
  echo "  UpdateDBNames - initiated from Terminal"
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

echo "-- * UpdateDBNames.sql - Update DBNames.db records."  > SQLTemp.sql
echo "-- * 1/30/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry.	/SCPA-Downloads/Special/SpecialDBs.db.DBNames is table of SC special"  >> SQLTemp.sql
echo "-- *		 databases"  >> SQLTemp.sql
echo "-- *		DBNameDates.csv is the record data for updating DBNames"  >> SQLTemp.sql
echo "-- * "  >> SQLTemp.sql
echo "-- * Exit.	DBNames.db entries are updated with entries from the .csv"  >> SQLTemp.sql
echo "-- *		 file DBNameDates.csv"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 1/30/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. The shell UpdateDBNames.sh has preamble code that generates the"  >> SQLTemp.sql
echo "-- * DBNameDates.csv file using *ls and *awk utilities."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * When *ls produces a list using -lh, the date modified field will"  >> SQLTemp.sql
echo "-- * either be <monthname> <day> <timestamp> or <monthname> <day> <year>"  >> SQLTemp.sql
echo "-- * the <year> and <timestamp> are differentiated with ':' being present"  >> SQLTemp.sql
echo "-- * in the <timestamp>. The <year> will only be present if it differs"  >> SQLTemp.sql
echo "-- * from the current year. *awk formats the .csv field the same as the"  >> SQLTemp.sql
echo "-- * RecordDate field <year>-<month>-<day>."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/RawData/SCPA/SCPA-Downloads/Special/SpecialDBs.db'"  >> SQLTemp.sql
echo ".headers off"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS NameUpdates;"  >> SQLTemp.sql
echo "CREATE TABLE NameUpDates("  >> SQLTemp.sql
echo " SpecDB TEXT,"  >> SQLTemp.sql
echo " ModDate TEXT, "  >> SQLTemp.sql
echo " base_status INTEGER DEFAULT 0, "  >> SQLTemp.sql
echo " Status INTEGER DEFAULT 0,"  >> SQLTemp.sql
echo " PRIMARY KEY(Status));"  >> SQLTemp.sql
echo ".import '$pathbase/RawData/SCPA/SCPA-Downloads/Special/DBNameDates.csv' NameUpdates"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS DBNames;"  >> SQLTemp.sql
echo "CREATE TABLE DBNames("  >> SQLTemp.sql
echo " DBName TEXT, ModDate TEXT, base_status INTEGER, Status INTEGER,"  >> SQLTemp.sql
echo " PRIMARY KEY(Status) );"  >> SQLTemp.sql
echo " "  >> SQLTemp.sql
echo "INSERT OR REPLACE INTO DBNames"  >> SQLTemp.sql
echo "SELECT SpecDB, ModDate, (rowid-1)*2, (rowid-1)*2 FROM NameUpdates;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- * END UpdateDBNames.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  UpdateDBNames complete."
~/sysprocs/LOGMSG "  UpdateDBNames complete."
#end proc

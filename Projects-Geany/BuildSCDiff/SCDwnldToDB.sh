#!/bin/bash
echo " ** SCDwnldToDB.sh out-of-date **";exit 1
echo " ** SCDwnldToDB.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 4/23/22.	wmk.
#	Usage. bash SCDwnldToDB.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
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
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  SCDwnldToDB - initiated from Make"
  echo "  SCDwnldToDB - initiated from Make"
else
  ~/sysprocs/LOGMSG "  SCDwnldToDB - initiated from Terminal"
  echo "  SCDwnldToDB - initiated from Terminal"
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

echo "-- SCDwnldToDB.psq - Process SCPA download.csv into DB."  > SQLTemp.sql
echo "--	4/27/22.	wmk."  >> SQLTemp.sql
echo "--"  >> SQLTemp.sql
echo "-- * Dependencies."  >> SQLTemp.sql
echo "-- * -------------"  >> SQLTemp.sql
echo "-- * DoSed.sh replaces 05 26 in this file with m2 d2 of the newest"  >> SQLTemp.sql
echo "-- *  download data."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Environment vars - "  >> SQLTemp.sql
echo "-- *	folderbase - host system folder base path for Territories"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 3/19/22.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 4/27/22.	wmk.	*pathbase* support."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. This query is in \"shell-ready\" format, where ($) environment"  >> SQLTemp.sql
echo "-- * vars will be substituted into the query at appropriate places. The"  >> SQLTemp.sql
echo "-- * expected environment vars are documented above in the Dependencies"  >> SQLTemp.sql
echo "-- * list."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo " "  >> SQLTemp.sql
echo "-- * subquery list."  >> SQLTemp.sql
echo "-- * --------------"  >> SQLTemp.sql
echo "-- * SCDwnldToDB - Process SCPA download.csv into DB."  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** SCDwnldToDB **********"  >> SQLTemp.sql
echo "-- *	4/27/22.	wmk."  >> SQLTemp.sql
echo "-- *--------------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * SCDwnldToDB - Process SCPA download.csv into DB."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *	($)folderbase/Territories/RawData/SCPA/SCPA-Downloads/Data0526.csv"  >> SQLTemp.sql
echo "-- *	  lastest download data from SCPA-Public_05-26.xlsx"  >> SQLTemp.sql
echo "-- *	($)folderbase = host base path for Territories"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results."  >> SQLTemp.sql
echo "-- *	SCPA_mm-dd.db AS main, full SCPA download from mm/dd"  >> SQLTemp.sql
echo "-- *		Datammdd - table of full download records whole county"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 3/19/22.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 4/27/22.	wmk.	*pathbase* support."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. By not explicitly using CREATE TABLE, sqlite will import the"  >> SQLTemp.sql
echo "-- * .csv records assuming that the 1st row is headers/field names. When"  >> SQLTemp.sql
echo "-- * the records are imported using the sqlite browser, the"  >> SQLTemp.sql
echo "-- * \"trim fields\" option also removes any whitespace from the table"  >> SQLTemp.sql
echo "-- * field names. When the records are imported using the .import SQL"  >> SQLTemp.sql
echo "-- * batch directive, whitespace is not removed. This produces a "  >> SQLTemp.sql
echo "-- * discrepancy between the older imports (e.g.04 16) and the newer"  >> SQLTemp.sql
echo "-- * imports (e.g. 06 19)."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * SCPA_DB2 as main;"  >> SQLTemp.sql
echo ".cd '$pathbase/RawData/SCPA/SCPA-Downloads'"  >> SQLTemp.sql
echo ".open 'SCPA_05-26.db'"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Data0526;"  >> SQLTemp.sql
echo ".headers ON"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".import 'Data0526' Data0526 "  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** END SCDwnldToDB **********;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
if [ "$USER" != "vncwmk3" ];then
 notify-send "SCDwnldToDB.sh" "SCDwnldToDB processing complete. $P1"
fi
echo "  SCDwnldToDB complete."
~/sysprocs/LOGMSG "  SCDwnldToDB complete."
#end proc

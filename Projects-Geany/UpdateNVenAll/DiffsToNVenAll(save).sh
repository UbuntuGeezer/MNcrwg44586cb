#!/bin/bash
echo " ** DiffsToNVenAll(save).sh out-of-date **";exit 1
echo " ** DiffsToNVenAll(save).sh out-of-date **";exit 1
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

echo "--DiffsToNVenAll.psq/sql - Integrate SC download differences into NVenAll."  > SQLTemp.sql
echo "--	2/9/22.	wmk."  >> SQLTemp.sql
echo "--"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 2/28/21.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 6/26/21.	wmk.	multihost support."  >> SQLTemp.sql
echo "-- * 8/25/21.	wmk.	spaces removed from Diffxxxx field names."  >> SQLTemp.sql
echo "-- * 11/3/21.	wmk.	total rewrite."  >> SQLTemp.sql
echo "-- * 12/3/21.	wmk.	DiffAcct field corrected to PropID."  >> SQLTemp.sql
echo "-- * 2/9/22.	wmk.	DelFlag test bug fix; NVenAll qualified with db2;"  >> SQLTemp.sql
echo "-- *			 db15.SCPA_02-05.db eliminated from queries."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. This query is expected to be integrated into a shell which"  >> SQLTemp.sql
echo "-- * will inherit or explicitly set ($)folderbase environment var to"  >> SQLTemp.sql
echo "-- * properly access the host's Territory file system."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * subquery list."  >> SQLTemp.sql
echo "-- * --------------"  >> SQLTemp.sql
echo "-- * DiffsToNVenAll - Integrate SC download differences into NVenAll."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** DiffsToNVenAll **********"  >> SQLTemp.sql
echo "-- *	1/9/22.	wmk."  >> SQLTemp.sql
echo "-- *---------------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * DiffsToNVenAll - Integrate SC download differences into NVenAll."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *	VeniceNTerritory.db - as db2, SCPA data for NV territory"  >> SQLTemp.sql
echo "-- *		NVenAll - SCPA property records"  >> SQLTemp.sql
echo "-- *	SCPADiff_m2-d2.db as db16,  Difference collection of new/updated"  >> SQLTemp.sql
echo "-- *	  property records between current and past SCPA downloads"  >> SQLTemp.sql
echo "-- *		Diff0205 - table of differences new/updated SCPA records"  >> SQLTemp.sql
echo "-- *		  where either last sale date or homestead exemption field(s)"  >> SQLTemp.sql
echo "-- *		  have changed"  >> SQLTemp.sql
echo "-- *		DiffAccts (future) table of property ids and territory ids of"  >> SQLTemp.sql
echo "-- *		  parcels in Diffm2md table {PropID, TerrID}"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results."  >> SQLTemp.sql
echo "-- *	VeniceNTerritory.db - as db2, SCPA data for NV territory"  >> SQLTemp.sql
echo "-- *		NVenAll - records with new from Diffm2d2 replacing records"  >> SQLTemp.sql
echo "-- *		  where parcel ID (Account #) matches."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 2/28/21.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 6/20/21.	wmk.	revert to full field names; multihost support."  >> SQLTemp.sql
echo "-- * 6/26/21.	wmk.	multihost code co02ented; ensure proper refs"  >> SQLTemp.sql
echo "-- * 					to Diff field names."  >> SQLTemp.sql
echo "-- * 11/3/21.	wmk.	total rewrite."  >> SQLTemp.sql
echo "-- * 12/3/21.	wmk.	DiffAcct field corrected to PropID."  >> SQLTemp.sql
echo "-- * 2/9/22.	wmk.	DelFlag test bug fix; NVenAll qualified with db2;"  >> SQLTemp.sql
echo "-- *					db15.SCPA_02-05.db eliminated from queries."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. All of the differences work has already been performed by"  >> SQLTemp.sql
echo "-- * SCNewVsNVenAll.sh;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * open junk as main, then open other dbs;"  >> SQLTemp.sql
echo ".open '$folderbase/Territories/DB-Dev/junk.db'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- move to DiffsToNVenAll.psq..."  >> SQLTemp.sql
echo "-- * Update NVenAll with Diff1102 differences;"  >> SQLTemp.sql
echo "attach '$folderbase/Territories/RawData/SCPA/SCPA-Downloads'"  >> SQLTemp.sql
echo "|| '/SCPADiff_02-05.db'"  >> SQLTemp.sql
echo "as db14;"  >> SQLTemp.sql
echo "attach '$folderbase/Territories/DB-Dev'"  >> SQLTemp.sql
echo "|| '/VeniceNTerritory.db'"  >> SQLTemp.sql
echo "as db2;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "WITH a AS (Select PropID FROM db14.DiffAccts"  >> SQLTemp.sql
echo "WHERE DelFlag is not '1')"  >> SQLTemp.sql
echo "INSERT OR REPLACE INTO db2.NVenAll"  >> SQLTemp.sql
echo "SELECT * FROM db14.Diff0205"  >> SQLTemp.sql
echo "WHERE \"Account#\" IN (SELECT PropID from a);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- ** END DiffsToNVenAll **********;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
#notify-send "DiffsToNVenAll.sh" "DiffsToNVenAll processing complete. $P1"
echo "  DiffsToNVenAll complete."
~/sysprocs/LOGMSG "  DiffsToNVenAll complete."
#end proc

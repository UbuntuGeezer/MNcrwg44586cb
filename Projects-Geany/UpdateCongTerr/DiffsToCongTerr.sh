#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash DiffsToCongTerr.sh
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
  ~/sysprocs/LOGMSG "  DiffsToCongTerr - initiated from Make"
  echo "  DiffsToCongTerr - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DiffsToCongTerr - initiated from Terminal"
  echo "  DiffsToCongTerr - initiated from Terminal"
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

echo "-- * DiffsToCongTerr.psq/sql - Integrate SC download differences into Terr86777."  > SQLTemp.sql
echo "-- *	4/26/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * DoSed must modify this query with m 2 and d 2 of the month/day of the"  >> SQLTemp.sql
echo "-- * current download."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 11/27/22.	wmk.	bug fix; DiffAcct corrected to PropID in DiffAccts"  >> SQLTemp.sql
echo "-- *			 query."  >> SQLTemp.sql
echo "-- * 2/4/23.	wmk.	comments corrected to CongTerr from NVenAll."  >> SQLTemp.sql
echo "-- * 4/25/23.	wmk.	PropID corrected to DiffAcct in query."  >> SQLTemp.sql
echo "-- * 4/26/23.	wmk.	DiffAcct changed back to PropID."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 4/27/22.	wmk.	modified for general use FL/SARA/86777."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 4/26/22.    wmk.   *pathbase* support."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 2/28/21.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 6/26/21.	wmk.	multihost support."  >> SQLTemp.sql
echo "-- * 8/25/21.	wmk.	spaces removed from Diffxxxx field names."  >> SQLTemp.sql
echo "-- * 11/3/21.	wmk.	total rewrite."  >> SQLTemp.sql
echo "-- * 12/3/21.	wmk.	DiffAcct field corrected to PropID."  >> SQLTemp.sql
echo "-- * 2/9/22.	wmk.	DelFlag test bug fix; NVenAll qualified with db2;"  >> SQLTemp.sql
echo "-- *			 db15.SCPA_mm-dd.db eliminated from queries."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. This query is expected to be integrated into a shell which"  >> SQLTemp.sql
echo "-- * will inherit or explicitly set ($)folderbase environment var to"  >> SQLTemp.sql
echo "-- * properly access the host's Territory file system."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * subquery list."  >> SQLTemp.sql
echo "-- * --------------"  >> SQLTemp.sql
echo "-- * DiffsToCongTerr - Integrate SC download differences into Terr86777."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** DiffsToCongTerr **********"  >> SQLTemp.sql
echo "-- *	4/26/23.	wmk."  >> SQLTemp.sql
echo "-- *---------------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * DiffsToCongTerr - Integrate SC download differences into Terr86777."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *	Terr86777.db - as db2, SCPA data for NV territory"  >> SQLTemp.sql
echo "-- *		Terr86777 - SCPA property records"  >> SQLTemp.sql
echo "-- *	SCPADiff_05-28.db as db16,  Difference collection of new/updated"  >> SQLTemp.sql
echo "-- *	  property records between current and past SCPA downloads"  >> SQLTemp.sql
echo "-- *		Diffmmdd - table of differences new/updated SCPA records"  >> SQLTemp.sql
echo "-- *		  where either last sale date or homestead exemption field(s)"  >> SQLTemp.sql
echo "-- *		  have changed"  >> SQLTemp.sql
echo "-- *		DiffAccts (future) table of property ids and territory ids of"  >> SQLTemp.sql
echo "-- *		  parcels in Diff05md table {DiffAcct, TerrID}"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results."  >> SQLTemp.sql
echo "-- *	Terr86777.db - as db2, SCPA data for NV territory"  >> SQLTemp.sql
echo "-- *		Terr86777 - records with new from Diff0528 replacing records"  >> SQLTemp.sql
echo "-- *		  where parcel ID (Account #) matches."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 11/27/22.	wmk.	bug fix; DiffAcct corrected to PropID in DiffAccts"  >> SQLTemp.sql
echo "-- *			 query; bug fix; no DelFlag field in DiffAccts."  >> SQLTemp.sql
echo "-- * 2/4/23.	wmk.	comments corrected to CongTerr from NVenAll."  >> SQLTemp.sql
echo "-- * 4/25/23.	wmk.	PropID corrected to DiffAcct in query."  >> SQLTemp.sql
echo "-- * 4/26/23.	wmk.	DiffAcct changed back to PropID."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 4/27/22.	wmk.	modified for general use FL/SARA/86777; *pathbase*"  >> SQLTemp.sql
echo "-- *			 support included."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 2/28/21.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 6/20/21.	wmk.	revert to full field names; multihost support."  >> SQLTemp.sql
echo "-- * 6/26/21.	wmk.	multihost code commented; ensure proper refs"  >> SQLTemp.sql
echo "-- * 					to Diff field names."  >> SQLTemp.sql
echo "-- * 11/3/21.	wmk.	total rewrite."  >> SQLTemp.sql
echo "-- * 12/3/21.	wmk.	DiffAcct field corrected to PropID."  >> SQLTemp.sql
echo "-- * 2/9/22.	wmk.	DelFlag test bug fix; NVenAll qualified with db2;"  >> SQLTemp.sql
echo "-- *					db15.SCPA_mm-dd.db eliminated from queries."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. All of the differences work has already been performed by"  >> SQLTemp.sql
echo "-- * SCNewVsCongTerr.sh;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * open junk as main, then open other dbs;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/junk.db'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- move to DiffsToCongTerr.psq..."  >> SQLTemp.sql
echo "-- * Update Terr86777 with Diff0528 differences;"  >> SQLTemp.sql
echo "attach '$pathbase/RawData/SCPA/SCPA-Downloads'"  >> SQLTemp.sql
echo "|| '/SCPADiff_05-28.db'"  >> SQLTemp.sql
echo "as db14;"  >> SQLTemp.sql
echo "attach '$pathbase/DB-Dev'"  >> SQLTemp.sql
echo "|| '/Terr86777.db'"  >> SQLTemp.sql
echo "as db2;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--WITH a AS (Select PropID FROM db14.DiffAccts)"  >> SQLTemp.sql
echo "--WHERE DelFlag is not '1')"  >> SQLTemp.sql
echo "WITH a AS (Select PropID FROM db14.DiffAccts)"  >> SQLTemp.sql
echo "INSERT OR REPLACE INTO db2.Terr86777"  >> SQLTemp.sql
echo "SELECT * FROM db14.Diff0528"  >> SQLTemp.sql
echo "WHERE \"Account#\" IN (SELECT PropID from a);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- ** END DiffsToCongTerr **********;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  DiffsToCongTerr complete."
~/sysprocs/LOGMSG "  DiffsToCongTerr complete."
#end proc

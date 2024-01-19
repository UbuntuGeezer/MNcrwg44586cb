#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 4/23/22.	wmk.
#	Usage. bash GetConfidentials.sh
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
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  GetConfidentials - initiated from Make"
  echo "  GetConfidentials - initiated from Make"
else
  ~/sysprocs/LOGMSG "  GetConfidentials - initiated from Terminal"
  echo "  GetConfidentials - initiated from Terminal"
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

echo "-- * GetConfidentials.sql - Get CONFIDENTIAL record information from master territory dbs."  > SQLTemp.sql
echo "-- *	6/9/22.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 6/9/22.	wmk.	original code."  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * DBs."  >> SQLTemp.sql
echo "-- * MultiMail.db - territory records for multiple occupancy addresses;"  >> SQLTemp.sql
echo "-- * PolyTerri.db - territory rercords for single occupancy addresses;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/junk.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo "	|| '/DB-Dev/MultiMail.db'"  >> SQLTemp.sql
echo "	AS db3;"  >> SQLTemp.sql
echo "--pragma db3.table_info(SplitProps);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo "	|| '/DB-Dev/PolyTerri.db'"  >> SQLTemp.sql
echo "	AS db5;"  >> SQLTemp.sql
echo "--pragma db5.table_info(TerrProps);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * output this to ConfidTerrList so have list for PUB_NOTES_xxx;"  >> SQLTemp.sql
echo ".output '$pathbase/Projects-Geany/DoTerrsWithCalc/Tracking/ConfidTerrList.txt'"  >> SQLTemp.sql
echo ".headers ON"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo "-- * get territory ids having CONFIDENTIAL records;"  >> SQLTemp.sql
echo "select distinct congterrid AS TerrID from SplitProps"  >> SQLTemp.sql
echo "where resident1 like '%confidential%'"  >> SQLTemp.sql
echo "union select distinct congterrid AS TerrID from TerrProps"  >> SQLTemp.sql
echo "where resident1 like '%confidential%'"  >> SQLTemp.sql
echo "  and delpending is not 1"  >> SQLTemp.sql
echo "order by TerrID;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * output this to ConfidList.txt so have list of CONFIDENTIALs;"  >> SQLTemp.sql
echo ".output '$pathbase/Projects-Geany/DoTerrsWithCalc/Tracking/ConfidList.csv'"  >> SQLTemp.sql
echo "select * from SplitProps"  >> SQLTemp.sql
echo "where resident1 like '%confidential%'"  >> SQLTemp.sql
echo "union select * from TerrProps"  >> SQLTemp.sql
echo "where resident1 like '%confidential%'"  >> SQLTemp.sql
echo "  and delpending is not 1"  >> SQLTemp.sql
echo "order by CongTerrID;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- * end GetConfidentials.sql;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
if [ "$USER" != "vncwmk3" ];then
 notify-send "GetConfidentials.sh" "GetConfidentials processing complete. $P1"
fi
echo "  GetConfidentials complete."
~/sysprocs/LOGMSG "  GetConfidentials complete."
#end proc

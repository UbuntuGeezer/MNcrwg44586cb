#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 4/23/22.	wmk.
#	Usage. bash SetDiffAcctsTerrIDs.sh
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
  ~/sysprocs/LOGMSG "  SetDiffAcctsTerrIDs - initiated from Make"
  echo "  SetDiffAcctsTerrIDs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  SetDiffAcctsTerrIDs - initiated from Terminal"
  echo "  SetDiffAcctsTerrIDs - initiated from Terminal"
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

echo "-- * SetDiffAcctsTerrIDs.psq.sql - Set TerrID fields in DiffAccts table."  > SQLTemp.sql
echo "-- *	5/27/22.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry.  SCPA-Downloads/SCPADiff_05-26.db is differences database."  >> SQLTemp.sql
echo "-- *		 /DB-Dev/MultiMail.db is multiunit territory records."  >> SQLTemp.sql
echo "-- *		 /DB-Dev/PolyTerri.db is single unit territory records."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 5/27/22.	wmk.	original code."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/RawData/SCPA/SCPA-Downloads/SCPADiff_05-26.db'"  >> SQLTemp.sql
echo "attach '$pathbase'"  >> SQLTemp.sql
echo " || '/DB-Dev/MultiMail.db'"  >> SQLTemp.sql
echo " AS db3;"  >> SQLTemp.sql
echo "attach '$pathbase'"  >> SQLTemp.sql
echo " || '/DB-Dev/PolyTerri.db'"  >> SQLTemp.sql
echo " AS db5;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * populate DiffAccts table DiffAcct entries."  >> SQLTemp.sql
echo "WITH a AS (SELECT \"Account#\" AS PropID, \"LastSaleDate\" AS WhenBought,"  >> SQLTemp.sql
echo " HomesteadExemption AS Hstead"  >> SQLTemp.sql
echo " from Diff0526)"  >> SQLTemp.sql
echo "INSERT INTO DiffAccts"  >> SQLTemp.sql
echo "SELECT PropID, HStead, SUBSTR(WhenBought,7,4), SUBSTR(WhenBought,1,2),"  >> SQLTemp.sql
echo " SUBSTR(WhenBought,4,2),0,''"  >> SQLTemp.sql
echo "FROM a;"  >> SQLTemp.sql
echo " "  >> SQLTemp.sql
echo "-- * grab territory IDs from MultiMail.SplitProps;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DISTINCT OwningParcel AS Acct,"  >> SQLTemp.sql
echo "CONGTERRID FROM db3.SplitProps"  >> SQLTemp.sql
echo " WHERE Acct"  >> SQLTemp.sql
echo " IN (SELECT \"Account#\" FROM Diff0526))"  >> SQLTemp.sql
echo "UPDATE DiffAccts"  >> SQLTemp.sql
echo "SET TerrID ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN DiffAcct IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT CongTerrID FROM a "  >> SQLTemp.sql
echo "  WHERE Acct IS DiffAcct)"  >> SQLTemp.sql
echo "ELSE TerrID"  >> SQLTemp.sql
echo "END"  >> SQLTemp.sql
echo "WHERE TerrID ISNULL "  >> SQLTemp.sql
echo " OR LENGTH(TerrID) = 0;"  >> SQLTemp.sql
echo "--;"  >> SQLTemp.sql
echo "-- * grab territory IDs from PolyTerri.TerrProps;"  >> SQLTemp.sql
echo "WITH a AS (SELECT DISTINCT OwningParcel AS Acct,"  >> SQLTemp.sql
echo "CONGTERRID FROM db5.TerrProps"  >> SQLTemp.sql
echo " WHERE Acct"  >> SQLTemp.sql
echo " IN (SELECT \"Account#\" FROM Diff0526))"  >> SQLTemp.sql
echo "UPDATE DiffAccts"  >> SQLTemp.sql
echo "SET terrid ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN DiffAcct IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT CongTerrID FROM a "  >> SQLTemp.sql
echo "  WHERE Acct IS DiffAcct)"  >> SQLTemp.sql
echo "ELSE TerrID"  >> SQLTemp.sql
echo "END"  >> SQLTemp.sql
echo "WHERE TerrID ISNULL "  >> SQLTemp.sql
echo " OR LENGTH(TerrID) = 0;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- * end SetDiffAcctsTerrIDs"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
if [ "$USER" != "vncwmk3" ];then
 notify-send "SetDiffAcctsTerrIDs.sh" "SetDiffAcctsTerrIDs processing complete. $P1"
fi
echo "  SetDiffAcctsTerrIDs complete."
~/sysprocs/LOGMSG "  SetDiffAcctsTerrIDs complete."
#end proc

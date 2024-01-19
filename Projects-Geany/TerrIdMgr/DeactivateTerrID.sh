#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash DeactivateTerrID.sh
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
  ~/sysprocs/LOGMSG "  DeactivateTerrID - initiated from Make"
  echo "  DeactivateTerrID - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DeactivateTerrID - initiated from Terminal"
  echo "  DeactivateTerrID - initiated from Terminal"
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

echo "-- * DeactivateTerrID.psq/sql - Deactivate records in TerrIDData for terr."  > SQLTemp.sql
echo "-- *	6/4/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 6/4/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. DeactivateTerrID sets the StatusCode = TerrID'D' and the"  >> SQLTemp.sql
echo "-- * TerrID = '000' for the territory xxx."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * This prevents any Territory processes from accessing the Territory"  >> SQLTemp.sql
echo "-- * information, while preserving the information for archiving. A second layer of"  >> SQLTemp.sql
echo "-- * protection is at the folder level; the file OBSOLETE, if present, indicates"  >> SQLTemp.sql
echo "-- * that a territory is out of circulation."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * open/attach db,s;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/junk.db'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo " AS db6;"  >> SQLTemp.sql
echo "--pragma db6.table_info(Territory);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * deactivate territory in TerrIDData;"  >> SQLTemp.sql
echo "UPDATE db6.Territory"  >> SQLTemp.sql
echo "SET StatusCode = TerrID,"  >> SQLTemp.sql
echo "TerrID = TerrID || 'D'"  >> SQLTemp.sql
echo "WHERE TerrID IS '965';"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- * END DeactivateTerr.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  DeactivateTerrID complete."
~/sysprocs/LOGMSG "  DeactivateTerrID complete."
#end proc

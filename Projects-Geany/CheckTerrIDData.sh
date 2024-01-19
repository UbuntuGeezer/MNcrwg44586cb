#!/bin/bash
# CheckTerrDefined.sh - Check if territory file system in place for terr xxx.
# 6/3/23.	wmk.
#
# Usage. bash CheckTerrDefined.sh <terrid>
#
#	<terrid> = territory id tocheck
#		
# Dependencies.
#
# Exit. Exit 0 if territory file system not in place
#		Exit 1 if territory file system is in place
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
  ~/sysprocs/LOGMSG "  CheckTerrDefined - initiated from Make"
  echo "  CheckTerrDefined - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CheckTerrDefined - initiated from Terminal"
  echo "  CheckTerrDefined - initiated from Terminal"
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

echo "-- * CheckTerrDefined.psq/sql - Check for territory defined within TerrIDData."  > SQLTemp.sql
echo "-- * 6/2/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 6/2/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo "SELECT TerrID from Territory"  >> SQLTemp.sql
echo "WHERE TerrID IS '864'"  >> SQLTemp.sql
echo ";"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- * END CheckTerrDefined.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
# checkpostscript.sh - check length of *TEMP_PATH/FoundTerrID.txt.
#   6/2/23. wmk.
if ! test -s $TEMP_PATH/FoundTerrID.txt;then
 idfound=0
else
 idfound=1
fi
if [ $idfound -eq 0 ];then
 exit 1
fi
echo "  CheckTerrDefined complete."
~/sysprocs/LOGMSG "  CheckTerrDefined complete."
#end proc

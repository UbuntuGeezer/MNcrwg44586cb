#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash ClearTerrSegs.sh
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
  ~/sysprocs/LOGMSG "  ClearTerrSegs - initiated from Make"
  echo "  ClearTerrSegs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ClearTerrSegs - initiated from Terminal"
  echo "  ClearTerrSegs - initiated from Terminal"
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

# preambleClear.sh - ClearTerrSegs preamble.
#	2/15/23.	wmk.
echo "WARNING: you are about to clear the segment definitions"
read -p " for territory 277... continue (y/n)? "
yn=${REPLY^^}
if [ "$yn" == "N" ];then
 echo "  Review TerrID.db segment definitions for territory $P1."
 echo "   ClearTerrSegs abandoned at user request."
 exit 1
else
 echo "  Proceeding to clear segment definitions for territory $P1... "
fi
# end preambleClear.sh
echo "-- * ClearTerrSegs.psq/sql - export territory segments to Terr264Streetstxt."  > SQLTemp.sql
echo "-- * 2/10/23.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 2/7/23.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 2/8/23.	wmk.	mod to write SQL \"WHERE\" snippet."  >> SQLTemp.sql
echo "-- * Notes."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".headers off"  >> SQLTemp.sql
echo ".output '$pathbase/$rupath/Terr264/segdefs.csv'"  >> SQLTemp.sql
echo "SELECT sqldef FROM SegDefs"  >> SQLTemp.sql
echo " WHERE TerrID IS '264'"  >> SQLTemp.sql
echo " ORDER BY RecNo;"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- * END ClearTerrSegss.sql;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  ClearTerrSegs complete."
~/sysprocs/LOGMSG "  ClearTerrSegs complete."
#end proc

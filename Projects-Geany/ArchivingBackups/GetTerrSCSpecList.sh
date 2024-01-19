#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash GetTerrSCSpecList.sh
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
  ~/sysprocs/LOGMSG "  GetTerrSCSpecList - initiated from Make"
  echo "  GetTerrSCSpecList - initiated from Make"
else
  ~/sysprocs/LOGMSG "  GetTerrSCSpecList - initiated from Terminal"
  echo "  GetTerrSCSpecList - initiated from Terminal"
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

echo "--* GetTerrSCSpecList.psq/sql - Get territory SC /Special db list."  > SQLTemp.sql
echo "--*	11/28/22.	wmk."  >> SQLTemp.sql
echo "--*"  >> SQLTemp.sql
echo "--* Modification History."  >> SQLTemp.sql
echo "--* 11/28/22.	wmk.	original code."  >> SQLTemp.sql
echo "--*"  >> SQLTemp.sql
echo "--* Notes."  >> SQLTemp.sql
echo "--* attach /DB-Dev/TerrIDData"  >> SQLTemp.sql
echo "--* set output to ArchivingBackups/SpecDumpList.txt, csv format, headers off"  >> SQLTemp.sql
echo "--* select SpecialDB from SpecialSC"  >> SQLTemp.sql
echo "--*  where TID is '116';"  >> SQLTemp.sql
echo "--*"  >> SQLTemp.sql
echo "--* ArchivingBackups/RUSpecDumpList.txt is list of RU/Special .dbs to include"  >> SQLTemp.sql
echo "--*  in territory dump."  >> SQLTemp.sql
echo "--*;"  >> SQLTemp.sql
echo ".cd '/home/vncwmk3/Territories/FL/SARA/86777'"  >> SQLTemp.sql
echo ".open './DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".headers off"  >> SQLTemp.sql
echo ".output '/home/vncwmk3/GitHub/TerritoriesCB/Projects-Geany/ArchivingBackups/SpecSCDumpList.txt'"  >> SQLTemp.sql
echo "select SpecialDB from SpecialSC"  >> SQLTemp.sql
echo " where TID IS '116';"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  GetTerrSCSpecList complete."
~/sysprocs/LOGMSG "  GetTerrSCSpecList complete."
#end proc

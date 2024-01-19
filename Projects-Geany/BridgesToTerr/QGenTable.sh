#!/bin/bash
echo " ** QGenTable.sh out-of-date **";exit 1
echo " ** QGenTable.sh out-of-date **";exit 1
# QGenTable.sh - Generate .csv from QTerrxxx.db for Calc/Excel.
#	10/5/22.	wmk.
#	Usage. bash QGenTable.sh <terrid>
#
#		<terrid> = territory ID to extract records for.
#		
# Dependencies.
# -------------
# This file was manually generated from the query QGenTable.sql
# resident in folder Queries-SQL/Utilities-DB-SQL. The section
# "proc body here" was inserted from QGenTable.sql, which should
# be considered static. If this query needs modification, it would
# be best to modify the .sql file, then re-insert its contents in
# the proc body for version consistency.
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# 10/5/22.	wmk.	comments tidied; jumpto function removed; procbodyhere,
#			 endprocbody standardized.
# Legacy mods.
# 5/2/22.	wmk.	*pathbase* support.
# 7/8/22.	wmk.	notify-send removed.
# Legacy mods.
# 4/7/21.	wmk.	original shell (template)
# 5/27/21.	wmk		modified for use with either home or Kay's system;
#				    folderbase vars added.
# 5/30/21.	wmk.	modified for multihost system support.
# 6/7/21.	wmk.	bug fixes; equality check ($)HOME, TEMP_PATH 
#					ensured set.
# 6/17/21.	wmk.	multihost code generalization.
# 6/19/21.	wmk.	Dependencies updated.
# 7/20/21.	wmk.	<terrid> parameter documented; superfluous #s 
#					removed.
if [ -z "$folderbase" ];then
if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  QGenTable - initiated from Make"
else
  ~/sysprocs/LOGMSG "  QGenTable - initiated from Terminal"
  echo "  QGenTable - initiated from Terminal"
fi
TEMP_PATH=$HOME/temp
#
P1=$1
if [ -z "$P1" ];then
 echo "QGenTable <terrid> missing parameter - abandoned."
 exit 1
fi
TID=$P1
TN=Terr
#	Environment vars:
NAME_BASE=Terr
Q_BASE=QTerr
SUFFX=.db
Q_NAME=$Q_BASE$TID$SUFFX
TBL_NAME1=$Q_BASE$TID
SC_DB=_SC.db
RU_DB=_RU.db
SC_SUFFX=_SCBridge
RU_SUFFX=_RUBridge
#
#procbodyhere
pushd ./ > $TEMP_PATH/bitbucket.txt
~/sysprocs/LOGMSG "   QGenTable.sh initiated from make."
echo "   QGenTable.sh initiated from make."
echo "--QGenTable. - Generate .csv from QTerrxxx." > SQLTemp.sql
echo ".cd '$pathbase/TerrData' " >> SQLTemp.sql
echo ".cd './$NAME_BASE$TID/Working-Files'" >> SQLTemp.sql
echo ".open $Q_NAME" >> SQLTemp.sql
echo ".shell echo \\"Generating $TBL_NAME1.csv\\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo ".shell rm $TBL_NAME1.csv" >> SQLTemp.sql
echo ".headers ON" >> SQLTemp.sql
echo ".output '$TBL_NAME1.csv'" >> SQLTemp.sql
echo "SELECT * FROM $TBL_NAME1;" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
#endprocbody
#
sqlite3 < SQLTemp.sql
#
popd >> $TEMP_PATH/bitbucket.txt
#end proc
~/sysprocs/LOGMSG "   QGenTable $TID complete."
echo "   QGenTable $TID complete."

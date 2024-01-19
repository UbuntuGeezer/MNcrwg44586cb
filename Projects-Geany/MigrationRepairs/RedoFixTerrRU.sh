#!/bin/bash
echo " ** RedoFixTerrRU.sh out-of-date **";exit 1
echo " ** RedoFixTerrRU.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# RedoFixTerrRU.sh - Redo FixTerrRUSpecDB makefile in territory xxx.
#	7/10/22.	wmk.
#
# Usage. bash RedoFixTerrRU.sh <terrid>
#
#	<fixpath> = path to territory (e.g. *pathbase*/*rupath)
#	<terrid> = territory ID for which to redo FixTerrRUSpecDB.
#
# Modification History.
# ---------------------
# 7/6/22.	wmk.	original code.
# 7/9/22.	wmk.	PutSQLSource path to mirror GetSQLSource; move DoSed upwards;
#			 add *make* Extract to sequence; PrepSQL target path added.
# 7/10/22.	wmk.	eliminate *fixpath parameter; use EditSQL/ReplaceFixFromSC.sh;	
#
P1=$1
if [ -z "$P1" ];then
 echo "RedoFixTerrRU <terrid> missing parameter(s) - abandoned."
 exit 1
fi
fixpath=$pathbase/$rupath
fix=Fix
terr=Terr
rusfx=RU.sql
ru=RU
echo $fixpath/$terr$P1/$fix$P1$rusfx
if ! test -f $fixpath/$terr$P1/$fix$P1$rusfx;then
  echo "RedoFixTerrRU $fix$P1$rusfx file does not exist - abandoned."
  exit 1
fi
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
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  RedoFixTerrRU $P1 - initiated from Make"
  echo "  RedoFixTerrRU $P1 - initiated from Make"
else
  ~/sysprocs/LOGMSG "  RedoFixTerrRU - initiated from Terminal"
  echo "  RedoFixTerrRU - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# procbodyhere.
projpath=$codebase/Projects-Geany/MigrationRepairs
altproj=$codebase/Projects-Geany/EditSQL
grep -q -e "\-\- \*\* FixFromSC" $fixpath/Terr$P1/$fix$P1$rusfx
if [ $? -eq 0 ];then
 cd $altproj
 ./ReplaceFixFromSC.sh $P1
else # FixFromSC not found in file
 echo " FixFromSC not found in $fix$P1$rusfx - skipping.."
fi
# endprocbody.
echo "  RedoFixTerrRU $P1 complete."
~/sysprocs/LOGMSG "  RedoFixTerrRU $P1 complete."
# end RedoRegenSpecDB.sh


#!/bin/bash
echo " ** ListTerrSpecDBs.sh out-of-date **";exit 1
echo " ** ListTerrSpecDBs.sh out-of-date **";exit 1
# ListTerrSpecDBs.sh - List /Special dbs used by territory.
# 7/8/23.	wmk.
#
# Usage. bash  ListTerrSpecDBs.sh <terrid>
#
# Entry. *rupath/Terr<terrid>/RegenSpecDB.sql = SQL source using /Special dbs.
#
# Exit.	list of .db statements accessing /Special dbs. output
#
# Modification History.
# ---------------------
# 6/29/23.	wmk.	original shell.
# 7/8/23.	wmk.	bug fix - not detecting OBSOLETE territory.
#
# Notes. 
#
# P1=<terrid>
#
P1=$1
if [ -z "$P1" ];then
 echo "ListTerrSpecDBs <terrid> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  ListTerrSpecDBs - initiated from Make"
  echo "  ListTerrSpecDBs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ListTerrSpecDBs - initiated from Terminal"
  echo "  ListTerrSpecDBs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
projpath=$codebase/Projects-Geany/UpdateRUDwnld
pushd ./ > /dev/null
cd $pathbase/$rupath
if test -f Terr$P1/OBSOLETE;then
 echo " Territory $P1 is OBSOLETE."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 0
fi
if ! test -f Terr$P1/RegenSpecDB.sql;then
 echo " Territory $P1 uses no /Special .db,s."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 0
fi
grep -e "'.*\.db" -r Terr$P1 --include "RegenSpecDB.sql" > $TEMP_PATH/dbSQLs.txt
sed "s?<terrid>?$P1?g" $projpath/awkfilterspecdbs.tmp > $projpath/awkfilterspecdbs.txt
mawk -f $projpath/awkfilterspecdbs.txt $TEMP_PATH/dbSQLs.txt
popd > /dev/null
#endprocbody
echo "  ListTerrSpecDBs $P1 complete."
~/sysprocs/LOGMSG "  ListTerrSpecDBs $P1 complete."
# end ListTerrSpecDBs.sh

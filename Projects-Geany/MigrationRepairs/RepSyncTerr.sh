#!/bin/bash
echo " ** RepSyncTerr.sh out-of-date **";exit 1
echo " ** RepSyncTerr.sh out-of-date **";exit 1
# RepSyncTerr.sh - Stub SC/SetSpecTerrs.sql.
#	5/11/23.	wmk.
#
# Usage. bash  RepSyncTerr.sh <path> <terrid>
#
#	<path> = SCPA-Downloads only
#	<terrid> = territory ID
#
# Entry. <path>/Special/SCSpecTerrsSorted.txt = sorted list of SC /Special terrs
#
# Dependencies.
#
# Modification History.
# ---------------------
# 5/11/23.	wmk.	original shell; adapted from SimpleSpecMake shell.
# Legacy mods.
# 5/6/23.	wmk.	original shell.
# 5/7/23.	wmk.	header corrections.
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "RepSyncTerr <path> <terrid> missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P1" != "$pathbase/$scpath" ];then
 echo "RepSyncTerr <path> <terrid> only for SCPA-Downloads - abandoned."
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
  ~/sysprocs/LOGMSG "  RepSyncTerr - initiated from Make"
  echo "  RepSyncTerr - initiated from Make"
else
  ~/sysprocs/LOGMSG "  RepSyncTerr - initiated from Terminal"
  echo "  RepSyncTerr - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
projpath=$codebase/Projects-Geany/MigrationRepairs
cd $P1/Terr$P2
 skip=0
 #
 grep -e "5/10/23 Note" SyncTerrToSpec.sql > $TEMP_PATH/scratchfile
 if [ $? -eq 0 ];then
  skip=1
  echo "  Terr$P2/SyncTerrToSpec.sql already processed - skipping.."
 fi
 #
 if [ $skip -eq 0 ];then
  echo "  replacing Terr$P2/SyncTerrToSpec..."
  sed "s?xxx?$P2?g" $codebase/Projects-Geany/SpecialSCdb/SyncTerrToSpec.psq \
    > SyncTerrToSpec.sql 
 fi
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  RepSyncTerr $P2 complete."
~/sysprocs/LOGMSG "  RepSyncTerr complete."
# end RepSyncTerr.sh

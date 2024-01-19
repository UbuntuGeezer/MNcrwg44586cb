#!/bin/bash
echo " ** FixAllSyncTerrs.sh out-of-date **";exit 1
echo " ** FixAllSyncTerrs.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# FixAllSyncTerrs.sh - Fix all SyncTerrs files on *rawbase*.
#	9/21/22.	wmk.
#
# Usage.  bash FixAllSyncTerrs.sh <rawbase> [<startTID> <endTID>]
#
#	<rawbase> = base path of Terryyy files 
#				(e.g. *pathbase*/RawData/RefUSA/RefUSA-Downloads)
#	<startTID> = (optional) starting TID; default 100
#	<endTID> = (optional) ending TID; default 999
#
# Modification History.
# ---------------------
# 6/14/22.	wmk.	original code; adapted from FixAllMakeSpecials.
# 9/21/22.	wmk.	modified for Chromebook.
#
P1=$1		# raw path
P2=$2		# starting terr	ID
P3=$3		# ending terr ID
if [ -z "$P1" ];then
 echo "FixAllSyncTerrs <rawbase> [ startTID | endTID ]missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P2" ];then
 P2=100
fi
if [ -z "$P3" ];then
 P3=999
fi
if ! test -d $P1;then
 echo "FixAllSyncTerrs path '$P1' does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  FixAllSyncTerrs - initiated from Make"
  echo "  FixAllSyncTerrs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllSyncTerrs - initiated from Terminal"
  echo "  FixAllSyncTerrs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/MigrationRepairs
cd $P1
# loop on BatchList.txt...
cd $projpath
seq $P2 $P3 > $projpath/BatchList.txt
file=$projpath/BatchList.txt
while read -e;do
 len=${#REPLY}
 fn=$REPLY
 TID=$fn
 #echo "TID = : '$TID'"
 # only do TIDs in range...
  echo "processing $fn/SyncTerrToSpec.sql ..."
  $projpath/FixSyncTerrs.sh $P1 $TID 
done < $file
#end proc body.
~/sysprocs/LOGMSG "  FixAllSyncTerrs $P1 $P2 $P3 complete."
echo "  FixAllSyncTerrs $P1 $P2 $P3 complete."
# end FixAllSyncTerrs.sh

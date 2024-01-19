#!/bin/bash
echo " ** RebuildAllFixRUs.sh out-of-date **";exit 1
echo " ** RebuildAllFixRUs.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# RebuildAllFixRUs.sh - Rebuild all FixyyySC.sh files on *pathbase*.
#	5/28/22.	wmk.
#
# Usage.  bash RebuildAllFixRUs.sh <rawbase> [<startTID> <endTID>]
#
#	<rawbase> = base path of Terryyy files 
#				(e.g. *pathbase*/RawData/RefUSA/RefUSA-Downloads)
#	<startTID> = (optional) starting TID; default 100
#	<endTID> = (optional) ending TID; default 999
#
# Modification History.
# ---------------------
# 5/28/22.	wmk.	original code; adapted from RebuildAllFixSCs.
# Legacy mods.
# 5/4/22.	wmk.	original code.
# 5/15/22.  wmk.   (automated) pathbase corrected to FL/SARA/86777.
# 5/16/22.	wmk.	code tidying.
# 5/28/22.  wmk.   (automated) TX/HDLG/9999 -> FL/SARA/86777.
#
P1=$1
P2=$2
P3=$3
if [ -z "$P1" ];then
 echo "RebuildAllFixRUs <rawbase> [ startTID | endTID ]missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P2" ];then
 P2=100
fi
if [ -z "$P3" ];then
 P3=999
fi
if ! test -d $P1;then
 echo "RebuildAllFixRUs path '$P1' does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  RebuildAllFixRUs - initiated from Make"
  echo "  RebuildAllFixRUs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  RebuildAllFixRUs - initiated from Terminal"
  echo "  RebuildAllFixRUs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/MigrationRepairs
cd $P1
ls -dlh Terr* > $projpath/TerrList.txt
if [ $? -ne 0 ];then
 echo "RebuildAllFixRUs no Terrxxx folders found - abandoned."
 ~/sysprocs/LOGMSG "  RebuildAllFixRUs no Terrxxx folders found - abandoned."
 exit 1
fi
awk '/dr/{print $9}' $projpath/TerrList.txt > $projpath/BatchList.txt
# loop on BatchList.txt...
cd $projpath
file=$projpath/BatchList.txt
while read -e;do
 len=${#REPLY}
 fn=${REPLY:0:len}
 TID=${fn:4}
 #echo "TID = : '$TID'"
 # only do TIDs in range...
 if [ $TID -ge $P2 ] && [ $TID -le $P3 ];then
  echo "processing $fn ..."
  $projpath/DoSed.sh $TID 
  #echo " will proceed with   make -f \$projpath/MakeRebuildFixRU ..."
  make -f $projpath/MakeRebuildFixRU
 fi
done < $file
#end proc body.
~/sysprocs/LOGMSG "  RebuildAllFixRUs $P1 complete."
echo "  RebuildAllFixRUs $P1 complete."
# end RebuildAllFixRUs.sh

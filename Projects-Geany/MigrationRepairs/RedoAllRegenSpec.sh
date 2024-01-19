#!/bin/bash
echo " ** RedoAllRegenSpec.sh out-of-date **";exit 1
echo " ** RedoAllRegenSpec.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# RedoAllRegenSpec.sh - Redo all MakeRegenSpecDB in range on RefUSA-Downloads.
#	6/7/22.	wmk.
#
# Usage.  bash RedoAllRegenSpec.sh [<startTID> <endTID>]
#
#	<startTID> = (optional) starting TID; default 100
#	<endTID> = (optional) ending TID; default 999
#
# Modification History.
# ---------------------
# 6/7/22.	wmk.	original code; adapted from FixAllMakeSpecials.
#
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "RedoAllRegenSpec <startTID> <endTID> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P1" ];then
 P1=100
fi
if [ -z "$P2" ];then
 P2=999
fi
targpath=$pathbase/RawData/RefUSA/RefUSA-Downloads
if ! test -d $targpath/Terr$P1;then
 echo "RedoAllRegenSpec path Terr$P1' does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  RedoAllRegenSpec - initiated from Make"
  echo "  RedoAllRegenSpec - initiated from Make"
else
  ~/sysprocs/LOGMSG "  RedoAllRegenSpec - initiated from Terminal"
  echo "  RedoAllRegenSpec - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/MigrationRepairs
cd $targpath
# activate this block if want to work from a list of territories.
#ls -dlh Terr* > $projpath/TerrList.txt
#if [ $? -ne 0 ];then
# echo "RedoAllRegenSpec no Terrxxx folders found - abandoned."
# ~/sysprocs/LOGMSG "  RedoAllRegenSpec no Terrxxx folders found - abandoned."
# exit 1
#fi
seq $P1 $P2 > $projpath/BatchList.txt
# loop on BatchList.txt...
cd $projpath
file=$projpath/BatchList.txt
while read -e;do
 len=${#REPLY}
 fn=${REPLY:0:len}
 TID=$fn
 #echo "TID = : '$TID'"
 # only do TIDs in range...
 # if [ $TID -ge $P1 ] && [ $TID -le $P2 ];then
  echo "processing Terr$TID/MakeRegenSpecDB ..."
  $projpath/RedoRegenSpecDB.sh $TID 
 #fi
done < $file
#end proc body.
~/sysprocs/LOGMSG "  RedoAllRegenSpec $P1 $P2 complete."
echo "  RedoAllRegenSpec $P1 $P2 complete."
# end RedoAllRegenSpec.sh

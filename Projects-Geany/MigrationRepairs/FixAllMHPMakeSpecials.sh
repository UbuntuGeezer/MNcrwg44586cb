#!/bin/bash
echo " ** FixAllMHPMakeSpecials.sh out-of-date **";exit 1
echo " ** FixAllMHPMakeSpecials.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# FixAllMHPMakeSpecials.sh - Fix all MakeSpecials files on *rawbase*.
#	9/21/22.	wmk.
#
# Usage.  bash FixAllMHPMakeSpecials.sh <rawbase> <startTID> <endTID>
#
#	<rawbase> = base path of Terryyy files 
#				(e.g. *pathbase*/RawData/RefUSA/RefUSA-Downloads)
#	<startTID> =  starting TID; default 100
#	<endTID> =  ending TID; default 999
#
# Modification History.
# ---------------------
# 6/3/22.	wmk.	original code; adapted from RebuildAllFixSCs.
# 6/7/22.	wmk.	FixMakeSpecials1 added to loop.
# 9/21/22.	wmk.	modified for Chromebook.
#
P1=$1		# rawbase path e.g. *pathbase*/RawData/RefUSA/RefUSA-Downloads
P2=$2		# starting terrid
P3=$3		# ending terrid
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixAllMHPMakeSpecials <rawbase> <startTID> <endTID> missing parameter(s) - abandoned."
 exit 1
fi
if ! test -d $P1;then
 echo "FixAllMHPMakeSpecials path '$P1' does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  FixAllMHPMakeSpecials - initiated from Make"
  echo "  FixAllMHPMakeSpecials - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllMHPMakeSpecials - initiated from Terminal"
  echo "  FixAllMHPMakeSpecials - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/MigrationRepairs
cd $P1
# activate this block if going from directory list.
#ls -dlh Terr* > $projpath/TerrList.txt
#if [ $? -ne 0 ];then
# echo "FixAllMHPMakeSpecials no Terrxxx folders found - abandoned."
# ~/sysprocs/LOGMSG "  FixAllMHPMakeSpecials no Terrxxx folders found - abandoned."
# exit 1
#fi
#awk '/dr/{print $9}' $projpath/TerrList.txt > $projpath/BatchList.txt
seq $P2 $P3 > $projpath/BatchList.txt
# loop on BatchList.txt...
cd $projpath
file=$projpath/BatchList.txt
while read -e;do
 len=${#REPLY}
 fn=${REPLY:0:len}
 TID=$fn
 #echo "TID = : '$TID'"
 # only do TIDs in range...
 #if [ $TID -ge $P2 ] && [ $TID -le $P3 ];then
  echo "processing $fn/MakeSpecials ..."
  $projpath/FixMakeSpecials.sh $P1 $TID
  $projpath/FixMakeSpecials1.sh $P1 $TID 
 #fi
done < $file
#end proc body.
~/sysprocs/LOGMSG "  FixAllMHPMakeSpecials $P1 $P2 $P3 complete."
echo "  FixAllMHPMakeSpecials $P1 $P2 $P3 complete."
# end FixAllMHPMakeSpecials.sh

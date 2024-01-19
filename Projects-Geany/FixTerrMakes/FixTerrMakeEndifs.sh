#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixTerrMake.sh - fix Make* files with *pathbase* support.
#	5/8/22.	wmk.
#
# Usage.  bash FixTerrMake <tid> <basepath>
#
#	<tid> = territory ID
#	<basepath> = path to territory folders (e.g. *pathbase*/RawData)
#
# Modification History.
# ---------------------
# 5/8/22.	wmk.	original code; adapted from FixTerrSQL.sh
P1=$1
P2=$2
P3=${3,,}
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixTerrMake <tid> <basepath> missing parameter(s) - abandoned."
 exit 1
fi
srcpath=$P2
if ! test -d $srcpath;then
 echo "FixTerrMake folder '$srcpath' does not exist - abandoned."
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
 export pathbase=$folderbase/Territories
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FixTerrMake - initiated from Make"
  echo "  FixTerrMake - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixTerrMake - initiated from Terminal"
  echo "  FixTerrMake - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
TID=$P1
FS=Make*
projpath=$codebase/Projects-Geany/FixMakes
#srcpath=$P2$subfolder (set above)
# proc body here.
cd $srcpath/Terr$TID
ls $FS > $TEMP_PATH/MakeList.txt
if [ $? -ne 0 ];then
 echo " FixTerrSQ No *make* files found in /Terr$TID.. skipping"
 exit 0
fi
#cat $TEMP_PATH/SQLList.txt
#exit 0
# check file contents...
file=$TEMP_PATH/MakeList.txt
while read -e;do
 len=${#REPLY}
 len1=$((len-4))
 fn=${REPLY:0:len}
 extstr=${REPLY:len1:4}
 echo "processing $fn ..."
 if [ "$extstr" != "bak" ];then
  $projpath/FixMakeEndifs.sh $srcpath/Terr$TID $fn
 else
  echo " skipping .back file."
 fi
done < $file
#end proc body.
if [ "$USER" != "vncwmk3" ];then
 notify-send "FixTerrMake" "$P1/$FN complete"
fi
~/sysprocs/LOGMSG "  FixTerrMake $P1/$FN complete."
echo "  FixTerrMake $P1/$FN complete."
# end FixTerrMake.sh

#!/bin/bash
echo " ** FixTerrPSQ.sh out-of-date **";exit 1
echo " ** FixTerrPSQ.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixTerrPSQ.sh - fix .sql with *pathbase* support.
#	5/9/22.	wmk.
#
# Usage.  bash FixTerrPSQ <tid> <basepath> [<extension>]
#
#	<tid> = territory ID
#	<basepath> = path to territory folders (e.g. *pathbase*/RawData)
#	<extension> = (optional) subfolder extension {ru,sc,none}
#					ru default
#			ru will path to RefUSA/RefUSA-Downloads
#			sc will path to SCPA/SCPA-Downloads
#			none will not add addtional path subfolders
#
# Modification History.
# ---------------------
# 5/9/22.	wmk.	original code; adapted from FixTerrSQL.sh
P1=$1
P2=$2
P3=${3,,}
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixTerrPSQ <tid> <basepath> [<extension>] missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P3" ];then
  P3=ru
fi
if [ "$P3" == "ru" ];then
  subpath=/RefUSA/RefUSA-Downloads
elif [ "$P3" == "sc" ];then
  subpath=/SCPA/SCPA-Downloads
elif [ "$P3" == "none" ];then
  subpath=
else
  echo "FixTerrPSQ unrecognized <extension> $P3 - abandoned."
  exit 1
fi
srcpath=$P2$subpath
if ! test -d $srcpath;then
 echo "FixTerrPSQ folder '$srcpath' does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  FixTerrPSQ - initiated from Make"
  echo "  FixTerrPSQ - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixTerrPSQ - initiated from Terminal"
  echo "  FixTerrPSQ - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
TID=$P1
FE=.psq
projpath=$codebase/Projects-Geany/FixPSQs
#srcpath=$P2$subfolder (set above)
# proc body here.
cd $srcpath/Terr$TID
ls *$FE > $TEMP_PATH/PSQList.txt
if [ $? -ne 0 ];then
 echo " FixTerrSQ No .psq files found in $subpath/Terr$TID.. skipping"
 exit 0
fi
#cat $TEMP_PATH/PSQList.txt
#exit 0
sed -i 's?.sql??g' $TEMP_PATH/PSQList.txt
# check file contents...
file=$TEMP_PATH/PSQList.txt
while read -e;do
 len=${#REPLY}
 fn=${REPLY:0:len}
 echo "processing $fn ..."
 $projpath/FixPSQ.sh $srcpath/Terr$TID $fn
done < $file
#end proc body.
if [ "$USER" != "vncwmk3" ];then
 notify-send "FixTerrPSQ" "$P1/$FN complete"
fi
~/sysprocs/LOGMSG "  FixTerrPSQ $P1/$FN complete."
echo "  FixTerrPSQ $P1/$FN complete."
# end FixTerrPSQ.sh

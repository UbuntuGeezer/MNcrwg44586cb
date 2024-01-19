#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixTerrPSQ.sh - fix .psq with *pathbase* support.
#	5/28/22.	wmk.
#
# Usage.  bash FixTerrSQL <tid> <basepath> [<extension>]
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
# 5/8/22.	wmk.	original code; adapted from FixMake.sh
# 5/28/22.	wmk.	notify-send removed.
P1=$1
P2=$2
P3=${3,,}
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixTerrSQL <tid> <basepath> [ ru | sc ] missing parameter(s) - abandoned."
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
  echo "FixTerrSQL unrecognized <extension> $P3 - abandoned."
  exit 1
fi
srcpath=$P2$subpath
if ! test -d $srcpath;then
 echo "FixTerrSQL folder '$srcpath' does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  FixTerrSQL - initiated from Make"
  echo "  FixTerrSQL - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixTerrSQL - initiated from Terminal"
  echo "  FixTerrSQL - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
TID=$P1
FE=.sql
projpath=$codebase/Projects-Geany/FixSQLs
#srcpath=$P2$subfolder (set above)
# proc body here.
cd $srcpath/Terr$TID
ls *$FE > $TEMP_PATH/SQLList.txt
if [ $? -ne 0 ];then
 echo " FixTerrSQ No .sql files found in $subpath/Terr$TID.. skipping"
 exit 0
fi
#cat $TEMP_PATH/SQLList.txt
#exit 0
sed -i 's?.sql??g' $TEMP_PATH/SQLList.txt
# check file contents...
file=$TEMP_PATH/SQLList.txt
while read -e;do
 len=${#REPLY}
 fn=${REPLY:0:len}
 echo "processing $fn ..."
 $projpath/FixSQL.sh $srcpath/Terr$TID $fn
done < $file
#end proc body.
~/sysprocs/LOGMSG "  FixTerrSQL $P1/$FN complete."
echo "  FixTerrSQL $P1/$FN complete."
# end FixTerrSQL.sh

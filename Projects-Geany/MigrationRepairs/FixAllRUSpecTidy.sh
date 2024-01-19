#!/bin/bash
echo " ** FixAllRUSpecTidy.sh out-of-date **";exit 1
echo " ** FixAllRUSpecTidy.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# FixAllRUSpecTidy.sh - Rebuild all FixyyySC.sh files on *pathbase*.
#	6/2/22.	wmk.
#
# Usage.  bash FixAllRUSpecTidy.sh <rawbase> [<count>]
#
#	<specpath> = /Special path of *Tidy.sql files 
#				(e.g. *pathbase*/RawData/RefUSA/RefUSA-Downloads)
#	<count> = (optional) count of files to process
#				default 100
#
# Modification History.
# ---------------------
# 6/2/22.	wmk.	original code; adapted from RebuildAllFixRUs.
#
P1=$1
P2=$2
if [ -z "$P1" ];then
 echo "FixAllRUSpecTidy <rawbase> [<count>] missing parameter(s) - abandoned."
 exit 1
fi
if ! test -d $P1;then
 echo "FixAllRUSpecTidy path '$P1' does not exist - abandoned."
 exit 1
fi
if [ -z "$P2" ];then
 P2=100
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
  ~/sysprocs/LOGMSG "  FixAllRUSpecTidy - initiated from Make"
  echo "  FixAllRUSpecTidy - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllRUSpecTidy - initiated from Terminal"
  echo "  FixAllRUSpecTidy - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/MigrationRepairs
cd $P1
ls -lh *Tidy.sql > $projpath/TidyList.txt
if [ $? -ne 0 ];then
 echo "FixAllRUSpecTidy no *Tidy.sql files found - abandoned."
 ~/sysprocs/LOGMSG "  FixAllRUSpecTidy no Terrxxx folders found - abandoned."
 exit 1
fi
awk '/Tidy.sql/{print $9}' $projpath/TidyList.txt > $projpath/BatchList.txt
# loop on BatchList.txt...
fcount=0
cd $projpath
file=$projpath/BatchList.txt
tidy=Tidy
while [ $fcount -lt $P2 ] && read -e;do
 len=${#REPLY}
 fn=${REPLY:0:len}
 # skip comment or empty line.
 if [ -z "$fn" ] || [ ${fn:0:1} == "#" ];then
  echo $fn > $TEMP_PATH/scratchfile
 else
  echo "processing $fn ..."
  grep -q -e "NVenAll > Terr86777" $P1/$fn
  if [ $? -ne 0 ];then
   sed -f sedVeniceN.txt -i $P1/$fn
   ((fcount=fcount+1))
  else
   echo "  $fn already fixed - skipping.."
  fi
 fi
done < $file
#end proc body.
~/sysprocs/LOGMSG "  FixAllRUSpecTidy $P1 complete."
echo "  FixAllRUSpecTidy $P1 complete."
# end FixAllRUSpecTidy.sh

#!/bin/bash
echo " ** FixAllNVenAllRefs.sh out-of-date **";exit 1
echo " ** FixAllNVenAllRefs.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# FixAllNVenAllRefs.sh - Repair all .psq, .sql on *pathbase*.
#	9/21/22.	wmk.
#
# Usage.  bash FixAllNVenAllRefs.sh <rawbase> [<lbound><ubound>]
#
#	<specpath> = /Special path of *Tidy.sql files 
#				(e.g. *pathbase*/RawData/RefUSA/RefUSA-Downloads)
#	<lbound> = (optional) lower bound of territories to process
#				default 100
#	<ubound> = (optional) upper bound of territories to process
#
# Entry. *projpath*/sedVeniceN.txt contains *sed* directives to perform
#	the fixes.
#
# Modification History.
# ---------------------
# 6/2/22.	wmk.	original code; adapted from RebuildAllFixRUs.
# 9/21/22.	wmk.	modified for Chromebook.
#
# Notes. All RefUSA-Downloads/Terrxxx/*.sql, .psq files may contain
# legacy references to VeniceNTerritory.db with NVenAll, NVenAccts tables.
# This shell goes through all these files, territory by territory,
# correcting the references to Terr86777 tables Terr86777, and All86777.
P1=$1
P2=$2
P3=$3
if [ -z "$P1" ];then
 echo "FixAllNVenAllRefs <rawbase> [<count>] missing parameter(s) - abandoned."
 exit 1
fi
if ! test -d $P1;then
 echo "FixAllNVenAllRefs path '$P1' does not exist - abandoned."
 exit 1
fi
if [ -z "$P2" ];then
 P2=100
fi
if [ -z "$P3" ];then
 P3=999
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
  ~/sysprocs/LOGMSG "  FixAllNVenAllRefs - initiated from Make"
  echo "  FixAllNVenAllRefs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllNVenAllRefs - initiated from Terminal"
  echo "  FixAllNVenAllRefs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/MigrationRepairs
cd $P1
ls -dlh Terr* > $projpath/TerrList.txt
if [ $? -ne 0 ];then
 echo "FixAllNVenAllRefs no ./Terr* folders found - abandoned."
 ~/sysprocs/LOGMSG "  FixAllNVenAllRefs no Terrxxx folders found - abandoned."
 exit 1
fi
awk '/dr/{print $9}' $projpath/TerrList.txt > $projpath/BatchList.txt
# loop on BatchList.txt...
fcount=0
cd $projpath
file=$projpath/BatchList.txt
tidy=Tidy
while read -e;do
 len=${#REPLY}
 fn=${REPLY:0:len}
 TID=${fn:4}
 #echo "TID = : '$TID'"
 # only do TIDs in range...
 if [ $TID -ge $P2 ] && [ $TID -le $P3 ];then
  echo "processing $TID ..."
  # now within Terr$TID obtain all .sql, .psq filenames
  fpath=$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$TID
  cd $fpath
  ls -lh *.sql > $projpath/SQLlhList.txt
  ls -lh *.psq >> $projpath/SQLlhList.txt
  awk '{print $9}' $projpath/SQLlhList.txt > $projpath/SQLList.txt
  # now loop on SQLList.txt...
  file2=$projpath/SQLList.txt
  while read -e; do
   len=${#REPLY}
   fn=${REPLY:0:len}
   grep -q -e "NVenAll > Terr86777" $fpath/$fn
   if [ $? -ne 0 ];then
   echo "  file $fn ..."
    sed -f $projpath/sedVeniceN.txt -i $fpath/$fn
   else
    echo "  $fn already fixed - skipping.."
   fi
  done < $file2
 fi
done < $file
#end proc body.
~/sysprocs/LOGMSG "  FixAllNVenAllRefs $P1 complete."
echo "  FixAllNVenAllRefs $P1 complete."
# end FixAllNVelAllRefs.sh

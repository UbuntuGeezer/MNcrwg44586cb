#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixAllTerrPSQs.sh - fix all .psq files in territory with *pathbase* support.
#	5/28/22.	wmk.
#
# Usage.  FixAllTerrPSQs.sh <sqlpath>
#
#	<sqlpath> = root path of PSQs (e.g. *pathbase*/RawData)
# Modification History.
# ---------------------
# 5/28/22.	wmk.	original code; adapted from FixMake.sh
subpath1=/RefUSA/RefUSA-Downloads
subpath2=/SCPA/SCPA-Downloads
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
  ~/sysprocs/LOGMSG "  FixAllTerrPSQs - initiated from Make"
  echo "  FixAllTerrPSQs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllTerrPSQs - initiated from Terminal"
  echo "  FixAllTerrPSQs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/FixSQLs
thisproj=$codebase/Projects-Geany/FixTerrSQLs
file=$thisproj/TIDList.txt
while read -e;do
 # loop on TIDList...
 len=${#REPLY}
 TID=${REPLY:0:len}
 firstchr=${REPLY:0:1}
 if [ "$firstchr" != "#" ];then
 echo "processing (RU) territory $TID ..."
 srcpath=$pathbase/RawData$subpath1/Terr$TID
 cd $srcpath
 if test -f $TEMP_PATH/SQLList.txt;then rm $TEMP_PATH/SQLList.txt;fi
 ls *.sql > $TEMP_PATH/SQLList.txt
 if [ $? -eq 0 ];then
  sed -i 's?.sql??g' $projpath/SQLList.txt
  file2=$TEMP_PATH/SQLList.txt
  # loop on SQL.txt (RU)
  while read -e;do
   len=${#REPLY}
   len2=$((len-4))
   fn=${REPLY:0:len2}
   # elminate *fn* # prefix when calling FixSQL shell...
   firstchr=${REPLY:0:1}
   if [ "$firstchr" != "#" ];then
    echo "processing $fn ..."
    $projpath/FixSQL.sh $srcpath $fn
   else
    echo " skipping $fn..."
   fi
  done < $file2
 fi
 echo "processing (SC) territory $TID ..."
 srcpath=$pathbase/RawData$subpath2/Terr$TID
 cd $srcpath
 if test -f $TEMP_PATH/SQLList.txt;then rm $TEMP_PATH/SQLList.txt;fi
 ls *.sql > $TEMP_PATH/SQLList.txt
 if [ $? -eq 0 ];then
  sed -i 's?.sql??g' $projpath/SQLList.txt
  file2=$TEMP_PATH/SQLList.txt
  # loop on SQL.txt (SC)
  while read -e;do
   len=${#REPLY}
   len2=$((len-4))
   fn=${REPLY:0:len2}
   firstchr=${REPLY:0:1}
   if [ "$firstchr" != "#" ];then
    echo "processing $fn ..."
    echo "srcpath = '$srcpath'"
    $projpath/FixSQL.sh $srcpath $fn
   else
    echo " skipping $fn ..."
   fi
  done < $file2
 fi
 else
  echo " skipping $TID ..."
 fi
done < $file
#end proc body.
~/sysprocs/LOGMSG "  FixAllTerrPSQs complete."
echo "  FixAllTerrPSQs complete."
# end FixAllTerrPSQs.sh

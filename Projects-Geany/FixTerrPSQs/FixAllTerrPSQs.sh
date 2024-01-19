#!/bin/bash
echo " ** FixAllTerrPSQs.sh out-of-date **";exit 1
echo " ** FixAllTerrPSQs.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixAllTerrPSQx.sh - fix all .psq files with *pathbase* support.
#	5/9/22.	wmk.
#
# Usage.  FixAllTerrPSQs.sh
#
#	<psqpath> = root path of psqs
#
# Entry. *thisproj*/TIDList.txt = list of territories to process.
#
# Modification History.
# ---------------------
# 5/9/22.	wmk.	original code; adapted from FixAllTerrSQLs.sh
subpath1=RefUSA/RefUSA-Downloads
subpath2=SCPA/SCPA-Downloads
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
  ~/sysprocs/LOGMSG "  FixAllTerrPSQx - initiated from Make"
  echo "  FixAllTerrPSQx - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllTerrPSQx - initiated from Terminal"
  echo "  FixAllTerrPSQx - initiated from Terminal"
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
 srcpath=$pathbase/RawData/$subpath1/Terr$TID
 cd $srcpath
 if test -f $TEMP_PATH/PSQList.txt;then rm $TEMP_PATH/PSQList.txt;fi
 ls *.psq > $TEMP_PATH/PSQList.txt
 if [ $? -eq 0 ];then
  sed -i 's?.psq??g' $projpath/PSQList.txt
  file2=$TEMP_PATH/PSQList.txt
  # loop on SQL.txt (RU)
  while read -e;do
   len=${#REPLY}
   len2=$((len-4))
   fn=${REPLY:0:len2}
   # elminate *fn* P2 suffix when calling FixSQL shell...
   firstchar=${REPLY:0:1}
   if [ "$firstchar" != "#" ];then
    echo "processing $fn ..."
    $projpath/FixSQL.sh $srcpath $fn
   else
    echo " skipping $fn..."
   fi
  done < $file2
 fi
 echo "processing (SC) territory $TID ..."
 srcpath=$pathbase/RawData/$subpath2/Terr$TID
 cd $srcpath
 if test -f $TEMP_PATH/PSQList.txt;then rm $TEMP_PATH/PSQList.txt;fi
 ls *.psq > $TEMP_PATH/PSQList.txt
 if [ $? -eq 0 ];then
  sed -i 's?.psq??g' $projpath/PSQList.txt
  file2=$TEMP_PATH/PSQList.txt
  # loop on SQL.txt (SC)
  while read -e;do
   len=${#REPLY}
   len2=$((len-4))
   fn=${REPLY:0:len2}
   firstchr=${REPLY:0:1}
   if [ "$firstchr" != "#" ];then
    echo "processing $fn ..."
    echo "srcpath = '$srcpath'"
    $projpath/FixSQL.sh $srcpath $fn psq
   else
    echo " skipping $fn ..."
   fi
  done < $file2
 fi
else
 echo " skipping $TID ..."
fi
 # get file list from subpath 2 and work
done < $file
#end proc body.
~/sysprocs/LOGMSG "  FixAllTerrPSQs  complete."
echo "  FixAllTerrPSQs  complete."
# end FixAllTerrPSQs.sh

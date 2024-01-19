#!/bin/bash
echo " ** FixAllTerrMakes.sh out-of-date **";exit 1
echo " ** FixAllTerrMakes.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixAllTerrMakes.sh - fix all Makefiles with *pathbase* support.
# 5/28/22.    wmk.   (automated) pathbase corrected to TX/HDLG/99999.
# 5/15/22.    wmk.   (automated) pathbase corrected to FL/SARA/86777.
#	5/9/22.	wmk.
#
# Usage.  FixAllTerrMakes.sh <sqlpath>
#
#	<sqlpath> = root path of SQLs
#
# Entry.  TIDList.txt = list of territories to process
#
# Modification History.
# ---------------------
# 5/8/22.	wmk.	original code; adapted from FixTerrSQL.sh.
# 5/9/22.	wmk.	ignore TIDList.txt lines with '#".
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
  ~/sysprocs/LOGMSG "  FixAllTerrMakes - initiated from Make"
  echo "  FixAllTerrMakes - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllTerrMakes - initiated from Terminal"
  echo "  FixAllTerrMakes - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/FixMakes
thisproj=$codebase/Projects-Geany/FixTerrMakes
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
 if test -f $TEMP_PATH/MakeList.txt;then rm $TEMP_PATH/MakeList.txt;fi
 ls Make* > $TEMP_PATH/MakeList.txt
 if [ $? -eq 0 ];then
  file2=$TEMP_PATH/MakeList.txt
  # loop on SQL.txt (RU)
  while read -e;do
   len=${#REPLY}
   len2=$((len-4))
   fn=${REPLY:0:len}
   extstr=${REPLY:len2:4}
   # elminate *fn* .back suffix when calling FixSQL shell...
   firstchr=${REPLY:0:1}
   if [ "$firstchr" != "#" ];then
    echo "processing $fn ..."
    if [ "$extstr" != "back" ];then
     $projpath/FixMake.sh $srcpath $fn
    else
     echo " skipping .back file."
    fi
   else
     echo " skipping $fn..."
   fi
  done < $file2
 fi
 echo "processing (SC) territory $TID ..."
 srcpath=$pathbase/RawData/$subpath2/Terr$TID
 cd $srcpath
 if test -f $TEMP_PATH/MakeList.txt;then rm $TEMP_PATH/MakeList.txt;fi
 ls Make* > $TEMP_PATH/MakeList.txt
 if [ $? -eq 0 ];then
  file2=$TEMP_PATH/MakeList.txt
  # loop on SQL.txt (SC)
  while read -e;do
   len=${#REPLY}
   len2=$((len-4))
   fn=${REPLY:0:len}
   extstr=${REPLY:len2:4}
   echo "processing $fn ..."
   echo "srcpath = '$srcpath'"
   if [ "$extstr" != "back" ];then
    $projpath/FixMake.sh $srcpath $fn
   else
    echo " skipping .back file."
   fi
  done < $file2
 else
  echo " No *Make* files in $srcpath"
 fi
 else
  echo " skipping $TID ..."
 fi
done < $file
#end proc body.
~/sysprocs/LOGMSG "  FixAllTerrMakes complete."
echo "  FixAllTerrMakes complete."
# end FixAllTerrMakes.sh

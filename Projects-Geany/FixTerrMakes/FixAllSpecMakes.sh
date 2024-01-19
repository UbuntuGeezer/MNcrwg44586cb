#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixAllSpecMakes.sh - fix all Makefiles with *pathbase* support.
#	5/10/22.	wmk.
#
# Usage.  FixAllSpecMakes.sh <makepath>
#
#	<makepath> = root path of *make* files
#
# Entry.  /Special downstream of <makepath>
#
# Modification History.
# ---------------------
# 5/8/22.	wmk.	original code; adapted from FixTerrSQL.sh
# 5/10/22.	wmk.	P2 references removed from code.
P1=$1
if [ -z "$P1" ];then
 echo "FixAllSpecMakes <makepath> missing parameter(s) - abandoned."
 exit 1
fi
if ! test -d $P1;then
 echo "FixAllSpecMakes path '$P1' does not exist - abandoned."
 exit 1
fi
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
  ~/sysprocs/LOGMSG "  FixAllSpecMakes - initiated from Make"
  echo "  FixAllSpecMakes - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllSpecMakes - initiated from Terminal"
  echo "  FixAllSpecMakes - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/FixMakes
thisproj=$codebase/Projects-Geany/FixTerrMakes
cd $P1
echo "processing (RU) /Special ..."
srcpath=$pathbase/RawData$subpath1/Special
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
   # elminate *fn* *back* suffix when calling FixSQL shell...
   echo "processing $fn ..."
   if [ "$extstr" != "back" ];then
    $projpath/FixMake.sh $srcpath $fn
   else
    echo " skipping .back file."
   fi
  done < $file2
fi
echo "processing (SC) /Special ..."
srcpath=$pathbase/RawData$subpath2/Special
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
~/sysprocs/LOGMSG "  FixAllSpecMakes $P1 complete."
echo "  FixAllSpecMakes $P1 complete."
# end FixAllSpecMakes.sh

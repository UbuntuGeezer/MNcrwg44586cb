#!/bin/bash
echo " ** FixAllSpecEndifs.sh out-of-date **";exit 1
echo " ** FixAllSpecEndifs.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixAllSpecEndifs.sh - fix all Makefile *endif #folderbase* errors.
# 5/28/22.    wmk.   (automated) pathbase corrected to TX/HDLG/99999.
# 5/15/22.    wmk.   (automated) pathbase corrected to FL/SARA/86777.
#	5/10/22.	wmk.
#
# Usage.  FixAllSpecEndifs.sh <makepath>
#
#	<makepath> = root path of *make* files
#
# Entry.  /Special downstream of <makepath>
#
# Modification History.
# ---------------------
# 5/10/22.	wmk.	original code; adapted from FixAllSpecMakes.sh
P1=$1
if [ -z "$P1" ];then
 echo "FixAllSpecEndifs <makepath> missing parameter(s) - abandoned."
 exit 1
fi
if ! test -d $P1;then
 echo "FixAllSpecEndifs path '$P1' does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  FixAllSpecEndifs - initiated from Make"
  echo "  FixAllSpecEndifs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllSpecEndifs - initiated from Terminal"
  echo "  FixAllSpecEndifs - initiated from Terminal"
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
   if [ "$extstr" != "back" ];then
    echo "processing $fn ..."
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
    $projpath/FixMakeEndifs.sh $srcpath $fn
   else
    echo " skipping .back file."
   fi
  done < $file2
 else
  echo " No *Make* files in $srcpath"
fi
~/sysprocs/LOGMSG "  FixAllSpecEndifs $P1 complete."
echo "  FixAllSpecEndifs $P1 complete."
# end FixAllSpecEndifs.sh

#!/bin/bash
echo " ** FixAllSpecPSQs.sh out-of-date **";exit 1
echo " ** FixAllSpecPSQs.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# FixAllSpecPSQs.sh - fix all /Special/*.psq with *pathbase* support.
#	5/9/22.	wmk.
#
# Usage.  FixAllSpecPSQs.sh <psqpath>
#
#	<psqpath> = root path of *PSQ* files
#
# Entry.  /Special downstream of <psqpath>
#
# Modification History.
# ---------------------
# 5/9/22.	wmk.	original code; adapted from FixAllSpecMakes.sh
#
P1=$1
if [ -z "$P1" ];then
 echo "FixAllSpecPSQs <psqpath> missing parameter(s) - abandoned."
 exit 1
fi
if ! test -d $P1;then
 echo "FixAllSpecPSQs path '$P1' does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  FixAllSpecPSQs - initiated from Make"
  echo "  FixAllSpecPSQs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixAllSpecPSQs - initiated from Terminal"
  echo "  FixAllSpecPSQs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# proc body here.
# get file list...
projpath=$codebase/Projects-Geany/FixPSQs
thisproj=$codebase/Projects-Geany/FixTerrPSQs
cd $P1
echo "processing (RU) /Special ..."
srcpath=$pathbase/RawData$subpath1/Special
cd $srcpath
if test -f $TEMP_PATH/PSQList.txt;then rm $TEMP_PATH/PSQList.txt;fi
ls *.psq > $TEMP_PATH/PSQList.txt
if [ $? -eq 0 ];then
  file2=$TEMP_PATH/PSQList.txt
  # loop on PSQ.txt (RU)
  while read -e;do
   len=${#REPLY}
   len2=$((len-4))
   fn=${REPLY:0:len}
   extstr=${REPLY:len2:4}
   # elminate *fn* P2 suffix when calling FixPSQ shell...
   echo "processing $fn ..."
   if [ "$extstr" != "bak" ];then
    $projpath/FixPSQ.sh $srcpath $fn
   else
    echo " skipping .bak file."
   fi
  done < $file2
fi
echo "processing (SC) /Special ..."
srcpath=$pathbase/RawData$subpath2/Special
cd $srcpath
if test -f $TEMP_PATH/PSQList.txt;then rm $TEMP_PATH/PSQList.txt;fi
ls *.psq > $TEMP_PATH/PSQList.txt
if [ $? -eq 0 ];then
  sed -i 's?.psq??g' $TEMP_PATH/PSQList.txt
  file2=$TEMP_PATH/PSQList.txt
  # loop on PSQ.txt (SC)
  while read -e;do
   len=${#REPLY}
   len2=$((len-4))
   fn=${REPLY:0:len}
   extstr=${REPLY:len2:4}
   echo "processing $fn ..."
   echo "srcpath = '$srcpath'"
   if [ "$extstr" != ".bak" ];then
    $projpath/FixPSQ.sh $srcpath $fn
   else
    echo " skipping .bak file."
   fi
  done < $file2
 else
  echo " No *PSQ* files in $srcpath"
fi
 #$projpath/FixPSQ.sh $P1 $fn
 #srcpath=$P1$subpath1
 #srcpath=$P1$subpath
# get file list from subpath 1 and work
# srcpath=$P1$subpath2
 # get file list from subpath 2 and work
#end proc body.
if [ "$USER" != "vncwmk3" ];then
 notify-send "FixAllSpecPSQs" "$P1 complete"
fi
~/sysprocs/LOGMSG "  FixAllSpecPSQs $P1 complete."
echo "  FixAllSpecPSQs $P1 complete."
# end FixAllSpecPSQs.sh

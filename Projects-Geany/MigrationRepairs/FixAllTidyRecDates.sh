#!/bin/bash
echo " ** FixAllTidyRecDates.sh out-of-date **";exit 1
echo " ** FixAllTidyRecDates.sh out-of-date **";exit 1
# FixAllTidyRecDates.sh - Eliminate SET RecordDate code from <spec>Tidy.sql,s.
# 3/2/23.	wmk.
#
# Usage. bash  FixAllTidyRecDates.sh [<spec-name>]
#
#	<spec-name> = (optional) single <spec-name>Tidy.sql to fix
#
# Exit. $TEMP_PATH/RUTidyList.txt = list of <spec>Tidy.sql,s
#
# Dependencies.
#
# Modification History.
# ---------------------
# 3/2/23.	wmk.	original shell.
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
doall=1
if [ ! -z "$P1" ];then
 doall=0
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  MoveOldCSVs - initiated from Make"
  echo "  MoveOldCSVs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  MoveOldCSVs - initiated from Terminal"
  echo "  MoveOldCSVs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
# notes. with separator "/", *6 is date field in RUSpecCSVList.txt, *12 is filename.
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase/$rupath/Special
ls *Tidy.sql > $TEMP_PATH/RUTidyList.txt
popd  > $TEMP_PATH/scratchfile
if [ $doall -ne 0 ];then
 wc -l $TEMP_PATH/RUTidyList.txt > $TEMP_PATH/linecount.txt 
 mawk '{print "nlines=" $1}' $TEMP_PATH/linecount.txt > setlines.sh
 #mawk '{if(NR==1){print "nlines=" $1}}' $pathbase/$rupath/Special/SortedCSVList.csv > setlines.sh
 chmod +x setlines.sh
 . ./setlines.sh
 echo "nlines = '$nlines'"
 # loop on ix.
 export ix=1
 file=$TEMP_PATH/RUTidyList.txt
 while read -e;do
  len=${#REPLY}
  len8=$(($len-8))
  spectidy=${REPLY:0:len8}
  ./FixTidyRecDates.sh $spectidy
  export ix=$((ix+1))
 done < $file
else	# only 1 file specified.
  ./FixTidyRecDates.sh $P1
fi
#endprocbody
echo "  FixAllTidyRecDates $P1 complete."
~/sysprocs/LOGMSG "  FixAllTidyRecDates $P1 complete."
# end FixAllTidyRecDates.sh

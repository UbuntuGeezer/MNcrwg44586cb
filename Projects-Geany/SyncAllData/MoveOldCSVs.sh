#!/bin/bash
echo " ** MoveOldCSVs.sh out-of-date **";exit 1
echo " ** MoveOldCSVs.sh out-of-date **";exit 1
# MoveOldCSVs.sh - Move stale dated .csv files to ./Previous.
# 3/1/23.	wmk.
#
# Usage. bash  MoveOldCSVs.sh <cutoff>
#
# Entry. $TEMP_PATH/RUSpecCSVList.txt = ls -lh list of RU/Special/.csv,s
#
# Dependencies.
#
# Modification History.
# ---------------------
# 3/1/23.	wmk.	original shell (template)
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
if [ -z "$P1" ];then
 echo "MoveOldCSVs <cutoff> missing parameter(s) - abandoned."
 exit 1
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
date -d "$P1" > cutdate
export cutoff=$cutdate
# notes. with separator "/", *6 is date field in RUSpecCSVList.txt, *12 is filename.
wc -l $TEMP_PATH/SortedCSVList.csv > $TEMP_PATH/linecount.txt 
mawk '{print "nlines=" $1}' $TEMP_PATH/linecount.txt > setlines.sh
#mawk '{if(NR==1){print "nlines=" $1}}' $pathbase/$rupath/Special/SortedCSVList.csv > setlines.sh
chmod +x setlines.sh
. ./setlines.sh
echo "nlines = '$nlines'"
# loop on ix.
export ix=1
while [ $ix -le $nlines ];do
 mawk -f awkmovecsv.txt $TEMP_PATH/SortedCSVList.csv > ./MoveCSV?.sh
 chmod +x ./MoveCSV?.sh
 #cat ./MoveCSV?.sh
 ./MoveCSV?.sh
 export ix=$((ix+1))
done
#endprocbody
echo "  MoveOldCSVs complete."
~/sysprocs/LOGMSG "  MoveOldCSVs complete."
# end MoveOldCSVs.sh

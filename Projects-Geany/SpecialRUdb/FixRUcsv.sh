#!/bin/bash
echo " ** FixRUcsv.sh out-of-date **";exit 1
echo " ** FixRUcsv.sh out-of-date **";exit 1
# FixRUcsv.sh - Fix RefUSA full .csv to summary .csv.
# 2/2/23.	wmk.
#
# Usage. bash  FixRUcsv.sh
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes. If a special db .csv is mistakenly downloaded with "full", this
# utility shell reduces the download to match "summary" (13 fields).
#
# P1=<special-db>
#
P1=$1
if [ -z "$P1" ];then
 echo "FixRUcsv <special-db> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
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
  ~/sysprocs/LOGMSG "  FixRUcsv - initiated from Make"
  echo "  FixRUcsv - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixRUcsv - initiated from Terminal"
  echo "  FixRUcsv - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
projpath=$codebase/Projects-Geany/SpecialRUdb
pushd ./ > /dev/null
cd $pathbase/$rupath/Special
mawk -F "," -f $projpath/awkfixcsv.txt $P1.csv > $TEMP_PATH/$P1.csv
cp -pv $TEMP_PATH/$P1.csv ./
popd > /dev/null
#endprocbody
echo "  FixRUcsv $P1 complete."
~/sysprocs/LOGMSG "  FixRUcsv $P1 complete."
# end FixRUcsv.sh

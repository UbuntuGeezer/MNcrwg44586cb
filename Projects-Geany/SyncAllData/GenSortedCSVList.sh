#!/bin/bash
echo " ** GenSortedCSVList.sh out-of-date **";exit 1
echo " ** GenSortedCSVList.sh out-of-date **";exit 1
# GenSortedCSVList.sh - Generate sorted .csv file list with dates..
# 3/1/23.	wmk.
#
# Usage. bash  GenSortedCSVList.sh
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 3/1/23.	wmk.	original shell (template)
#
# Notes. 
#
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
  ~/sysprocs/LOGMSG "  GenSortedCSVList.sh - initiated from Make"
  echo "  GenSortedCSVList.sh - initiated from Make"
else
  ~/sysprocs/LOGMSG "  GenSortedCSVList.sh - initiated from Terminal"
  echo "  GenSortedCSVList.sh - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
ls -lh $pathbase/$rupath/Special/*.csv > $TEMP_PATH/RUSpecCSVList.txt
gawk -F "/" -f awksortedcsvs.txt $TEMP_PATH/RUSpecCSVList.txt > $TEMP_PATH/SortedCSVList.csv
#endprocbody
echo "  GenSortedCSVList complete."
~/sysprocs/LOGMSG "  GenSortedCSVList.sh complete."
# end GenSortedCSVList.sh.sh

#!/bin/bash
echo " ** MovAllCsvs.sh out-of-date **";exit 1
echo " ** MovAllCsvs.sh out-of-date **";exit 1
# MovAllCsvs.sh - Copy all <special>.csvs in list from *DWNLD_PATH to RefUSA-Downloads/Special.
# 6/30/23.	wmk.
#
# Usage. bash   MovAllCsvs.sh
#
# Entry. *projpath/DBList.txt = list of <special> files to move.
#
# Dependencies.
#
# Exit.	*DWNLD_PATH/<special>.csv copied to RefUSA-Downloads/Special folder
#	for each <special> in DBList.txt

# Modification History.
# ---------------------
# 6/30/23.	wmk.	original shell.
#
# Notes. DBList.txt is a list of "special" names of .csv files to look for in
# the *DWNLD_PATH folder. 
#
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
  ~/sysprocs/LOGMSG "  MovAllCsvs - initiated from Make"
  echo "  MovAllCsvs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  MovAllCsvs - initiated from Terminal"
  echo "  MovAllCsvs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
projpath=$codebase/Projects-Geany/SpecialRUdb
file=$projpath/DBList.txt
while read -e;do
 fn=$REPLY
 if test -f $DWNLD_PATH/$fn.csv;then
  cp -pv $DWNLD_PATH/$fn.csv $pathbase/$rupath/Special
 fi
done < $file
#endprocbody
echo "  MovAllCsvs complete."
~/sysprocs/LOGMSG "  MovAllCsvs complete."
# end MovAllCsvs.sh

#!/bin/bash
echo " ** ValidateSpecDB.sh out-of-date **";exit 1
echo " ** ValidateSpecDB.sh out-of-date **";exit 1
# ValidateSpecDB.sh - Verify /Special/<db - name>.db RecordDate fields match <db - name>.csv file date.
# 3/3/23.	wmk.
#
# Usage. bash  ValidateSpecDB.sh <spec-db>
#
#	<spec-db> = /Special database name (no .db extension)
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 3/3/23.	wmk.	original shell (template)
#
# Notes. 
#
P1=$1
if [ -z "$P1" ];then
 echo "ValidateSpecDB <db-name> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  ValidateSpecDB - initiated from Make"
  echo "  ValidateSpecDB - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ValidateSpecDB - initiated from Terminal"
  echo "  ValidateSpecDB - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
projpath=$codebase/Projects-Geany/SyncAllData
csv=CSV
ls -lh $pathbase/$rupath/Special/$P1.csv > $TEMP_PATH/$P1$csv.txt
./DoSed1.sh $pathbase/$rupath/Special $P1 Spec_RUBridge
sqlite3 < $projpath/ValidateSpecDB.sql
if test -f $TEMP_PATH/CSVResults.sh;then 
 chmod +x $TEMP_PATH/CSVResults.sh
 . $TEMP_PATH/CSVResults.sh
 echo " *dbokay environment var set $P1 = '$dbokay'"
else
 echo " ** ValidateSpecDB FAILED - SQL error generating CSVResults.sh **"
 exit 1
fi
#endprocbody
echo "  ValidateSpecDB $P1 complete."
~/sysprocs/LOGMSG "  ValidateSpecDB $P1 complete."
# end ValidateSpecDB.sh

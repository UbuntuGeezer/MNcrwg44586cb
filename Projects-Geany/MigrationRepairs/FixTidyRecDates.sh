#!/bin/bash
echo " ** FixTidyRecDates.sh out-of-date **";exit 1
echo " ** FixTidyRecDates.sh out-of-date **";exit 1
# FixTidyRecDates.sh - Replace 'set RecordDates' block in <spec>Tidy.sql.
# 3/2/23.	wmk.
#
# Usage. bash  FixTidyRecDates.sh <spec-name>
#
#	<spec-db> = /Special database name (no .db suffix)
#
# Entry. /MigrationRepairs/sedfixTidy1.txt, sedfixTidy2.txt = *sed directives
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

if [ -z "$P1" ];then
 echo "FixTidyRecDates <spec-name> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  FixTidyRecDates - initiated from Make"
  echo "  FixTidyRecDates - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixTidyRecDates - initiated from Terminal"
  echo "  FixTidyRecDates - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
specpath=$pathbase/$rupath/Special
tidy=Tidy.sql
if ! test $specpath/$P1$tidy;then
 echo " ** $P1$tidy not found - FixTidyRecDates abandoned."
 exit 1 
fi
# check if already modified.
grep -q -e "(automated) remove set RecordDate code" $specpath/$P1$tidy
if [ $? -ne 0 ];then
 cp -pv $specpath/$P1$tidy $specpath/$P1$tidy.bak
 sed -f sedfixtidy.txt $specpath/$P1$tidy > $TEMP_PATH/scratchTidy.sql
 sed -i -f sedfixtidy1.txt $TEMP_PATH/scratchTidy.sql
 sed -f sedfixtidy2.txt $TEMP_PATH/scratchTidy.sql > $specpath/$P1$tidy
else
 echo "  $P1$tidy already updated. "
fi
#endprocbody
echo "  FixTidyRecDates complete."
~/sysprocs/LOGMSG "  FixTidyRecDates complete."
# end FixTidyRecDates.sh

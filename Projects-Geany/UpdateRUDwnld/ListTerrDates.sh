#!/bin/bash
echo " ** ListTerrDates.sh out-of-date **";exit 1
echo " ** ListTerrDates.sh out-of-date **";exit 1
# ListTerrDates.sh - List territory download dates.
# 6/27/23.	wmk.
#
# Usage. bash  ListTerrDates.sh <terrid>
#
#	<terrid> = territory ID
#
# Entry. *rupath/Terr<terrid>/Map<terrid>_RU.csv = latest download file.
#
# Exit. Map<terrid>_RU.csv file date output to terminal.
#
# Dependencies.
#
# Modification History.
# ---------------------
# 6/27/23.	wmk.	original shell.
#
# Notes. 
#
# P1=<terrid>
#
P1=$1
if [ -z "$P1" ];then
 echo "ListTerrDates <terrid> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  ListTerrDates - initiated from Make"
  echo "  ListTerrDates - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ListTerrDates - initiated from Terminal"
  echo "  ListTerrDates - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > /dev/null
cd $pathbase/$rupath/Terr$P1
suffx=_RU.csv
ls -lh Map$P1$suffx > $TEMP_PATH/dirlist.txt
mawk '{print $8 "  " $6 " " $7}' $TEMP_PATH/dirlist.txt
popd > /dev/null
#endprocbody
echo "  ListTerrDates complete."
~/sysprocs/LOGMSG "  ListTerrDates complete."
# end ListTerrDates.sh

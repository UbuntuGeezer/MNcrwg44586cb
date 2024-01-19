#!/bin/bash
echo " ** ListTerrUpdt.sh out-of-date **";exit 1
# ListTerrUpdt.sh - List extended info on Terrxxx/Updt* files.
# 7/7/23.	wmk.
#
# Usage. bash  ListTerrUpdt.sh  <terrid>
#
# Entry. /SCPA-Downloads/Terr<terrid>/Updt<terrid>M.csv, Updt<terrid>P.csv
#	files' date stamps contain last FlagSCUpdates dates.
#
# Exit. Updt<terrid>M.csv, Updt<terrid>P.csv -lh information output.
#
# Modification History.
# ---------------------
# 7/7/23.	wmk.	original shell.
#
# Notes. 
#
# P1=<terrid>
#
P1=$1
if [ -z "$P1" ];then
 echo "ListTerrUpdt <terrid> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  ListTerrUpdt - initiated from Make"
  echo "  ListTerrUpdt - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ListTerrUpdt - initiated from Terminal"
  echo "  ListTerrUpdt - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > /dev/null
cd $pathbase/$scpath/Terr$P1
if test -f OBSOLETE;then
 echo "Territory $P1 is OBSOLETE."
else
 ls -lh Updt*.csv
fi
popd > /dev/null
#endprocbody
echo "  ListTerrUpdt complete."
~/sysprocs/LOGMSG "  ListTerrUpdt complete."
# end ListTerrUpdt.sh

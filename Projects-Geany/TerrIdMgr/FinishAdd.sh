#!/bin/bash
# FinishAdd.sh - <description>.
# 6/4/23.	wmk.
#
# Usage. bash  FinishAdd.sh  <terrid>
#
#	<terrid> = territory ID to finish add for
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 6/4/23.	wmk.	original shell (template)
#
# Notes. 
#
# set parameters P1=<terrid>.
#
P1=$1
if [ -z "$P1" ];then
 echo "FinishAdd <terrid> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  FinishAdd - initiated from Make"
  echo "  FinishAdd - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FinishAdd - initiated from Terminal"
  echo "  FinishAdd - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
# run RUNewTerritory and SCNewTerritory *make files.
pushd ./ > /dev/null
cd $codebase/Projects-Geany/RUNewTerritory
./DoSed.sh $P1
make -f MakeRUNewTerritory
cd $codebase/Projects-Geany/SCNewTerritory
./DoSed.sh $P1
make -f MakeSCNewTerritory
popd > /dev/null
#endprocbody
echo "  FinishAdd complete."
~/sysprocs/LOGMSG "  FinishAdd complete."
# end FinishAdd.sh

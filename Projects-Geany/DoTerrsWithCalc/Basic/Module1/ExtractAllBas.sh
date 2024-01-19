#!/bin/bash
# ExtractAllBas.sh - Extract all .bas module from ProcessQTerrs12.ods Module1 source.
# 8/21/23.	wmk.
#
# Usage. bash  ExtractAllBas.sh 
#
# Entry. ModList.txt = list of all .bas modules in Module1
#		 Module1.bas = source code for all .bas modules from ProcessQTerrs12.ods
#
# Modification History.
# ---------------------
# 8/21/23.	wmk.	original shell.
#
# Notes. 
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
export pathbase=$folderbase/Territories/MN/CRWG/44586
export codebase=$folderbase/GitHub/TerritoriesCB/MNcrwg44586
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  ExtractAllBas - initiated from Make"
  echo "  ExtractAllBas - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ExtractAllBas - initiated from Terminal"
  echo "  ExtractAllBas - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
#currpwd=$$PWD
pushd ./ > /dev/null
modpath=$codebase/Projects-Geany/DoTerrsWithCalc
cd $modpath/Basic/Module1
# loop on all ModList.txt lines
file=$modpath/Basic/Module1/ModList.txt
while read -e;do
 echo "  processing $REPLY ..."
 $modpath/Basic/Module1/ExtractBasMod.sh $REPLY
done < $file
popd > /dev/null
#endprocbody
echo "  ExtractAllBas complete."
~/sysprocs/LOGMSG "  ExtractAllBas complete."
# end ExtractAllBas.sh
